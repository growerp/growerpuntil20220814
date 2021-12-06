// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chatMessage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
class _$ChatMessageTearOff {
  const _$ChatMessageTearOff();

  _ChatMessage call(
      {String? fromUserId,
      String? chatMessageId,
      String? content,
      @DateTimeConverter() DateTime? creationDate}) {
    return _ChatMessage(
      fromUserId: fromUserId,
      chatMessageId: chatMessageId,
      content: content,
      creationDate: creationDate,
    );
  }

  ChatMessage fromJson(Map<String, Object?> json) {
    return ChatMessage.fromJson(json);
  }
}

/// @nodoc
const $ChatMessage = _$ChatMessageTearOff();

/// @nodoc
mixin _$ChatMessage {
  String? get fromUserId => throw _privateConstructorUsedError;
  String? get chatMessageId => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get creationDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res>;
  $Res call(
      {String? fromUserId,
      String? chatMessageId,
      String? content,
      @DateTimeConverter() DateTime? creationDate});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res> implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  final ChatMessage _value;
  // ignore: unused_field
  final $Res Function(ChatMessage) _then;

  @override
  $Res call({
    Object? fromUserId = freezed,
    Object? chatMessageId = freezed,
    Object? content = freezed,
    Object? creationDate = freezed,
  }) {
    return _then(_value.copyWith(
      fromUserId: fromUserId == freezed
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      chatMessageId: chatMessageId == freezed
          ? _value.chatMessageId
          : chatMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
abstract class _$ChatMessageCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(
          _ChatMessage value, $Res Function(_ChatMessage) then) =
      __$ChatMessageCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? fromUserId,
      String? chatMessageId,
      String? content,
      @DateTimeConverter() DateTime? creationDate});
}

/// @nodoc
class __$ChatMessageCopyWithImpl<$Res> extends _$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(
      _ChatMessage _value, $Res Function(_ChatMessage) _then)
      : super(_value, (v) => _then(v as _ChatMessage));

  @override
  _ChatMessage get _value => super._value as _ChatMessage;

  @override
  $Res call({
    Object? fromUserId = freezed,
    Object? chatMessageId = freezed,
    Object? content = freezed,
    Object? creationDate = freezed,
  }) {
    return _then(_ChatMessage(
      fromUserId: fromUserId == freezed
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      chatMessageId: chatMessageId == freezed
          ? _value.chatMessageId
          : chatMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChatMessage extends _ChatMessage {
  _$_ChatMessage(
      {this.fromUserId,
      this.chatMessageId,
      this.content,
      @DateTimeConverter() this.creationDate})
      : super._();

  factory _$_ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$$_ChatMessageFromJson(json);

  @override
  final String? fromUserId;
  @override
  final String? chatMessageId;
  @override
  final String? content;
  @override
  @DateTimeConverter()
  final DateTime? creationDate;

  @override
  String toString() {
    return 'ChatMessage(fromUserId: $fromUserId, chatMessageId: $chatMessageId, content: $content, creationDate: $creationDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatMessage &&
            const DeepCollectionEquality()
                .equals(other.fromUserId, fromUserId) &&
            const DeepCollectionEquality()
                .equals(other.chatMessageId, chatMessageId) &&
            const DeepCollectionEquality().equals(other.content, content) &&
            const DeepCollectionEquality()
                .equals(other.creationDate, creationDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(fromUserId),
      const DeepCollectionEquality().hash(chatMessageId),
      const DeepCollectionEquality().hash(content),
      const DeepCollectionEquality().hash(creationDate));

  @JsonKey(ignore: true)
  @override
  _$ChatMessageCopyWith<_ChatMessage> get copyWith =>
      __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChatMessageToJson(this);
  }
}

abstract class _ChatMessage extends ChatMessage {
  factory _ChatMessage(
      {String? fromUserId,
      String? chatMessageId,
      String? content,
      @DateTimeConverter() DateTime? creationDate}) = _$_ChatMessage;
  _ChatMessage._() : super._();

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$_ChatMessage.fromJson;

  @override
  String? get fromUserId;
  @override
  String? get chatMessageId;
  @override
  String? get content;
  @override
  @DateTimeConverter()
  DateTime? get creationDate;
  @override
  @JsonKey(ignore: true)
  _$ChatMessageCopyWith<_ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}
