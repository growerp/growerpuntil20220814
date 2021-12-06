// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'itemType_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ItemType _$ItemTypeFromJson(Map<String, dynamic> json) {
  return _ItemType.fromJson(json);
}

/// @nodoc
class _$ItemTypeTearOff {
  const _$ItemTypeTearOff();

  _ItemType call({String? itemTypeId, String? itemTypeName}) {
    return _ItemType(
      itemTypeId: itemTypeId,
      itemTypeName: itemTypeName,
    );
  }

  ItemType fromJson(Map<String, Object?> json) {
    return ItemType.fromJson(json);
  }
}

/// @nodoc
const $ItemType = _$ItemTypeTearOff();

/// @nodoc
mixin _$ItemType {
  String? get itemTypeId => throw _privateConstructorUsedError;
  String? get itemTypeName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItemTypeCopyWith<ItemType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemTypeCopyWith<$Res> {
  factory $ItemTypeCopyWith(ItemType value, $Res Function(ItemType) then) =
      _$ItemTypeCopyWithImpl<$Res>;
  $Res call({String? itemTypeId, String? itemTypeName});
}

/// @nodoc
class _$ItemTypeCopyWithImpl<$Res> implements $ItemTypeCopyWith<$Res> {
  _$ItemTypeCopyWithImpl(this._value, this._then);

  final ItemType _value;
  // ignore: unused_field
  final $Res Function(ItemType) _then;

  @override
  $Res call({
    Object? itemTypeId = freezed,
    Object? itemTypeName = freezed,
  }) {
    return _then(_value.copyWith(
      itemTypeId: itemTypeId == freezed
          ? _value.itemTypeId
          : itemTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemTypeName: itemTypeName == freezed
          ? _value.itemTypeName
          : itemTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$ItemTypeCopyWith<$Res> implements $ItemTypeCopyWith<$Res> {
  factory _$ItemTypeCopyWith(_ItemType value, $Res Function(_ItemType) then) =
      __$ItemTypeCopyWithImpl<$Res>;
  @override
  $Res call({String? itemTypeId, String? itemTypeName});
}

/// @nodoc
class __$ItemTypeCopyWithImpl<$Res> extends _$ItemTypeCopyWithImpl<$Res>
    implements _$ItemTypeCopyWith<$Res> {
  __$ItemTypeCopyWithImpl(_ItemType _value, $Res Function(_ItemType) _then)
      : super(_value, (v) => _then(v as _ItemType));

  @override
  _ItemType get _value => super._value as _ItemType;

  @override
  $Res call({
    Object? itemTypeId = freezed,
    Object? itemTypeName = freezed,
  }) {
    return _then(_ItemType(
      itemTypeId: itemTypeId == freezed
          ? _value.itemTypeId
          : itemTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemTypeName: itemTypeName == freezed
          ? _value.itemTypeName
          : itemTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ItemType extends _ItemType with DiagnosticableTreeMixin {
  _$_ItemType({this.itemTypeId, this.itemTypeName}) : super._();

  factory _$_ItemType.fromJson(Map<String, dynamic> json) =>
      _$$_ItemTypeFromJson(json);

  @override
  final String? itemTypeId;
  @override
  final String? itemTypeName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ItemType(itemTypeId: $itemTypeId, itemTypeName: $itemTypeName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ItemType'))
      ..add(DiagnosticsProperty('itemTypeId', itemTypeId))
      ..add(DiagnosticsProperty('itemTypeName', itemTypeName));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ItemType &&
            const DeepCollectionEquality()
                .equals(other.itemTypeId, itemTypeId) &&
            const DeepCollectionEquality()
                .equals(other.itemTypeName, itemTypeName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(itemTypeId),
      const DeepCollectionEquality().hash(itemTypeName));

  @JsonKey(ignore: true)
  @override
  _$ItemTypeCopyWith<_ItemType> get copyWith =>
      __$ItemTypeCopyWithImpl<_ItemType>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ItemTypeToJson(this);
  }
}

abstract class _ItemType extends ItemType {
  factory _ItemType({String? itemTypeId, String? itemTypeName}) = _$_ItemType;
  _ItemType._() : super._();

  factory _ItemType.fromJson(Map<String, dynamic> json) = _$_ItemType.fromJson;

  @override
  String? get itemTypeId;
  @override
  String? get itemTypeName;
  @override
  @JsonKey(ignore: true)
  _$ItemTypeCopyWith<_ItemType> get copyWith =>
      throw _privateConstructorUsedError;
}
