// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Company _$$_CompanyFromJson(Map<String, dynamic> json) => _$_Company(
      partyId: json['partyId'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      currency: json['currency'] == null
          ? null
          : Currency.fromJson(json['currency'] as Map<String, dynamic>),
      image: const Uint8ListConverter().fromJson(json['image'] as String?),
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      vatPerc: json['vatPerc'] == null
          ? null
          : Decimal.fromJson(json['vatPerc'] as String),
      salesPerc: json['salesPerc'] == null
          ? null
          : Decimal.fromJson(json['salesPerc'] as String),
    );

Map<String, dynamic> _$$_CompanyToJson(_$_Company instance) =>
    <String, dynamic>{
      'partyId': instance.partyId,
      'name': instance.name,
      'email': instance.email,
      'currency': instance.currency,
      'image': const Uint8ListConverter().toJson(instance.image),
      'address': instance.address,
      'vatPerc': instance.vatPerc,
      'salesPerc': instance.salesPerc,
    };
