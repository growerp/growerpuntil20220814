// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Product _$$_ProductFromJson(Map<String, dynamic> json) => _$_Product(
      productId: json['productId'] as String? ?? '',
      pseudoId: json['pseudoId'] as String? ?? '',
      productTypeId: json['productTypeId'] as String?,
      assetClassId: json['assetClassId'] as String?,
      productName: json['productName'] as String?,
      description: json['description'] as String?,
      price: const DecimalConverter().fromJson(json['price'] as String?),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      useWarehouse: json['useWarehouse'] as bool? ?? false,
      assetCount: json['assetCount'] as int?,
      image: const Uint8ListConverter().fromJson(json['image'] as String?),
    );

Map<String, dynamic> _$$_ProductToJson(_$_Product instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'pseudoId': instance.pseudoId,
      'productTypeId': instance.productTypeId,
      'assetClassId': instance.assetClassId,
      'productName': instance.productName,
      'description': instance.description,
      'price': const DecimalConverter().toJson(instance.price),
      'category': instance.category,
      'useWarehouse': instance.useWarehouse,
      'assetCount': instance.assetCount,
      'image': const Uint8ListConverter().toJson(instance.image),
    };
