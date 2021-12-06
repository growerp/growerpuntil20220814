// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chatRoomMember_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatRoomMember _$ChatRoomMemberFromJson(Map<String, dynamic> json) {
  return _ChatRoomMember.fromJson(json);
}

/// @nodoc
class _$ChatRoomMemberTearOff {
  const _$ChatRoomMemberTearOff();

  _ChatRoomMember call({User? member, bool? hasRead, bool? isActive}) {
    return _ChatRoomMember(
      member: member,
      hasRead: hasRead,
      isActive: isActive,
    );
  }

  ChatRoomMember fromJson(Map<String, Object?> json) {
    return ChatRoomMember.fromJson(json);
  }
}

/// @nodoc
const $ChatRoomMember = _$ChatRoomMemberTearOff();

/// @nodoc
mixin _$ChatRoomMember {
  User? get member => throw _privateConstructorUsedError;
  bool? get hasRead => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatRoomMemberCopyWith<ChatRoomMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomMemberCopyWith<$Res> {
  factory $ChatRoomMemberCopyWith(
          ChatRoomMember value, $Res Function(ChatRoomMember) then) =
      _$ChatRoomMemberCopyWithImpl<$Res>;
  $Res call({User? member, bool? hasRead, bool? isActive});

  $UserCopyWith<$Res>? get member;
}

/// @nodoc
class _$ChatRoomMemberCopyWithImpl<$Res>
    implements $ChatRoomMemberCopyWith<$Res> {
  _$ChatRoomMemberCopyWithImpl(this._value, this._then);

  final ChatRoomMember _value;
  // ignore: unused_field
  final $Res Function(ChatRoomMember) _then;

  @override
  $Res call({
    Object? member = freezed,
    Object? hasRead = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_value.copyWith(
      member: member == freezed
          ? _value.member
          : member // ignore: cast_nullable_to_non_nullable
              as User?,
      hasRead: hasRead == freezed
          ? _value.hasRead
          : hasRead // ignore: cast_nullable_to_non_nullable
              as bool?,
      isActive: isActive == freezed
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }

  @override
  $UserCopyWith<$Res>? get member {
    if (_value.member == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.member!, (value) {
      return _then(_value.copyWith(member: value));
    });
  }
}

/// @nodoc
abstract class _$ChatRoomMemberCopyWith<$Res>
    implements $ChatRoomMemberCopyWith<$Res> {
  factory _$ChatRoomMemberCopyWith(
          _ChatRoomMember value, $Res Function(_ChatRoomMember) then) =
      __$ChatRoomMemberCopyWithImpl<$Res>;
  @override
  $Res call({User? member, bool? hasRead, bool? isActive});

  @override
  $UserCopyWith<$Res>? get member;
}

/// @nodoc
class __$ChatRoomMemberCopyWithImpl<$Res>
    extends _$ChatRoomMemberCopyWithImpl<$Res>
    implements _$ChatRoomMemberCopyWith<$Res> {
  __$ChatRoomMemberCopyWithImpl(
      _ChatRoomMember _value, $Res Function(_ChatRoomMember) _then)
      : super(_value, (v) => _then(v as _ChatRoomMember));

  @override
  _ChatRoomMember get _value => super._value as _ChatRoomMember;

  @override
  $Res call({
    Object? member = freezed,
    Object? hasRead = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_ChatRoomMember(
      member: member == freezed
          ? _value.member
          : member // ignore: cast_nullable_to_non_nullable
              as User?,
      hasRead: hasRead == freezed
          ? _value.hasRead
          : hasRead // ignore: cast_nullable_to_non_nullable
              as bool?,
      isActive: isActive == freezed
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChatRoomMember extends _ChatRoomMember {
  _$_ChatRoomMember({this.member, this.hasRead, this.isActive}) : super._();

  factory _$_ChatRoomMember.fromJson(Map<String, dynamic> json) =>
      _$$_ChatRoomMemberFromJson(json);

  @override
  final User? member;
  @override
  final bool? hasRead;
  @override
  final bool? isActive;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatRoomMember &&
            const DeepCollectionEquality().equals(other.member, member) &&
            const DeepCollectionEquality().equals(other.hasRead, hasRead) &&
            const DeepCollectionEquality().equals(other.isActive, isActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(member),
      const DeepCollectionEquality().hash(hasRead),
      const DeepCollectionEquality().hash(isActive));

  @JsonKey(ignore: true)
  @override
  _$ChatRoomMemberCopyWith<_ChatRoomMember> get copyWith =>
      __$ChatRoomMemberCopyWithImpl<_ChatRoomMember>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChatRoomMemberToJson(this);
  }
}

abstract class _ChatRoomMember extends ChatRoomMember {
  factory _ChatRoomMember({User? member, bool? hasRead, bool? isActive}) =
      _$_ChatRoomMember;
  _ChatRoomMember._() : super._();

  factory _ChatRoomMember.fromJson(Map<String, dynamic> json) =
      _$_ChatRoomMember.fromJson;

  @override
  User? get member;
  @override
  bool? get hasRead;
  @override
  bool? get isActive;
  @override
  @JsonKey(ignore: true)
  _$ChatRoomMemberCopyWith<_ChatRoomMember> get copyWith =>
      throw _privateConstructorUsedError;
}
