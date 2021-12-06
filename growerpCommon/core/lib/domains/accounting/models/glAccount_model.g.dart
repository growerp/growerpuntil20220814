// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glAccount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GlAccount _$$_GlAccountFromJson(Map<String, dynamic> json) => _$_GlAccount(
      id: json['id'] as String?,
      l: json['l'] as int?,
      classId: json['classId'] as String?,
      isDebit: json['isDebit'] as String?,
      accountName: json['accountName'] as String?,
      postedBalance: (json['postedBalance'] as num?)?.toDouble(),
      rollUp: (json['rollUp'] as num?)?.toDouble(),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => GlAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_GlAccountToJson(_$_GlAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'l': instance.l,
      'classId': instance.classId,
      'isDebit': instance.isDebit,
      'accountName': instance.accountName,
      'postedBalance': instance.postedBalance,
      'rollUp': instance.rollUp,
      'children': instance.children,
    };
