/*
 * This GrowERP software is in the public domain under CC0 1.0 Universal plus a
 * Grant of Patent License.
 *
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any
 * warranty.
 * 
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software (see the LICENSE.md file). If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/domains/authenticate/blocs/auth_bloc.dart';
import 'package:core/services/api_result.dart';
import 'package:core/services/chat_server.dart';
import 'package:core/services/network_exceptions.dart';
import 'package:equatable/equatable.dart';
import '../../../api_repository.dart';
import '../models/models.dart';
import 'package:stream_transform/stream_transform.dart';

part 'chatRoom_event.dart';
part 'chatRoom_state.dart';

const _chatRoomLimit = 20;

EventTransformer<E> chatRoomDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  ChatRoomBloc(this.repos, this.chatServer, this.authBloc)
      : super(const ChatRoomState()) {
    on<ChatRoomFetch>(_onChatRoomFetch,
        transformer: chatRoomDroppable(Duration(milliseconds: 100)));
    on<ChatRoomSearchOn>(((event, emit) => emit(state.copyWith(search: true))));
    on<ChatRoomSearchOff>(
        ((event, emit) => emit(state.copyWith(search: false))));
    on<ChatRoomUpdate>(_onChatRoomUpdate);
    on<ChatRoomCreate>(_onChatRoomCreate);
  }

  final APIRepository repos;
  final ChatServer chatServer;
  final AuthBloc authBloc;

  Future<void> _onChatRoomFetch(
    ChatRoomFetch event,
    Emitter<ChatRoomState> emit,
  ) async {
    if (state.hasReachedMax && !event.refresh && event.searchString.isEmpty)
      return;
    try {
      // start from record zero for initial and refresh
      if (state.status == ChatRoomStatus.initial || event.refresh) {
        ApiResult<List<ChatRoom>> compResult =
            await repos.getChatRooms(searchString: event.searchString);
        return emit(compResult.when(
            success: (data) => state.copyWith(
                  status: ChatRoomStatus.success,
                  chatRooms: data,
                  hasReachedMax: data.length < _chatRoomLimit ? true : false,
                  searchString: '',
                ),
            failure: (NetworkExceptions error) => state.copyWith(
                status: ChatRoomStatus.failure, message: error.toString())));
      }
      // get first search page also for changed search
      if (event.searchString.isNotEmpty && state.searchString.isEmpty ||
          (state.searchString.isNotEmpty &&
              event.searchString != state.searchString)) {
        ApiResult<List<ChatRoom>> compResult =
            await repos.getChatRooms(searchString: event.searchString);
        return emit(compResult.when(
            success: (data) => state.copyWith(
                  status: ChatRoomStatus.success,
                  chatRooms: data,
                  hasReachedMax: data.length < _chatRoomLimit ? true : false,
                  searchString: event.searchString,
                ),
            failure: (NetworkExceptions error) => state.copyWith(
                status: ChatRoomStatus.failure, message: error.toString())));
      }
      // get next page also for search

      ApiResult<List<ChatRoom>> compResult =
          await repos.getChatRooms(searchString: event.searchString);
      return emit(compResult.when(
          success: (data) => state.copyWith(
                status: ChatRoomStatus.success,
                chatRooms: List.of(state.chatRooms)..addAll(data),
                hasReachedMax: data.length < _chatRoomLimit ? true : false,
              ),
          failure: (NetworkExceptions error) => state.copyWith(
              status: ChatRoomStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: ChatRoomStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onChatRoomUpdate(
    ChatRoomUpdate event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      List<ChatRoom> chatRooms = List.from(state.chatRooms);
      if (event.chatRoom.chatRoomId != null) {
        ApiResult<ChatRoom> compResult =
            await repos.updateChatRoom(event.chatRoom);
        return emit(compResult.when(
            success: (data) {
              int index = chatRooms.indexWhere(
                  (element) => element.chatRoomId == event.chatRoom.chatRoomId);
              chatRooms[index] = data;
              return state.copyWith(
                  status: ChatRoomStatus.success, chatRooms: chatRooms);
            },
            failure: (NetworkExceptions error) => state.copyWith(
                status: ChatRoomStatus.failure, message: error.toString())));
      } else {
        // add
        ApiResult<ChatRoom> compResult =
            await repos.createChatRoom(event.chatRoom);
        return emit(compResult.when(
            success: (data) {
              chatRooms.insert(0, data);
              return state.copyWith(
                  status: ChatRoomStatus.success, chatRooms: chatRooms);
            },
            failure: (NetworkExceptions error) => state.copyWith(
                status: ChatRoomStatus.failure, message: error.toString())));
      }
    } catch (error) {
      emit(state.copyWith(
          status: ChatRoomStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onChatRoomCreate(
    ChatRoomCreate event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      List<ChatRoom> chatRooms = List.from(state.chatRooms);
      // private chatroom exist?
      if (event.chatRoom.chatRoomName == null) {
        // get chatroom where current user and toUserId are members, name is null
        ApiResult<List<ChatRoom>> roomsResult = await repos.getChatRooms(
            chatRoomName: ' ', // server should interprete as null
            userId: event.chatRoom.getToUserId(event.fromUserId));
        dynamic result = roomsResult.when(
            success: (data) => data,
            failure: (NetworkExceptions error) => state.copyWith(
                status: ChatRoomStatus.failure, message: error.toString()));
        if (result is ChatRoomState) return emit(result);
        if (result.length == 1) {
          // exist, so activate 2 members
          List<ChatRoomMember> members = [];
          for (ChatRoomMember member in result[0].members)
            members.add(member.copyWith(isActive: true));
          add(ChatRoomUpdate(
              result[0].copyWith(members: members), event.fromUserId));
        } else {
          // get chatRoom by provided name
          ApiResult<List<ChatRoom>> roomsResult = await repos.getChatRooms(
              chatRoomName: event.chatRoom.chatRoomName,
              userId: event.chatRoom.getToUserId(event.fromUserId));
          dynamic response = roomsResult.when(
              success: (data) => data,
              failure: (NetworkExceptions error) => state.copyWith(
                  status: ChatRoomStatus.failure, message: error.toString()));
          if (response is ChatRoomState) return emit(result);

          if (result.length == 1) {
            // exist so activate all members
            List<ChatRoomMember> members = [];
            for (ChatRoomMember member in result[0].members)
              members.add(member.copyWith(isActive: true));
            add(ChatRoomUpdate(
                result[0].copyWith(members: members), event.fromUserId));
          } else {
            // add new chatroom
            ApiResult<ChatRoom> roomsResult =
                await repos.createChatRoom(event.chatRoom);
            dynamic result = roomsResult.when(
                success: (data) => data,
                failure: (NetworkExceptions error) => state.copyWith(
                    status: ChatRoomStatus.failure, message: error.toString()));
            if (result is ChatRoomState) return emit(result);
            chatRooms.add(result);
            emit(state.copyWith(chatRooms: chatRooms));
          }
        }
      } else {
        // new group with name
        ApiResult<ChatRoom> roomsResult =
            await repos.createChatRoom(event.chatRoom);
        dynamic response = roomsResult.when(
            success: (data) => data,
            failure: (NetworkExceptions error) => state.copyWith(
                status: ChatRoomStatus.failure, message: error.toString()));
        if (response is ChatRoomState) return emit(response);
        chatRooms.add(response);
        emit(state.copyWith(chatRooms: chatRooms));
      }
    } catch (error) {
      emit(state.copyWith(
          status: ChatRoomStatus.failure, message: error.toString()));
    }
  }
}
