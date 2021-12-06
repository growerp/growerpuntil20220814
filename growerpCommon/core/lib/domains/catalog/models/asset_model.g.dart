// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Asset _$$_AssetFromJson(Map<String, dynamic> json) => _$_Asset(
      assetId: json['assetId'] as String? ?? '',
      assetClassId: json['assetClassId'] as String?,
      assetName: json['assetName'] as String?,
      statusId: json['statusId'] as String?,
      quantityOnHand:
          const DecimalConverter().fromJson(json['quantityOnHand'] as String?),
      availableToPromise: const DecimalConverter()
          .fromJson(json['availableToPromise'] as String?),
      parentAssetId: json['parentAssetId'] as String?,
      receivedDate:
          const DateTimeConverter().fromJson(json['receivedDate'] as String?),
      expectedEndOfLife: const DateTimeConverter()
          .fromJson(json['expectedEndOfLife'] as String?),
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AssetToJson(_$_Asset instance) => <String, dynamic>{
      'assetId': instance.assetId,
      'assetClassId': instance.assetClassId,
      'assetName': instance.assetName,
      'statusId': instance.statusId,
      'quantityOnHand':
          const DecimalConverter().toJson(instance.quantityOnHand),
      'availableToPromise':
          const DecimalConverter().toJson(instance.availableToPromise),
      'parentAssetId': instance.parentAssetId,
      'receivedDate': const DateTimeConverter().toJson(instance.receivedDate),
      'expectedEndOfLife':
          const DateTimeConverter().toJson(instance.expectedEndOfLife),
      'product': instance.product,
      'location': instance.location,
    };
