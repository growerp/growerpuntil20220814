// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
class _$ProductTearOff {
  const _$ProductTearOff();

  _Product call(
      {String productId = "",
      String pseudoId = "",
      String? productTypeId,
      String? assetClassId,
      String? productName,
      String? description,
      @DecimalConverter() Decimal? price,
      Category? category,
      bool useWarehouse = false,
      int? assetCount,
      @Uint8ListConverter() Uint8List? image}) {
    return _Product(
      productId: productId,
      pseudoId: pseudoId,
      productTypeId: productTypeId,
      assetClassId: assetClassId,
      productName: productName,
      description: description,
      price: price,
      category: category,
      useWarehouse: useWarehouse,
      assetCount: assetCount,
      image: image,
    );
  }

  Product fromJson(Map<String, Object?> json) {
    return Product.fromJson(json);
  }
}

/// @nodoc
const $Product = _$ProductTearOff();

/// @nodoc
mixin _$Product {
  String get productId => throw _privateConstructorUsedError;
  String get pseudoId => throw _privateConstructorUsedError;
  String? get productTypeId =>
      throw _privateConstructorUsedError; // assetUse(rental)
  String? get assetClassId =>
      throw _privateConstructorUsedError; // room, restaurant table
  String? get productName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal? get price => throw _privateConstructorUsedError;
  Category? get category => throw _privateConstructorUsedError;
  bool get useWarehouse => throw _privateConstructorUsedError;
  int? get assetCount => throw _privateConstructorUsedError;
  @Uint8ListConverter()
  Uint8List? get image => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res>;
  $Res call(
      {String productId,
      String pseudoId,
      String? productTypeId,
      String? assetClassId,
      String? productName,
      String? description,
      @DecimalConverter() Decimal? price,
      Category? category,
      bool useWarehouse,
      int? assetCount,
      @Uint8ListConverter() Uint8List? image});

  $CategoryCopyWith<$Res>? get category;
}

/// @nodoc
class _$ProductCopyWithImpl<$Res> implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  final Product _value;
  // ignore: unused_field
  final $Res Function(Product) _then;

  @override
  $Res call({
    Object? productId = freezed,
    Object? pseudoId = freezed,
    Object? productTypeId = freezed,
    Object? assetClassId = freezed,
    Object? productName = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? category = freezed,
    Object? useWarehouse = freezed,
    Object? assetCount = freezed,
    Object? image = freezed,
  }) {
    return _then(_value.copyWith(
      productId: productId == freezed
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      pseudoId: pseudoId == freezed
          ? _value.pseudoId
          : pseudoId // ignore: cast_nullable_to_non_nullable
              as String,
      productTypeId: productTypeId == freezed
          ? _value.productTypeId
          : productTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      assetClassId: assetClassId == freezed
          ? _value.assetClassId
          : assetClassId // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: productName == freezed
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      useWarehouse: useWarehouse == freezed
          ? _value.useWarehouse
          : useWarehouse // ignore: cast_nullable_to_non_nullable
              as bool,
      assetCount: assetCount == freezed
          ? _value.assetCount
          : assetCount // ignore: cast_nullable_to_non_nullable
              as int?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
    ));
  }

  @override
  $CategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value));
    });
  }
}

/// @nodoc
abstract class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) then) =
      __$ProductCopyWithImpl<$Res>;
  @override
  $Res call(
      {String productId,
      String pseudoId,
      String? productTypeId,
      String? assetClassId,
      String? productName,
      String? description,
      @DecimalConverter() Decimal? price,
      Category? category,
      bool useWarehouse,
      int? assetCount,
      @Uint8ListConverter() Uint8List? image});

  @override
  $CategoryCopyWith<$Res>? get category;
}

