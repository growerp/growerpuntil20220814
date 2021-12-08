// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'company_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return _Company.fromJson(json);
}

/// @nodoc
class _$CompanyTearOff {
  const _$CompanyTearOff();

  _Company call(
      {String? partyId,
      String? name,
      String? email,
      Currency? currency,
      @Uint8ListConverter() Uint8List? image,
      Address? address,
      Decimal? vatPerc,
      Decimal? salesPerc}) {
    return _Company(
      partyId: partyId,
      name: name,
      email: email,
      currency: currency,
      image: image,
      address: address,
      vatPerc: vatPerc,
      salesPerc: salesPerc,
    );
  }

  Company fromJson(Map<String, Object?> json) {
    return Company.fromJson(json);
  }
}

/// @nodoc
const $Company = _$CompanyTearOff();

/// @nodoc
mixin _$Company {
  String? get partyId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  Currency? get currency => throw _privateConstructorUsedError;
  @Uint8ListConverter()
  Uint8List? get image => throw _privateConstructorUsedError;
  Address? get address => throw _privateConstructorUsedError;
  Decimal? get vatPerc => throw _privateConstructorUsedError;
  Decimal? get salesPerc => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanyCopyWith<Company> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyCopyWith<$Res> {
  factory $CompanyCopyWith(Company value, $Res Function(Company) then) =
      _$CompanyCopyWithImpl<$Res>;
  $Res call(
      {String? partyId,
      String? name,
      String? email,
      Currency? currency,
      @Uint8ListConverter() Uint8List? image,
      Address? address,
      Decimal? vatPerc,
      Decimal? salesPerc});

  $CurrencyCopyWith<$Res>? get currency;
  $AddressCopyWith<$Res>? get address;
}

/// @nodoc
class _$CompanyCopyWithImpl<$Res> implements $CompanyCopyWith<$Res> {
  _$CompanyCopyWithImpl(this._value, this._then);

  final Company _value;
  // ignore: unused_field
  final $Res Function(Company) _then;

  @override
  $Res call({
    Object? partyId = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? currency = freezed,
    Object? image = freezed,
    Object? address = freezed,
    Object? vatPerc = freezed,
    Object? salesPerc = freezed,
  }) {
    return _then(_value.copyWith(
      partyId: partyId == freezed
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: currency == freezed
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as Currency?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address?,
      vatPerc: vatPerc == freezed
          ? _value.vatPerc
          : vatPerc // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      salesPerc: salesPerc == freezed
          ? _value.salesPerc
          : salesPerc // ignore: cast_nullable_to_non_nullable
              as Decimal?,
    ));
  }

  @override
  $CurrencyCopyWith<$Res>? get currency {
    if (_value.currency == null) {
      return null;
    }

    return $CurrencyCopyWith<$Res>(_value.currency!, (value) {
      return _then(_value.copyWith(currency: value));
    });
  }

  @override
  $AddressCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $AddressCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value));
    });
  }
}

/// @nodoc
abstract class _$CompanyCopyWith<$Res> implements $CompanyCopyWith<$Res> {
  factory _$CompanyCopyWith(_Company value, $Res Function(_Company) then) =
      __$CompanyCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? partyId,
      String? name,
      String? email,
      Currency? currency,
      @Uint8ListConverter() Uint8List? image,
      Address? address,
      Decimal? vatPerc,
      Decimal? salesPerc});

  @override
  $CurrencyCopyWith<$Res>? get currency;
  @override
  $AddressCopyWith<$Res>? get address;
}

/// @nodoc
class __$CompanyCopyWithImpl<$Res> extends _$CompanyCopyWithImpl<$Res>
    implements _$CompanyCopyWith<$Res> {
  __$CompanyCopyWithImpl(_Company _value, $Res Function(_Company) _then)
      : super(_value, (v) => _then(v as _Company));

  @override
  _Company get _value => super._value as _Company;

  @override
  $Res call({
    Object? partyId = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? currency = freezed,
    Object? image = freezed,
    Object? address = freezed,
    Object? vatPerc = freezed,
    Object? salesPerc = freezed,
  }) {
    return _then(_Company(
      partyId: partyId == freezed
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: currency == freezed
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as Currency?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address?,
      vatPerc: vatPerc == freezed
          ? _value.vatPerc
          : vatPerc // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      salesPerc: salesPerc == freezed
          ? _value.salesPerc
          : salesPerc // ignore: cast_nullable_to_non_nullable
              as Decimal?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Company extends _Company {
  _$_Company(
      {this.partyId,
      this.name,
      this.email,
      this.currency,
      @Uint8ListConverter() this.image,
      this.address,
      this.vatPerc,
      this.salesPerc})
      : super._();

  factory _$_Company.fromJson(Map<String, dynamic> json) =>
      _$$_CompanyFromJson(json);

  @override
  final String? partyId;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final Currency? currency;
  @override
  @Uint8ListConverter()
  final Uint8List? image;
  @override
  final Address? address;
  @override
  final Decimal? vatPerc;
  @override
  final Decimal? salesPerc;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Company &&
            const DeepCollectionEquality().equals(other.partyId, partyId) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.currency, currency) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            const DeepCollectionEquality().equals(other.address, address) &&
            const DeepCollectionEquality().equals(other.vatPerc, vatPerc) &&
            const DeepCollectionEquality().equals(other.salesPerc, salesPerc));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(partyId),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(currency),
      const DeepCollectionEquality().hash(image),
      const DeepCollectionEquality().hash(address),
      const DeepCollectionEquality().hash(vatPerc),
      const DeepCollectionEquality().hash(salesPerc));

  @JsonKey(ignore: true)
  @override
  _$CompanyCopyWith<_Company> get copyWith =>
      __$CompanyCopyWithImpl<_Company>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompanyToJson(this);
  }
}

abstract class _Company extends Company {
  factory _Company(
      {String? partyId,
      String? name,
      String? email,
      Currency? currency,
      @Uint8ListConverter() Uint8List? image,
      Address? address,
      Decimal? vatPerc,
      Decimal? salesPerc}) = _$_Company;
  _Company._() : super._();

  factory _Company.fromJson(Map<String, dynamic> json) = _$_Company.fromJson;

  @override
  String? get partyId;
  @override
  String? get name;
  @override
  String? get email;
  @override
  Currency? get currency;
  @override
  @Uint8ListConverter()
  Uint8List? get image;
  @override
  Address? get address;
  @override
  Decimal? get vatPerc;
  @override
  Decimal? get salesPerc;
  @override
  @JsonKey(ignore: true)
  _$CompanyCopyWith<_Company> get copyWith =>
      throw _privateConstructorUsedError;
}
