// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'asset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return _Asset.fromJson(json);
}

/// @nodoc
class _$AssetTearOff {
  const _$AssetTearOff();

  _Asset call(
      {String assetId = "",
      String? assetClassId,
      String? assetName,
      String? statusId,
      @DecimalConverter() Decimal? quantityOnHand,
      @DecimalConverter() Decimal? availableToPromise,
      String? parentAssetId,
      @DateTimeConverter() DateTime? receivedDate,
      @DateTimeConverter() DateTime? expectedEndOfLife,
      Product? product,
      Location? location}) {
    return _Asset(
      assetId: assetId,
      assetClassId: assetClassId,
      assetName: assetName,
      statusId: statusId,
      quantityOnHand: quantityOnHand,
      availableToPromise: availableToPromise,
      parentAssetId: parentAssetId,
      receivedDate: receivedDate,
      expectedEndOfLife: expectedEndOfLife,
      product: product,
      location: location,
    );
  }

  Asset fromJson(Map<String, Object?> json) {
    return Asset.fromJson(json);
  }
}

/// @nodoc
const $Asset = _$AssetTearOff();

/// @nodoc
mixin _$Asset {
  String get assetId => throw _privateConstructorUsedError;
  String? get assetClassId =>
      throw _privateConstructorUsedError; // room, table etc
  String? get assetName =>
      throw _privateConstructorUsedError; // include room number/name
  String? get statusId => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal? get quantityOnHand => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal? get availableToPromise => throw _privateConstructorUsedError;
  String? get parentAssetId => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get receivedDate => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get expectedEndOfLife => throw _privateConstructorUsedError;
  Product? get product => throw _privateConstructorUsedError;
  Location? get location => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetCopyWith<Asset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetCopyWith<$Res> {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) then) =
      _$AssetCopyWithImpl<$Res>;
  $Res call(
      {String assetId,
      String? assetClassId,
      String? assetName,
      String? statusId,
      @DecimalConverter() Decimal? quantityOnHand,
      @DecimalConverter() Decimal? availableToPromise,
      String? parentAssetId,
      @DateTimeConverter() DateTime? receivedDate,
      @DateTimeConverter() DateTime? expectedEndOfLife,
      Product? product,
      Location? location});

  $ProductCopyWith<$Res>? get product;
  $LocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$AssetCopyWithImpl<$Res> implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._value, this._then);

  final Asset _value;
  // ignore: unused_field
  final $Res Function(Asset) _then;

  @override
  $Res call({
    Object? assetId = freezed,
    Object? assetClassId = freezed,
    Object? assetName = freezed,
    Object? statusId = freezed,
    Object? quantityOnHand = freezed,
    Object? availableToPromise = freezed,
    Object? parentAssetId = freezed,
    Object? receivedDate = freezed,
    Object? expectedEndOfLife = freezed,
    Object? product = freezed,
    Object? location = freezed,
  }) {
    return _then(_value.copyWith(
      assetId: assetId == freezed
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      assetClassId: assetClassId == freezed
          ? _value.assetClassId
          : assetClassId // ignore: cast_nullable_to_non_nullable
              as String?,
      assetName: assetName == freezed
          ? _value.assetName
          : assetName // ignore: cast_nullable_to_non_nullable
              as String?,
      statusId: statusId == freezed
          ? _value.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityOnHand: quantityOnHand == freezed
          ? _value.quantityOnHand
          : quantityOnHand // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      availableToPromise: availableToPromise == freezed
          ? _value.availableToPromise
          : availableToPromise // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      parentAssetId: parentAssetId == freezed
          ? _value.parentAssetId
          : parentAssetId // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedDate: receivedDate == freezed
          ? _value.receivedDate
          : receivedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expectedEndOfLife: expectedEndOfLife == freezed
          ? _value.expectedEndOfLife
          : expectedEndOfLife // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      product: product == freezed
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product?,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Location?,
    ));
  }

  @override
  $ProductCopyWith<$Res>? get product {
    if (_value.product == null) {
      return null;
    }

    return $ProductCopyWith<$Res>(_value.product!, (value) {
      return _then(_value.copyWith(product: value));
    });
  }

  @override
  $LocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $LocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value));
    });
  }
}