/// @nodoc
class __$ProductCopyWithImpl<$Res> extends _$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(_Product _value, $Res Function(_Product) _then)
      : super(_value, (v) => _then(v as _Product));

  @override
  _Product get _value => super._value as _Product;

  @override
  $Res call({
    Object? productId = freezed,
    Object? pseudoId = freezed,
    Object? productTypeId = freezed,
    Object? assetClassId = freezed,
    Object? productName = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? category = freezed,
    Object? useWarehouse = freezed,
    Object? assetCount = freezed,
    Object? image = freezed,
  }) {
    return _then(_Product(
      productId: productId == freezed
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      pseudoId: pseudoId == freezed
          ? _value.pseudoId
          : pseudoId // ignore: cast_nullable_to_non_nullable
              as String,
      productTypeId: productTypeId == freezed
          ? _value.productTypeId
          : productTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      assetClassId: assetClassId == freezed
          ? _value.assetClassId
          : assetClassId // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: productName == freezed
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      useWarehouse: useWarehouse == freezed
          ? _value.useWarehouse
          : useWarehouse // ignore: cast_nullable_to_non_nullable
              as bool,
      assetCount: assetCount == freezed
          ? _value.assetCount
          : assetCount // ignore: cast_nullable_to_non_nullable
              as int?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Product extends _Product {
  _$_Product(
      {this.productId = "",
      this.pseudoId = "",
      this.productTypeId,
      this.assetClassId,
      this.productName,
      this.description,
      @DecimalConverter() this.price,
      this.category,
      this.useWarehouse = false,
      this.assetCount,
      @Uint8ListConverter() this.image})
      : super._();

  factory _$_Product.fromJson(Map<String, dynamic> json) =>
      _$$_ProductFromJson(json);

  @JsonKey(defaultValue: "")
  @override
  final String productId;
  @JsonKey(defaultValue: "")
  @override
  final String pseudoId;
  @override
  final String? productTypeId;
  @override // assetUse(rental)
  final String? assetClassId;
  @override // room, restaurant table
  final String? productName;
  @override
  final String? description;
  @override
  @DecimalConverter()
  final Decimal? price;
  @override
  final Category? category;
  @JsonKey(defaultValue: false)
  @override
  final bool useWarehouse;
  @override
  final int? assetCount;
  @override
  @Uint8ListConverter()
  final Uint8List? image;

  @override
  String toString() {
    return 'Product(productId: $productId, pseudoId: $pseudoId, productTypeId: $productTypeId, assetClassId: $assetClassId, productName: $productName, description: $description, price: $price, category: $category, useWarehouse: $useWarehouse, assetCount: $assetCount, image: $image)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Product &&
            const DeepCollectionEquality().equals(other.productId, productId) &&
            const DeepCollectionEquality().equals(other.pseudoId, pseudoId) &&
            const DeepCollectionEquality()
                .equals(other.productTypeId, productTypeId) &&
            const DeepCollectionEquality()
                .equals(other.assetClassId, assetClassId) &&
            const DeepCollectionEquality()
                .equals(other.productName, productName) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.price, price) &&
            const DeepCollectionEquality().equals(other.category, category) &&
            const DeepCollectionEquality()
                .equals(other.useWarehouse, useWarehouse) &&
            const DeepCollectionEquality()
                .equals(other.assetCount, assetCount) &&
            const DeepCollectionEquality().equals(other.image, image));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(productId),
      const DeepCollectionEquality().hash(pseudoId),
      const DeepCollectionEquality().hash(productTypeId),
      const DeepCollectionEquality().hash(assetClassId),
      const DeepCollectionEquality().hash(productName),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(price),
      const DeepCollectionEquality().hash(category),
      const DeepCollectionEquality().hash(useWarehouse),
      const DeepCollectionEquality().hash(assetCount),
      const DeepCollectionEquality().hash(image));

  @JsonKey(ignore: true)
  @override
  _$ProductCopyWith<_Product> get copyWith =>
      __$ProductCopyWithImpl<_Product>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProductToJson(this);
  }
}

abstract class _Product extends Product {
  factory _Product(
      {String productId,
      String pseudoId,
      String? productTypeId,
      String? assetClassId,
      String? productName,
      String? description,
      @DecimalConverter() Decimal? price,
      Category? category,
      bool useWarehouse,
      int? assetCount,
      @Uint8ListConverter() Uint8List? image}) = _$_Product;
  _Product._() : super._();

  factory _Product.fromJson(Map<String, dynamic> json) = _$_Product.fromJson;

  @override
  String get productId;
  @override
  String get pseudoId;
  @override
  String? get productTypeId;
  @override // assetUse(rental)
  String? get assetClassId;
  @override // room, restaurant table
  String? get productName;
  @override
  String? get description;
  @override
  @DecimalConverter()
  Decimal? get price;
  @override
  Category? get category;
  @override
  bool get useWarehouse;
  @override
  int? get assetCount;
  @override
  @Uint8ListConverter()
  Uint8List? get image;
  @override
  @JsonKey(ignore: true)
  _$ProductCopyWith<_Product> get copyWith =>
      throw _privateConstructorUsedError;
}
