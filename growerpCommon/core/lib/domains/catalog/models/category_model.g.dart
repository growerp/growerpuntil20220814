// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Category _$$_CategoryFromJson(Map<String, dynamic> json) => _$_Category(
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String?,
      description: json['description'] as String?,
      image: const Uint8ListConverter().fromJson(json['image'] as String?),
      nbrOfProducts: json['nbrOfProducts'] as int?,
    );

Map<String, dynamic> _$$_CategoryToJson(_$_Category instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'description': instance.description,
      'image': const Uint8ListConverter().toJson(instance.image),
      'nbrOfProducts': instance.nbrOfProducts,
    };