/// @nodoc
abstract class _$AssetCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$AssetCopyWith(_Asset value, $Res Function(_Asset) then) =
      __$AssetCopyWithImpl<$Res>;
  @override
  $Res call(
      {String assetId,
      String? assetClassId,
      String? assetName,
      String? statusId,
      @DecimalConverter() Decimal? quantityOnHand,
      @DecimalConverter() Decimal? availableToPromise,
      String? parentAssetId,
      @DateTimeConverter() DateTime? receivedDate,
      @DateTimeConverter() DateTime? expectedEndOfLife,
      Product? product,
      Location? location});

  @override
  $ProductCopyWith<$Res>? get product;
  @override
  $LocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$AssetCopyWithImpl<$Res> extends _$AssetCopyWithImpl<$Res>
    implements _$AssetCopyWith<$Res> {
  __$AssetCopyWithImpl(_Asset _value, $Res Function(_Asset) _then)
      : super(_value, (v) => _then(v as _Asset));

  @override
  _Asset get _value => super._value as _Asset;

  @override
  $Res call({
    Object? assetId = freezed,
    Object? assetClassId = freezed,
    Object? assetName = freezed,
    Object? statusId = freezed,
    Object? quantityOnHand = freezed,
    Object? availableToPromise = freezed,
    Object? parentAssetId = freezed,
    Object? receivedDate = freezed,
    Object? expectedEndOfLife = freezed,
    Object? product = freezed,
    Object? location = freezed,
  }) {
    return _then(_Asset(
      assetId: assetId == freezed
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      assetClassId: assetClassId == freezed
          ? _value.assetClassId
          : assetClassId // ignore: cast_nullable_to_non_nullable
              as String?,
      assetName: assetName == freezed
          ? _value.assetName
          : assetName // ignore: cast_nullable_to_non_nullable
              as String?,
      statusId: statusId == freezed
          ? _value.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityOnHand: quantityOnHand == freezed
          ? _value.quantityOnHand
          : quantityOnHand // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      availableToPromise: availableToPromise == freezed
          ? _value.availableToPromise
          : availableToPromise // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      parentAssetId: parentAssetId == freezed
          ? _value.parentAssetId
          : parentAssetId // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedDate: receivedDate == freezed
          ? _value.receivedDate
          : receivedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expectedEndOfLife: expectedEndOfLife == freezed
          ? _value.expectedEndOfLife
          : expectedEndOfLife // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      product: product == freezed
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product?,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Location?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Asset extends _Asset {
  _$_Asset(
      {this.assetId = "",
      this.assetClassId,
      this.assetName,
      this.statusId,
      @DecimalConverter() this.quantityOnHand,
      @DecimalConverter() this.availableToPromise,
      this.parentAssetId,
      @DateTimeConverter() this.receivedDate,
      @DateTimeConverter() this.expectedEndOfLife,
      this.product,
      this.location})
      : super._();

  factory _$_Asset.fromJson(Map<String, dynamic> json) =>
      _$$_AssetFromJson(json);

  @JsonKey(defaultValue: "")
  @override
  final String assetId;
  @override
  final String? assetClassId;
  @override // room, table etc
  final String? assetName;
  @override // include room number/name
  final String? statusId;
  @override
  @DecimalConverter()
  final Decimal? quantityOnHand;
  @override
  @DecimalConverter()
  final Decimal? availableToPromise;
  @override
  final String? parentAssetId;
  @override
  @DateTimeConverter()
  final DateTime? receivedDate;
  @override
  @DateTimeConverter()
  final DateTime? expectedEndOfLife;
  @override
  final Product? product;
  @override
  final Location? location;

  @override
  String toString() {
    return 'Asset(assetId: $assetId, assetClassId: $assetClassId, assetName: $assetName, statusId: $statusId, quantityOnHand: $quantityOnHand, availableToPromise: $availableToPromise, parentAssetId: $parentAssetId, receivedDate: $receivedDate, expectedEndOfLife: $expectedEndOfLife, product: $product, location: $location)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Asset &&
            const DeepCollectionEquality().equals(other.assetId, assetId) &&
            const DeepCollectionEquality()
                .equals(other.assetClassId, assetClassId) &&
            const DeepCollectionEquality().equals(other.assetName, assetName) &&
            const DeepCollectionEquality().equals(other.statusId, statusId) &&
            const DeepCollectionEquality()
                .equals(other.quantityOnHand, quantityOnHand) &&
            const DeepCollectionEquality()
                .equals(other.availableToPromise, availableToPromise) &&
            const DeepCollectionEquality()
                .equals(other.parentAssetId, parentAssetId) &&
            const DeepCollectionEquality()
                .equals(other.receivedDate, receivedDate) &&
            const DeepCollectionEquality()
                .equals(other.expectedEndOfLife, expectedEndOfLife) &&
            const DeepCollectionEquality().equals(other.product, product) &&
            const DeepCollectionEquality().equals(other.location, location));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(assetId),
      const DeepCollectionEquality().hash(assetClassId),
      const DeepCollectionEquality().hash(assetName),
      const DeepCollectionEquality().hash(statusId),
      const DeepCollectionEquality().hash(quantityOnHand),
      const DeepCollectionEquality().hash(availableToPromise),
      const DeepCollectionEquality().hash(parentAssetId),
      const DeepCollectionEquality().hash(receivedDate),
      const DeepCollectionEquality().hash(expectedEndOfLife),
      const DeepCollectionEquality().hash(product),
      const DeepCollectionEquality().hash(location));

  @JsonKey(ignore: true)
  @override
  _$AssetCopyWith<_Asset> get copyWith =>
      __$AssetCopyWithImpl<_Asset>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AssetToJson(this);
  }
}

abstract class _Asset extends Asset {
  factory _Asset(
      {String assetId,
      String? assetClassId,
      String? assetName,
      String? statusId,
      @DecimalConverter() Decimal? quantityOnHand,
      @DecimalConverter() Decimal? availableToPromise,
      String? parentAssetId,
      @DateTimeConverter() DateTime? receivedDate,
      @DateTimeConverter() DateTime? expectedEndOfLife,
      Product? product,
      Location? location}) = _$_Asset;
  _Asset._() : super._();

  factory _Asset.fromJson(Map<String, dynamic> json) = _$_Asset.fromJson;

  @override
  String get assetId;
  @override
  String? get assetClassId;
  @override // room, table etc
  String? get assetName;
  @override // include room number/name
  String? get statusId;
  @override
  @DecimalConverter()
  Decimal? get quantityOnHand;
  @override
  @DecimalConverter()
  Decimal? get availableToPromise;
  @override
  String? get parentAssetId;
  @override
  @DateTimeConverter()
  DateTime? get receivedDate;
  @override
  @DateTimeConverter()
  DateTime? get expectedEndOfLife;
  @override
  Product? get product;
  @override
  Location? get location;
  @override
  @JsonKey(ignore: true)
  _$AssetCopyWith<_Asset> get copyWith => throw _privateConstructorUsedError;
}
