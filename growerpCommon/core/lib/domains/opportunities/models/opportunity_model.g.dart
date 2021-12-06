// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Opportunity _$$_OpportunityFromJson(Map<String, dynamic> json) =>
    _$_Opportunity(
      lastUpdated:
          const DateTimeConverter().fromJson(json['lastUpdated'] as String?),
      opportunityId: json['opportunityId'] as String?,
      opportunityName: json['opportunityName'] as String?,
      description: json['description'] as String?,
      estAmount:
          const DecimalConverter().fromJson(json['estAmount'] as String?),
      estProbability: json['estProbability'] as int?,
      stageId: json['stageId'] as String?,
      nextStep: json['nextStep'] as String?,
      employeeUser: json['employeeUser'] == null
          ? null
          : User.fromJson(json['employeeUser'] as Map<String, dynamic>),
      leadUser: json['leadUser'] == null
          ? null
          : User.fromJson(json['leadUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_OpportunityToJson(_$_Opportunity instance) =>
    <String, dynamic>{
      'lastUpdated': const DateTimeConverter().toJson(instance.lastUpdated),
      'opportunityId': instance.opportunityId,
      'opportunityName': instance.opportunityName,
      'description': instance.description,
      'estAmount': const DecimalConverter().toJson(instance.estAmount),
      'estProbability': instance.estProbability,
      'stageId': instance.stageId,
      'nextStep': instance.nextStep,
      'employeeUser': instance.employeeUser,
      'leadUser': instance.leadUser,
    };
