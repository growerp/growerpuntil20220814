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

part of 'chatRoom_bloc.dart';

abstract class ChatRoomEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatRoomFetch extends ChatRoomEvent {
  final bool refresh;
  final int limit;
  final String searchString;
  ChatRoomFetch(
      {this.refresh = false, this.limit = 20, this.searchString = ''});
  @override
  String toString() =>
      "FetchChatRoom refresh: $refresh limit: $limit, search: $searchString";
}

class ChatRoomSearchOn extends ChatRoomEvent {}

class ChatRoomSearchOff extends ChatRoomEvent {}

class ChatRoomUpdate extends ChatRoomEvent {
  final String fromUserId; // needed to find correct member of chatRoom
  final ChatRoom chatRoom;
  ChatRoomUpdate(this.chatRoom, this.fromUserId);
  @override
  String toString() => "UpdateChatRoom: $chatRoom "
      "hasRead: ${chatRoom.getFromMember(fromUserId)!.hasRead} "
      "isActive: ${chatRoom.getFromMember(fromUserId)!.isActive}";
}

class ChatRoomCreate extends ChatRoomEvent {
  final String fromUserId; // needed to find correct member of chatRoom
  final ChatRoom chatRoom;
  ChatRoomCreate(this.chatRoom, this.fromUserId);
  @override
  String toString() => "AddChatRoom: $chatRoom";
}

class ChatRoomReceiveWsChatMessage extends ChatRoomEvent {
  final WsChatMessage chatMessage;
  ChatRoomReceiveWsChatMessage(this.chatMessage);
  @override
  String toString() =>
      "Receive chat server message in ChatRoombloc ${chatMessage.content} "
      "chatroom: ${chatMessage.chatRoomId} from: ${chatMessage.fromUserId} "
      " to: ${chatMessage.toUserId} ";
}
