// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatRoom_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatRoom _$$_ChatRoomFromJson(Map<String, dynamic> json) => _$_ChatRoom(
      chatRoomId: json['chatRoomId'] as String?,
      chatRoomName: json['chatRoomName'] as String?,
      lastMessage: json['lastMessage'] as String?,
      isPrivate: json['isPrivate'] as bool?,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => ChatRoomMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$$_ChatRoomToJson(_$_ChatRoom instance) =>
    <String, dynamic>{
      'chatRoomId': instance.chatRoomId,
      'chatRoomName': instance.chatRoomName,
      'lastMessage': instance.lastMessage,
      'isPrivate': instance.isPrivate,
      'members': instance.members,
    };
