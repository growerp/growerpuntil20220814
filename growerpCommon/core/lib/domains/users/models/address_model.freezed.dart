// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Address _$AddressFromJson(Map<String, dynamic> json) {
  return _Address.fromJson(json);
}

/// @nodoc
class _$AddressTearOff {
  const _$AddressTearOff();

  _Address call(
      {String? addressId,
      String? address1,
      String? address2,
      String? postalCode,
      String? city,
      String? province,
      String? provinceId,
      String? country,
      String? countryId}) {
    return _Address(
      addressId: addressId,
      address1: address1,
      address2: address2,
      postalCode: postalCode,
      city: city,
      province: province,
      provinceId: provinceId,
      country: country,
      countryId: countryId,
    );
  }

  Address fromJson(Map<String, Object?> json) {
    return Address.fromJson(json);
  }
}

/// @nodoc
const $Address = _$AddressTearOff();

/// @nodoc
mixin _$Address {
  String? get addressId =>
      throw _privateConstructorUsedError; // contactMechId in backend
  String? get address1 => throw _privateConstructorUsedError;
  String? get address2 => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get province => throw _privateConstructorUsedError;
  String? get provinceId => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get countryId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddressCopyWith<Address> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressCopyWith<$Res> {
  factory $AddressCopyWith(Address value, $Res Function(Address) then) =
      _$AddressCopyWithImpl<$Res>;
  $Res call(
      {String? addressId,
      String? address1,
      String? address2,
      String? postalCode,
      String? city,
      String? province,
      String? provinceId,
      String? country,
      String? countryId});
}

/// @nodoc
class _$AddressCopyWithImpl<$Res> implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._value, this._then);

  final Address _value;
  // ignore: unused_field
  final $Res Function(Address) _then;

  @override
  $Res call({
    Object? addressId = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? postalCode = freezed,
    Object? city = freezed,
    Object? province = freezed,
    Object? provinceId = freezed,
    Object? country = freezed,
    Object? countryId = freezed,
  }) {
    return _then(_value.copyWith(
      addressId: addressId == freezed
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as String?,
      address1: address1 == freezed
          ? _value.address1
          : address1 // ignore: cast_nullable_to_non_nullable
              as String?,
      address2: address2 == freezed
          ? _value.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: postalCode == freezed
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      city: city == freezed
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: province == freezed
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      provinceId: provinceId == freezed
          ? _value.provinceId
          : provinceId // ignore: cast_nullable_to_non_nullable
              as String?,
      country: country == freezed
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      countryId: countryId == freezed
          ? _value.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) then) =
      __$AddressCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? addressId,
      String? address1,
      String? address2,
      String? postalCode,
      String? city,
      String? province,
      String? provinceId,
      String? country,
      String? countryId});
}

/// @nodoc
class __$AddressCopyWithImpl<$Res> extends _$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(_Address _value, $Res Function(_Address) _then)
      : super(_value, (v) => _then(v as _Address));

  @override
  _Address get _value => super._value as _Address;

  @override
  $Res call({
    Object? addressId = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? postalCode = freezed,
    Object? city = freezed,
    Object? province = freezed,
    Object? provinceId = freezed,
    Object? country = freezed,
    Object? countryId = freezed,
  }) {
    return _then(_Address(
      addressId: addressId == freezed
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as String?,
      address1: address1 == freezed
          ? _value.address1
          : address1 // ignore: cast_nullable_to_non_nullable
              as String?,
      address2: address2 == freezed
          ? _value.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: postalCode == freezed
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      city: city == freezed
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: province == freezed
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      provinceId: provinceId == freezed
          ? _value.provinceId
          : provinceId // ignore: cast_nullable_to_non_nullable
              as String?,
      country: country == freezed
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      countryId: countryId == freezed
          ? _value.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Address extends _Address {
  _$_Address(
      {this.addressId,
      this.address1,
      this.address2,
      this.postalCode,
      this.city,
      this.province,
      this.provinceId,
      this.country,
      this.countryId})
      : super._();

  factory _$_Address.fromJson(Map<String, dynamic> json) =>
      _$$_AddressFromJson(json);

  @override
  final String? addressId;
  @override // contactMechId in backend
  final String? address1;
  @override
  final String? address2;
  @override
  final String? postalCode;
  @override
  final String? city;
  @override
  final String? province;
  @override
  final String? provinceId;
  @override
  final String? country;
  @override
  final String? countryId;

  @override
  String toString() {
    return 'Address(addressId: $addressId, address1: $address1, address2: $address2, postalCode: $postalCode, city: $city, province: $province, provinceId: $provinceId, country: $country, countryId: $countryId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Address &&
            const DeepCollectionEquality().equals(other.addressId, addressId) &&
            const DeepCollectionEquality().equals(other.address1, address1) &&
            const DeepCollectionEquality().equals(other.address2, address2) &&
            const DeepCollectionEquality()
                .equals(other.postalCode, postalCode) &&
            const DeepCollectionEquality().equals(other.city, city) &&
            const DeepCollectionEquality().equals(other.province, province) &&
            const DeepCollectionEquality()
                .equals(other.provinceId, provinceId) &&
            const DeepCollectionEquality().equals(other.country, country) &&
            const DeepCollectionEquality().equals(other.countryId, countryId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(addressId),
      const DeepCollectionEquality().hash(address1),
      const DeepCollectionEquality().hash(address2),
      const DeepCollectionEquality().hash(postalCode),
      const DeepCollectionEquality().hash(city),
      const DeepCollectionEquality().hash(province),
      const DeepCollectionEquality().hash(provinceId),
      const DeepCollectionEquality().hash(country),
      const DeepCollectionEquality().hash(countryId));

  @JsonKey(ignore: true)
  @override
  _$AddressCopyWith<_Address> get copyWith =>
      __$AddressCopyWithImpl<_Address>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AddressToJson(this);
  }
}

abstract class _Address extends Address {
  factory _Address(
      {String? addressId,
      String? address1,
      String? address2,
      String? postalCode,
      String? city,
      String? province,
      String? provinceId,
      String? country,
      String? countryId}) = _$_Address;
  _Address._() : super._();

  factory _Address.fromJson(Map<String, dynamic> json) = _$_Address.fromJson;

  @override
  String? get addressId;
  @override // contactMechId in backend
  String? get address1;
  @override
  String? get address2;
  @override
  String? get postalCode;
  @override
  String? get city;
  @override
  String? get province;
  @override
  String? get provinceId;
  @override
  String? get country;
  @override
  String? get countryId;
  @override
  @JsonKey(ignore: true)
  _$AddressCopyWith<_Address> get copyWith =>
      throw _privateConstructorUsedError;
}
