// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'wsChatMessage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WsChatMessage _$WsChatMessageFromJson(Map<String, dynamic> json) {
  return _WsChatMessage.fromJson(json);
}

/// @nodoc
class _$WsChatMessageTearOff {
  const _$WsChatMessageTearOff();

  _WsChatMessage call(
      {String? toUserId,
      String fromUserId = '',
      String content = '',
      String? chatRoomId}) {
    return _WsChatMessage(
      toUserId: toUserId,
      fromUserId: fromUserId,
      content: content,
      chatRoomId: chatRoomId,
    );
  }

  WsChatMessage fromJson(Map<String, Object?> json) {
    return WsChatMessage.fromJson(json);
  }
}

/// @nodoc
const $WsChatMessage = _$WsChatMessageTearOff();

/// @nodoc
mixin _$WsChatMessage {
  String? get toUserId => throw _privateConstructorUsedError;
  String get fromUserId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get chatRoomId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WsChatMessageCopyWith<WsChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WsChatMessageCopyWith<$Res> {
  factory $WsChatMessageCopyWith(
          WsChatMessage value, $Res Function(WsChatMessage) then) =
      _$WsChatMessageCopyWithImpl<$Res>;
  $Res call(
      {String? toUserId,
      String fromUserId,
      String content,
      String? chatRoomId});
}

/// @nodoc
class _$WsChatMessageCopyWithImpl<$Res>
    implements $WsChatMessageCopyWith<$Res> {
  _$WsChatMessageCopyWithImpl(this._value, this._then);

  final WsChatMessage _value;
  // ignore: unused_field
  final $Res Function(WsChatMessage) _then;

  @override
  $Res call({
    Object? toUserId = freezed,
    Object? fromUserId = freezed,
    Object? content = freezed,
    Object? chatRoomId = freezed,
  }) {
    return _then(_value.copyWith(
      toUserId: toUserId == freezed
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserId: fromUserId == freezed
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      chatRoomId: chatRoomId == freezed
          ? _value.chatRoomId
          : chatRoomId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$WsChatMessageCopyWith<$Res>
    implements $WsChatMessageCopyWith<$Res> {
  factory _$WsChatMessageCopyWith(
          _WsChatMessage value, $Res Function(_WsChatMessage) then) =
      __$WsChatMessageCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? toUserId,
      String fromUserId,
      String content,
      String? chatRoomId});
}

/// @nodoc
class __$WsChatMessageCopyWithImpl<$Res>
    extends _$WsChatMessageCopyWithImpl<$Res>
    implements _$WsChatMessageCopyWith<$Res> {
  __$WsChatMessageCopyWithImpl(
      _WsChatMessage _value, $Res Function(_WsChatMessage) _then)
      : super(_value, (v) => _then(v as _WsChatMessage));

  @override
  _WsChatMessage get _value => super._value as _WsChatMessage;

  @override
  $Res call({
    Object? toUserId = freezed,
    Object? fromUserId = freezed,
    Object? content = freezed,
    Object? chatRoomId = freezed,
  }) {
    return _then(_WsChatMessage(
      toUserId: toUserId == freezed
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserId: fromUserId == freezed
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      chatRoomId: chatRoomId == freezed
          ? _value.chatRoomId
          : chatRoomId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WsChatMessage extends _WsChatMessage with DiagnosticableTreeMixin {
  _$_WsChatMessage(
      {this.toUserId, this.fromUserId = '', this.content = '', this.chatRoomId})
      : super._();

  factory _$_WsChatMessage.fromJson(Map<String, dynamic> json) =>
      _$$_WsChatMessageFromJson(json);

  @override
  final String? toUserId;
  @JsonKey(defaultValue: '')
  @override
  final String fromUserId;
  @JsonKey(defaultValue: '')
  @override
  final String content;
  @override
  final String? chatRoomId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WsChatMessage(toUserId: $toUserId, fromUserId: $fromUserId, content: $content, chatRoomId: $chatRoomId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WsChatMessage'))
      ..add(DiagnosticsProperty('toUserId', toUserId))
      ..add(DiagnosticsProperty('fromUserId', fromUserId))
      ..add(DiagnosticsProperty('content', content))
      ..add(DiagnosticsProperty('chatRoomId', chatRoomId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WsChatMessage &&
            const DeepCollectionEquality().equals(other.toUserId, toUserId) &&
            const DeepCollectionEquality()
                .equals(other.fromUserId, fromUserId) &&
            const DeepCollectionEquality().equals(other.content, content) &&
            const DeepCollectionEquality()
                .equals(other.chatRoomId, chatRoomId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(toUserId),
      const DeepCollectionEquality().hash(fromUserId),
      const DeepCollectionEquality().hash(content),
      const DeepCollectionEquality().hash(chatRoomId));

  @JsonKey(ignore: true)
  @override
  _$WsChatMessageCopyWith<_WsChatMessage> get copyWith =>
      __$WsChatMessageCopyWithImpl<_WsChatMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WsChatMessageToJson(this);
  }
}

abstract class _WsChatMessage extends WsChatMessage {
  factory _WsChatMessage(
      {String? toUserId,
      String fromUserId,
      String content,
      String? chatRoomId}) = _$_WsChatMessage;
  _WsChatMessage._() : super._();

  factory _WsChatMessage.fromJson(Map<String, dynamic> json) =
      _$_WsChatMessage.fromJson;

  @override
  String? get toUserId;
  @override
  String get fromUserId;
  @override
  String get content;
  @override
  String? get chatRoomId;
  @override
  @JsonKey(ignore: true)
  _$WsChatMessageCopyWith<_WsChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}
