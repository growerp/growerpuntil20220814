// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wsChatMessage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WsChatMessage _$$_WsChatMessageFromJson(Map<String, dynamic> json) =>
    _$_WsChatMessage(
      toUserId: json['toUserId'] as String?,
      fromUserId: json['fromUserId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      chatRoomId: json['chatRoomId'] as String?,
    );

Map<String, dynamic> _$$_WsChatMessageToJson(_$_WsChatMessage instance) =>
    <String, dynamic>{
      'toUserId': instance.toUserId,
      'fromUserId': instance.fromUserId,
      'content': instance.content,
      'chatRoomId': instance.chatRoomId,
    };
