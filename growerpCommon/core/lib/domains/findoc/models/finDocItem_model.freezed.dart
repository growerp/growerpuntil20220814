// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'finDocItem_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FinDocItem _$FinDocItemFromJson(Map<String, dynamic> json) {
  return _FinDocItem.fromJson(json);
}

/// @nodoc
class _$FinDocItemTearOff {
  const _$FinDocItemTearOff();

  _FinDocItem call(
      {String? itemSeqId,
      String? itemTypeId,
      String? itemTypeName,
      String? productId,
      String? description,
      @DecimalConverter() Decimal? quantity,
      @DecimalConverter() Decimal? price,
      String? glAccountId,
      String? assetId,
      String? assetName,
      Location? location,
      @DateTimeConverter() DateTime? rentalFromDate,
      @DateTimeConverter() DateTime? rentalThruDate}) {
    return _FinDocItem(
      itemSeqId: itemSeqId,
      itemTypeId: itemTypeId,
      itemTypeName: itemTypeName,
      productId: productId,
      description: description,
      quantity: quantity,
      price: price,
      glAccountId: glAccountId,
      assetId: assetId,
      assetName: assetName,
      location: location,
      rentalFromDate: rentalFromDate,
      rentalThruDate: rentalThruDate,
    );
  }

  FinDocItem fromJson(Map<String, Object?> json) {
    return FinDocItem.fromJson(json);
  }
}

/// @nodoc
const $FinDocItem = _$FinDocItemTearOff();

