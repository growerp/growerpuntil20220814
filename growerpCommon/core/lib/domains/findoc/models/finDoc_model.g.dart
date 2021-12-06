// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finDoc_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FinDoc _$$_FinDocFromJson(Map<String, dynamic> json) => _$_FinDoc(
      docType: json['docType'] as String? ?? '',
      sales: json['sales'] as bool? ?? true,
      orderId: json['orderId'] as String?,
      shipmentId: json['shipmentId'] as String?,
      invoiceId: json['invoiceId'] as String?,
      paymentId: json['paymentId'] as String?,
      transactionId: json['transactionId'] as String?,
      statusId: json['statusId'] as String?,
      creationDate:
          const DateTimeConverter().fromJson(json['creationDate'] as String?),
      placedDate:
          const DateTimeConverter().fromJson(json['placedDate'] as String?),
      description: json['description'] as String?,
      otherUser: json['otherUser'] == null
          ? null
          : User.fromJson(json['otherUser'] as Map<String, dynamic>),
      grandTotal:
          const DecimalConverter().fromJson(json['grandTotal'] as String?),
      classificationId: json['classificationId'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => FinDocItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$$_FinDocToJson(_$_FinDoc instance) => <String, dynamic>{
      'docType': instance.docType,
      'sales': instance.sales,
      'orderId': instance.orderId,
      'shipmentId': instance.shipmentId,
      'invoiceId': instance.invoiceId,
      'paymentId': instance.paymentId,
      'transactionId': instance.transactionId,
      'statusId': instance.statusId,
      'creationDate': const DateTimeConverter().toJson(instance.creationDate),
      'placedDate': const DateTimeConverter().toJson(instance.placedDate),
      'description': instance.description,
      'otherUser': instance.otherUser,
      'grandTotal': const DecimalConverter().toJson(instance.grandTotal),
      'classificationId': instance.classificationId,
      'items': instance.items,
    };
