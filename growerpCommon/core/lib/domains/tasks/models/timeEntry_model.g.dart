// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeEntry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TimeEntry _$$_TimeEntryFromJson(Map<String, dynamic> json) => _$_TimeEntry(
      timeEntryId: json['timeEntryId'] as String?,
      taskId: json['taskId'] as String?,
      partyId: json['partyId'] as String?,
      hours: const DecimalConverter().fromJson(json['hours'] as String?),
      comments: json['comments'] as String?,
      date: const DateTimeConverter().fromJson(json['date'] as String?),
    );

Map<String, dynamic> _$$_TimeEntryToJson(_$_TimeEntry instance) =>
    <String, dynamic>{
      'timeEntryId': instance.timeEntryId,
      'taskId': instance.taskId,
      'partyId': instance.partyId,
      'hours': const DecimalConverter().toJson(instance.hours),
      'comments': instance.comments,
      'date': const DateTimeConverter().toJson(instance.date),
    };
