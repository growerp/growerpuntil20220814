// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatRoomMember_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatRoomMember _$$_ChatRoomMemberFromJson(Map<String, dynamic> json) =>
    _$_ChatRoomMember(
      member: json['member'] == null
          ? null
          : User.fromJson(json['member'] as Map<String, dynamic>),
      hasRead: json['hasRead'] as bool?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$$_ChatRoomMemberToJson(_$_ChatRoomMember instance) =>
    <String, dynamic>{
      'member': instance.member,
      'hasRead': instance.hasRead,
      'isActive': instance.isActive,
    };
