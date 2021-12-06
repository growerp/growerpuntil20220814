// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      partyId: json['partyId'] as String?,
      userId: json['userId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      loginDisabled: json['loginDisabled'] as bool?,
      loginName: json['loginName'] as String?,
      email: json['email'] as String?,
      groupDescription: json['groupDescription'] as String?,
      userGroupId: json['userGroupId'] as String?,
      language: json['language'] as String?,
      externalId: json['externalId'] as String?,
      image: const Uint8ListConverter().fromJson(json['image'] as String?),
      companyPartyId: json['companyPartyId'] as String?,
      companyName: json['companyName'] as String?,
      companyAddress: json['companyAddress'] == null
          ? null
          : Address.fromJson(json['companyAddress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'partyId': instance.partyId,
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'loginDisabled': instance.loginDisabled,
      'loginName': instance.loginName,
      'email': instance.email,
      'groupDescription': instance.groupDescription,
      'userGroupId': instance.userGroupId,
      'language': instance.language,
      'externalId': instance.externalId,
      'image': const Uint8ListConverter().toJson(instance.image),
      'companyPartyId': instance.companyPartyId,
      'companyName': instance.companyName,
      'companyAddress': instance.companyAddress,
    };