/// @nodoc
mixin _$FinDocItem {
  String? get itemSeqId => throw _privateConstructorUsedError;
  String? get itemTypeId => throw _privateConstructorUsedError;
  String? get itemTypeName => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal? get quantity => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal? get price => throw _privateConstructorUsedError;
  String? get glAccountId => throw _privateConstructorUsedError;
  String? get assetId => throw _privateConstructorUsedError;
  String? get assetName => throw _privateConstructorUsedError;
  Location? get location => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get rentalFromDate => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get rentalThruDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinDocItemCopyWith<FinDocItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinDocItemCopyWith<$Res> {
  factory $FinDocItemCopyWith(
          FinDocItem value, $Res Function(FinDocItem) then) =
      _$FinDocItemCopyWithImpl<$Res>;
  $Res call(
      {String? itemSeqId,
      String? itemTypeId,
      String? itemTypeName,
      String? productId,
      String? description,
      @DecimalConverter() Decimal? quantity,
      @DecimalConverter() Decimal? price,
      String? glAccountId,
      String? assetId,
      String? assetName,
      Location? location,
      @DateTimeConverter() DateTime? rentalFromDate,
      @DateTimeConverter() DateTime? rentalThruDate});

  $LocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$FinDocItemCopyWithImpl<$Res> implements $FinDocItemCopyWith<$Res> {
  _$FinDocItemCopyWithImpl(this._value, this._then);

  final FinDocItem _value;
  // ignore: unused_field
  final $Res Function(FinDocItem) _then;

  @override
  $Res call({
    Object? itemSeqId = freezed,
    Object? itemTypeId = freezed,
    Object? itemTypeName = freezed,
    Object? productId = freezed,
    Object? description = freezed,
    Object? quantity = freezed,
    Object? price = freezed,
    Object? glAccountId = freezed,
    Object? assetId = freezed,
    Object? assetName = freezed,
    Object? location = freezed,
    Object? rentalFromDate = freezed,
    Object? rentalThruDate = freezed,
  }) {
    return _then(_value.copyWith(
      itemSeqId: itemSeqId == freezed
          ? _value.itemSeqId
          : itemSeqId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemTypeId: itemTypeId == freezed
          ? _value.itemTypeId
          : itemTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemTypeName: itemTypeName == freezed
          ? _value.itemTypeName
          : itemTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: productId == freezed
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: quantity == freezed
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      glAccountId: glAccountId == freezed
          ? _value.glAccountId
          : glAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      assetId: assetId == freezed
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      assetName: assetName == freezed
          ? _value.assetName
          : assetName // ignore: cast_nullable_to_non_nullable
              as String?,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Location?,
      rentalFromDate: rentalFromDate == freezed
          ? _value.rentalFromDate
          : rentalFromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rentalThruDate: rentalThruDate == freezed
          ? _value.rentalThruDate
          : rentalThruDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
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
abstract class _$FinDocItemCopyWith<$Res> implements $FinDocItemCopyWith<$Res> {
  factory _$FinDocItemCopyWith(
          _FinDocItem value, $Res Function(_FinDocItem) then) =
      __$FinDocItemCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? itemSeqId,
      String? itemTypeId,
      String? itemTypeName,
      String? productId,
      String? description,
      @DecimalConverter() Decimal? quantity,
      @DecimalConverter() Decimal? price,
      String? glAccountId,
      String? assetId,
      String? assetName,
      Location? location,
      @DateTimeConverter() DateTime? rentalFromDate,
      @DateTimeConverter() DateTime? rentalThruDate});

  @override
  $LocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$FinDocItemCopyWithImpl<$Res> extends _$FinDocItemCopyWithImpl<$Res>
    implements _$FinDocItemCopyWith<$Res> {
  __$FinDocItemCopyWithImpl(
      _FinDocItem _value, $Res Function(_FinDocItem) _then)
      : super(_value, (v) => _then(v as _FinDocItem));

  @override
  _FinDocItem get _value => super._value as _FinDocItem;

  @override
  $Res call({
    Object? itemSeqId = freezed,
    Object? itemTypeId = freezed,
    Object? itemTypeName = freezed,
    Object? productId = freezed,
    Object? description = freezed,
    Object? quantity = freezed,
    Object? price = freezed,
    Object? glAccountId = freezed,
    Object? assetId = freezed,
    Object? assetName = freezed,
    Object? location = freezed,
    Object? rentalFromDate = freezed,
    Object? rentalThruDate = freezed,
  }) {
    return _then(_FinDocItem(
      itemSeqId: itemSeqId == freezed
          ? _value.itemSeqId
          : itemSeqId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemTypeId: itemTypeId == freezed
          ? _value.itemTypeId
          : itemTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemTypeName: itemTypeName == freezed
          ? _value.itemTypeName
          : itemTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: productId == freezed
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: quantity == freezed
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      glAccountId: glAccountId == freezed
          ? _value.glAccountId
          : glAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      assetId: assetId == freezed
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      assetName: assetName == freezed
          ? _value.assetName
          : assetName // ignore: cast_nullable_to_non_nullable
              as String?,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Location?,
      rentalFromDate: rentalFromDate == freezed
          ? _value.rentalFromDate
          : rentalFromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rentalThruDate: rentalThruDate == freezed
          ? _value.rentalThruDate
          : rentalThruDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FinDocItem extends _FinDocItem with DiagnosticableTreeMixin {
  _$_FinDocItem(
      {this.itemSeqId,
      this.itemTypeId,
      this.itemTypeName,
      this.productId,
      this.description,
      @DecimalConverter() this.quantity,
      @DecimalConverter() this.price,
      this.glAccountId,
      this.assetId,
      this.assetName,
      this.location,
      @DateTimeConverter() this.rentalFromDate,
      @DateTimeConverter() this.rentalThruDate})
      : super._();

  factory _$_FinDocItem.fromJson(Map<String, dynamic> json) =>
      _$$_FinDocItemFromJson(json);

  @override
  final String? itemSeqId;
  @override
  final String? itemTypeId;
  @override
  final String? itemTypeName;
  @override
  final String? productId;
  @override
  final String? description;
  @override
  @DecimalConverter()
  final Decimal? quantity;
  @override
  @DecimalConverter()
  final Decimal? price;
  @override
  final String? glAccountId;
  @override
  final String? assetId;
  @override
  final String? assetName;
  @override
  final Location? location;
  @override
  @DateTimeConverter()
  final DateTime? rentalFromDate;
  @override
  @DateTimeConverter()
  final DateTime? rentalThruDate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FinDocItem(itemSeqId: $itemSeqId, itemTypeId: $itemTypeId, itemTypeName: $itemTypeName, productId: $productId, description: $description, quantity: $quantity, price: $price, glAccountId: $glAccountId, assetId: $assetId, assetName: $assetName, location: $location, rentalFromDate: $rentalFromDate, rentalThruDate: $rentalThruDate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FinDocItem'))
      ..add(DiagnosticsProperty('itemSeqId', itemSeqId))
      ..add(DiagnosticsProperty('itemTypeId', itemTypeId))
      ..add(DiagnosticsProperty('itemTypeName', itemTypeName))
      ..add(DiagnosticsProperty('productId', productId))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('quantity', quantity))
      ..add(DiagnosticsProperty('price', price))
      ..add(DiagnosticsProperty('glAccountId', glAccountId))
      ..add(DiagnosticsProperty('assetId', assetId))
      ..add(DiagnosticsProperty('assetName', assetName))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('rentalFromDate', rentalFromDate))
      ..add(DiagnosticsProperty('rentalThruDate', rentalThruDate));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FinDocItem &&
            const DeepCollectionEquality().equals(other.itemSeqId, itemSeqId) &&
            const DeepCollectionEquality()
                .equals(other.itemTypeId, itemTypeId) &&
            const DeepCollectionEquality()
                .equals(other.itemTypeName, itemTypeName) &&
            const DeepCollectionEquality().equals(other.productId, productId) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.quantity, quantity) &&
            const DeepCollectionEquality().equals(other.price, price) &&
            const DeepCollectionEquality()
                .equals(other.glAccountId, glAccountId) &&
            const DeepCollectionEquality().equals(other.assetId, assetId) &&
            const DeepCollectionEquality().equals(other.assetName, assetName) &&
            const DeepCollectionEquality().equals(other.location, location) &&
            const DeepCollectionEquality()
                .equals(other.rentalFromDate, rentalFromDate) &&
            const DeepCollectionEquality()
                .equals(other.rentalThruDate, rentalThruDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(itemSeqId),
      const DeepCollectionEquality().hash(itemTypeId),
      const DeepCollectionEquality().hash(itemTypeName),
      const DeepCollectionEquality().hash(productId),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(quantity),
      const DeepCollectionEquality().hash(price),
      const DeepCollectionEquality().hash(glAccountId),
      const DeepCollectionEquality().hash(assetId),
      const DeepCollectionEquality().hash(assetName),
      const DeepCollectionEquality().hash(location),
      const DeepCollectionEquality().hash(rentalFromDate),
      const DeepCollectionEquality().hash(rentalThruDate));

  @JsonKey(ignore: true)
  @override
  _$FinDocItemCopyWith<_FinDocItem> get copyWith =>
      __$FinDocItemCopyWithImpl<_FinDocItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FinDocItemToJson(this);
  }
}

abstract class _FinDocItem extends FinDocItem {
  factory _FinDocItem(
      {String? itemSeqId,
      String? itemTypeId,
      String? itemTypeName,
      String? productId,
      String? description,
      @DecimalConverter() Decimal? quantity,
      @DecimalConverter() Decimal? price,
      String? glAccountId,
      String? assetId,
      String? assetName,
      Location? location,
      @DateTimeConverter() DateTime? rentalFromDate,
      @DateTimeConverter() DateTime? rentalThruDate}) = _$_FinDocItem;
  _FinDocItem._() : super._();

  factory _FinDocItem.fromJson(Map<String, dynamic> json) =
      _$_FinDocItem.fromJson;

  @override
  String? get itemSeqId;
  @override
  String? get itemTypeId;
  @override
  String? get itemTypeName;
  @override
  String? get productId;
  @override
  String? get description;
  @override
  @DecimalConverter()
  Decimal? get quantity;
  @override
  @DecimalConverter()
  Decimal? get price;
  @override
  String? get glAccountId;
  @override
  String? get assetId;
  @override
  String? get assetName;
  @override
  Location? get location;
  @override
  @DateTimeConverter()
  DateTime? get rentalFromDate;
  @override
  @DateTimeConverter()
  DateTime? get rentalThruDate;
  @override
  @JsonKey(ignore: true)
  _$FinDocItemCopyWith<_FinDocItem> get copyWith =>
      throw _privateConstructorUsedError;
}
