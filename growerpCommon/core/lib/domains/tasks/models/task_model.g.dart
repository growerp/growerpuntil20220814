// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Task _$$_TaskFromJson(Map<String, dynamic> json) => _$_Task(
      taskId: json['taskId'] as String?,
      parentTaskId: json['parentTaskId'] as String?,
      status: json['status'] as String?,
      taskName: json['taskName'] as String?,
      description: json['description'] as String?,
      customerUser: json['customerUser'] == null
          ? null
          : User.fromJson(json['customerUser'] as Map<String, dynamic>),
      vendorUser: json['vendorUser'] == null
          ? null
          : User.fromJson(json['vendorUser'] as Map<String, dynamic>),
      employeeUser: json['employeeUser'] == null
          ? null
          : User.fromJson(json['employeeUser'] as Map<String, dynamic>),
      rate: const DecimalConverter().fromJson(json['rate'] as String?),
      startDate:
          const DateTimeConverter().fromJson(json['startDate'] as String?),
      endDate: const DateTimeConverter().fromJson(json['endDate'] as String?),
      unInvoicedHours:
          const DecimalConverter().fromJson(json['unInvoicedHours'] as String?),
      timeEntries: (json['timeEntries'] as List<dynamic>?)
              ?.map((e) => TimeEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$$_TaskToJson(_$_Task instance) => <String, dynamic>{
      'taskId': instance.taskId,
      'parentTaskId': instance.parentTaskId,
      'status': instance.status,
      'taskName': instance.taskName,
      'description': instance.description,
      'customerUser': instance.customerUser,
      'vendorUser': instance.vendorUser,
      'employeeUser': instance.employeeUser,
      'rate': const DecimalConverter().toJson(instance.rate),
      'startDate': const DateTimeConverter().toJson(instance.startDate),
      'endDate': const DateTimeConverter().toJson(instance.endDate),
      'unInvoicedHours':
          const DecimalConverter().toJson(instance.unInvoicedHours),
      'timeEntries': instance.timeEntries,
    };
