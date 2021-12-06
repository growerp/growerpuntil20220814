// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finDocItem_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FinDocItem _$$_FinDocItemFromJson(Map<String, dynamic> json) =>
    _$_FinDocItem(
      itemSeqId: json['itemSeqId'] as String?,
      itemTypeId: json['itemTypeId'] as String?,
      itemTypeName: json['itemTypeName'] as String?,
      productId: json['productId'] as String?,
      description: json['description'] as String?,
      quantity: const DecimalConverter().fromJson(json['quantity'] as String?),
      price: const DecimalConverter().fromJson(json['price'] as String?),
      glAccountId: json['glAccountId'] as String?,
      assetId: json['assetId'] as String?,
      assetName: json['assetName'] as String?,
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      rentalFromDate:
          const DateTimeConverter().fromJson(json['rentalFromDate'] as String?),
      rentalThruDate:
          const DateTimeConverter().fromJson(json['rentalThruDate'] as String?),
    );

Map<String, dynamic> _$$_FinDocItemToJson(_$_FinDocItem instance) =>
    <String, dynamic>{
      'itemSeqId': instance.itemSeqId,
      'itemTypeId': instance.itemTypeId,
      'itemTypeName': instance.itemTypeName,
      'productId': instance.productId,
      'description': instance.description,
      'quantity': const DecimalConverter().toJson(instance.quantity),
      'price': const DecimalConverter().toJson(instance.price),
      'glAccountId': instance.glAccountId,
      'assetId': instance.assetId,
      'assetName': instance.assetName,
      'location': instance.location,
      'rentalFromDate':
          const DateTimeConverter().toJson(instance.rentalFromDate),
      'rentalThruDate':
          const DateTimeConverter().toJson(instance.rentalThruDate),
    };
