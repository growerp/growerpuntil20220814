// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatMessage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatMessage _$$_ChatMessageFromJson(Map<String, dynamic> json) =>
    _$_ChatMessage(
      fromUserId: json['fromUserId'] as String?,
      chatMessageId: json['chatMessageId'] as String?,
      content: json['content'] as String?,
      creationDate:
          const DateTimeConverter().fromJson(json['creationDate'] as String?),
    );

Map<String, dynamic> _$$_ChatMessageToJson(_$_ChatMessage instance) =>
    <String, dynamic>{
      'fromUserId': instance.fromUserId,
      'chatMessageId': instance.chatMessageId,
      'content': instance.content,
      'creationDate': const DateTimeConverter().toJson(instance.creationDate),
    };
