// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Authenticate _$$_AuthenticateFromJson(Map<String, dynamic> json) =>
    _$_Authenticate(
      apiKey: json['apiKey'] as String?,
      moquiSessionToken: json['moquiSessionToken'] as String?,
      company: json['company'] == null
          ? null
          : Company.fromJson(json['company'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      stats: json['stats'] == null
          ? null
          : Stats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AuthenticateToJson(_$_Authenticate instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'moquiSessionToken': instance.moquiSessionToken,
      'company': instance.company,
      'user': instance.user,
      'stats': instance.stats,
    };
