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

import 'package:core/domains/domains.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chatRoom_model.freezed.dart';
part 'chatRoom_model.g.dart';

// backend relation: product -> chatRoom -> chatRoomReservation -> orderItem

@freezed
class ChatRoom with _$ChatRoom {
  ChatRoom._();
  factory ChatRoom({
    String? chatRoomId,
    String? chatRoomName,
    String? lastMessage,
    bool? isPrivate,
    @Default([]) List<ChatRoomMember> members,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  int getMemberIndex(String userId) {
    return members.indexWhere((element) => element.member?.userId == userId);
  }

  String getChatRoomName(String currentUserId) {
    if (chatRoomName != null) return chatRoomName!;
    ChatRoomMember chatRoomMember = members
        .firstWhere((element) => element.member?.userId != currentUserId);
    return chatRoomName ??
        "${chatRoomMember.member?.firstName} ${chatRoomMember.member?.lastName}";
  }

  String? getToUserId(String currentUserId) {
    ChatRoomMember chatRoomMember = members
        .firstWhere((element) => element.member?.userId != currentUserId);
    return chatRoomMember.member?.userId;
  }

  String? getFromUserId(String currentUserId) {
    ChatRoomMember chatRoomMember = members
        .firstWhere((element) => element.member?.userId == currentUserId);
    return chatRoomMember.member?.userId;
  }

  ChatRoomMember? getFromMember(String currentUserId) {
    return members
        .firstWhere((element) => element.member?.userId == currentUserId);
  }

  String toString() => 'ChatRoom name: $chatRoomName[$chatRoomId]';
}
