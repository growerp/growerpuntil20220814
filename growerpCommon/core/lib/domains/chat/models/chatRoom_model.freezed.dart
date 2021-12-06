// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chatRoom_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) {
  return _ChatRoom.fromJson(json);
}

/// @nodoc
class _$ChatRoomTearOff {
  const _$ChatRoomTearOff();

  _ChatRoom call(
      {String? chatRoomId,
      String? chatRoomName,
      String? lastMessage,
      bool? isPrivate,
      List<ChatRoomMember> members = const []}) {
    return _ChatRoom(
      chatRoomId: chatRoomId,
      chatRoomName: chatRoomName,
      lastMessage: lastMessage,
      isPrivate: isPrivate,
      members: members,
    );
  }

  ChatRoom fromJson(Map<String, Object?> json) {
    return ChatRoom.fromJson(json);
  }
}

/// @nodoc
const $ChatRoom = _$ChatRoomTearOff();

/// @nodoc
mixin _$ChatRoom {
  String? get chatRoomId => throw _privateConstructorUsedError;
  String? get chatRoomName => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  bool? get isPrivate => throw _privateConstructorUsedError;
  List<ChatRoomMember> get members => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatRoomCopyWith<ChatRoom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomCopyWith<$Res> {
  factory $ChatRoomCopyWith(ChatRoom value, $Res Function(ChatRoom) then) =
      _$ChatRoomCopyWithImpl<$Res>;
  $Res call(
      {String? chatRoomId,
      String? chatRoomName,
      String? lastMessage,
      bool? isPrivate,
      List<ChatRoomMember> members});
}

/// @nodoc
class _$ChatRoomCopyWithImpl<$Res> implements $ChatRoomCopyWith<$Res> {
  _$ChatRoomCopyWithImpl(this._value, this._then);

  final ChatRoom _value;
  // ignore: unused_field
  final $Res Function(ChatRoom) _then;

  @override
  $Res call({
    Object? chatRoomId = freezed,
    Object? chatRoomName = freezed,
    Object? lastMessage = freezed,
    Object? isPrivate = freezed,
    Object? members = freezed,
  }) {
    return _then(_value.copyWith(
      chatRoomId: chatRoomId == freezed
          ? _value.chatRoomId
          : chatRoomId // ignore: cast_nullable_to_non_nullable
              as String?,
      chatRoomName: chatRoomName == freezed
          ? _value.chatRoomName
          : chatRoomName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: lastMessage == freezed
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrivate: isPrivate == freezed
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool?,
      members: members == freezed
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ChatRoomMember>,
    ));
  }
}

/// @nodoc
abstract class _$ChatRoomCopyWith<$Res> implements $ChatRoomCopyWith<$Res> {
  factory _$ChatRoomCopyWith(_ChatRoom value, $Res Function(_ChatRoom) then) =
      __$ChatRoomCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? chatRoomId,
      String? chatRoomName,
      String? lastMessage,
      bool? isPrivate,
      List<ChatRoomMember> members});
}

/// @nodoc
class __$ChatRoomCopyWithImpl<$Res> extends _$ChatRoomCopyWithImpl<$Res>
    implements _$ChatRoomCopyWith<$Res> {
  __$ChatRoomCopyWithImpl(_ChatRoom _value, $Res Function(_ChatRoom) _then)
      : super(_value, (v) => _then(v as _ChatRoom));

  @override
  _ChatRoom get _value => super._value as _ChatRoom;

  @override
  $Res call({
    Object? chatRoomId = freezed,
    Object? chatRoomName = freezed,
    Object? lastMessage = freezed,
    Object? isPrivate = freezed,
    Object? members = freezed,
  }) {
    return _then(_ChatRoom(
      chatRoomId: chatRoomId == freezed
          ? _value.chatRoomId
          : chatRoomId // ignore: cast_nullable_to_non_nullable
              as String?,
      chatRoomName: chatRoomName == freezed
          ? _value.chatRoomName
          : chatRoomName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: lastMessage == freezed
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrivate: isPrivate == freezed
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool?,
      members: members == freezed
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ChatRoomMember>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChatRoom extends _ChatRoom {
  _$_ChatRoom(
      {this.chatRoomId,
      this.chatRoomName,
      this.lastMessage,
      this.isPrivate,
      this.members = const []})
      : super._();

  factory _$_ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$$_ChatRoomFromJson(json);

  @override
  final String? chatRoomId;
  @override
  final String? chatRoomName;
  @override
  final String? lastMessage;
  @override
  final bool? isPrivate;
  @JsonKey(defaultValue: const [])
  @override
  final List<ChatRoomMember> members;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatRoom &&
            const DeepCollectionEquality()
                .equals(other.chatRoomId, chatRoomId) &&
            const DeepCollectionEquality()
                .equals(other.chatRoomName, chatRoomName) &&
            const DeepCollectionEquality()
                .equals(other.lastMessage, lastMessage) &&
            const DeepCollectionEquality().equals(other.isPrivate, isPrivate) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(chatRoomId),
      const DeepCollectionEquality().hash(chatRoomName),
      const DeepCollectionEquality().hash(lastMessage),
      const DeepCollectionEquality().hash(isPrivate),
      const DeepCollectionEquality().hash(members));

  @JsonKey(ignore: true)
  @override
  _$ChatRoomCopyWith<_ChatRoom> get copyWith =>
      __$ChatRoomCopyWithImpl<_ChatRoom>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChatRoomToJson(this);
  }
}

abstract class _ChatRoom extends ChatRoom {
  factory _ChatRoom(
      {String? chatRoomId,
      String? chatRoomName,
      String? lastMessage,
      bool? isPrivate,
      List<ChatRoomMember> members}) = _$_ChatRoom;
  _ChatRoom._() : super._();

  factory _ChatRoom.fromJson(Map<String, dynamic> json) = _$_ChatRoom.fromJson;

  @override
  String? get chatRoomId;
  @override
  String? get chatRoomName;
  @override
  String? get lastMessage;
  @override
  bool? get isPrivate;
  @override
  List<ChatRoomMember> get members;
  @override
  @JsonKey(ignore: true)
  _$ChatRoomCopyWith<_ChatRoom> get copyWith =>
      throw _privateConstructorUsedError;
}
