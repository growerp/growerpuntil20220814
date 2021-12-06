// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Address _$$_AddressFromJson(Map<String, dynamic> json) => _$_Address(
      addressId: json['addressId'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      postalCode: json['postalCode'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      provinceId: json['provinceId'] as String?,
      country: json['country'] as String?,
      countryId: json['countryId'] as String?,
    );

Map<String, dynamic> _$$_AddressToJson(_$_Address instance) =>
    <String, dynamic>{
      'addressId': instance.addressId,
      'address1': instance.address1,
      'address2': instance.address2,
      'postalCode': instance.postalCode,
      'city': instance.city,
      'province': instance.province,
      'provinceId': instance.provinceId,
      'country': instance.country,
      'countryId': instance.countryId,
    };
