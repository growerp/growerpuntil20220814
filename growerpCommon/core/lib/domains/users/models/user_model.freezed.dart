// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
class _$UserTearOff {
  const _$UserTearOff();

  _User call(
      {String? partyId,
      String? userId,
      String? firstName,
      String? lastName,
      bool? loginDisabled,
      String? loginName,
      String? email,
      String? groupDescription,
      String? userGroupId,
      String? language,
      String? externalId,
      @Uint8ListConverter() Uint8List? image,
      String? companyPartyId,
      String? companyName,
      Address? companyAddress}) {
    return _User(
      partyId: partyId,
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      loginDisabled: loginDisabled,
      loginName: loginName,
      email: email,
      groupDescription: groupDescription,
      userGroupId: userGroupId,
      language: language,
      externalId: externalId,
      image: image,
      companyPartyId: companyPartyId,
      companyName: companyName,
      companyAddress: companyAddress,
    );
  }

  User fromJson(Map<String, Object?> json) {
    return User.fromJson(json);
  }
}

/// @nodoc
const $User = _$UserTearOff();

/// @nodoc
mixin _$User {
  String? get partyId =>
      throw _privateConstructorUsedError; // allocated by system cannot be changed.
  String? get userId =>
      throw _privateConstructorUsedError; // allocated by system cannot be changed.
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  bool? get loginDisabled =>
      throw _privateConstructorUsedError; // login account is required if disabled just dummy
  String? get loginName => throw _privateConstructorUsedError;
  String? get email =>
      throw _privateConstructorUsedError; // company email address of this person
  String? get groupDescription =>
      throw _privateConstructorUsedError; // admin, employee, customer, supplier etc...
  String? get userGroupId => throw _privateConstructorUsedError;
  String? get language => throw _privateConstructorUsedError;
  String? get externalId =>
      throw _privateConstructorUsedError; // when customer register they give their telno
  @Uint8ListConverter()
  Uint8List? get image => throw _privateConstructorUsedError;
  String? get companyPartyId =>
      throw _privateConstructorUsedError; // allocated by system cannot be changed.
  String? get companyName => throw _privateConstructorUsedError;
  Address? get companyAddress => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {String? partyId,
      String? userId,
      String? firstName,
      String? lastName,
      bool? loginDisabled,
      String? loginName,
      String? email,
      String? groupDescription,
      String? userGroupId,
      String? language,
      String? externalId,
      @Uint8ListConverter() Uint8List? image,
      String? companyPartyId,
      String? companyName,
      Address? companyAddress});

  $AddressCopyWith<$Res>? get companyAddress;
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object? partyId = freezed,
    Object? userId = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? loginDisabled = freezed,
    Object? loginName = freezed,
    Object? email = freezed,
    Object? groupDescription = freezed,
    Object? userGroupId = freezed,
    Object? language = freezed,
    Object? externalId = freezed,
    Object? image = freezed,
    Object? companyPartyId = freezed,
    Object? companyName = freezed,
    Object? companyAddress = freezed,
  }) {
    return _then(_value.copyWith(
      partyId: partyId == freezed
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: firstName == freezed
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: lastName == freezed
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      loginDisabled: loginDisabled == freezed
          ? _value.loginDisabled
          : loginDisabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      loginName: loginName == freezed
          ? _value.loginName
          : loginName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      groupDescription: groupDescription == freezed
          ? _value.groupDescription
          : groupDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      userGroupId: userGroupId == freezed
          ? _value.userGroupId
          : userGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      language: language == freezed
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      externalId: externalId == freezed
          ? _value.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      companyPartyId: companyPartyId == freezed
          ? _value.companyPartyId
          : companyPartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: companyName == freezed
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyAddress: companyAddress == freezed
          ? _value.companyAddress
          : companyAddress // ignore: cast_nullable_to_non_nullable
              as Address?,
    ));
  }

  @override
  $AddressCopyWith<$Res>? get companyAddress {
    if (_value.companyAddress == null) {
      return null;
    }

    return $AddressCopyWith<$Res>(_value.companyAddress!, (value) {
      return _then(_value.copyWith(companyAddress: value));
    });
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? partyId,
      String? userId,
      String? firstName,
      String? lastName,
      bool? loginDisabled,
      String? loginName,
      String? email,
      String? groupDescription,
      String? userGroupId,
      String? language,
      String? externalId,
      @Uint8ListConverter() Uint8List? image,
      String? companyPartyId,
      String? companyName,
      Address? companyAddress});

  @override
  $AddressCopyWith<$Res>? get companyAddress;
}

/// @nodoc
class __$UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(_User _value, $Res Function(_User) _then)
      : super(_value, (v) => _then(v as _User));

  @override
  _User get _value => super._value as _User;

  @override
  $Res call({
    Object? partyId = freezed,
    Object? userId = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? loginDisabled = freezed,
    Object? loginName = freezed,
    Object? email = freezed,
    Object? groupDescription = freezed,
    Object? userGroupId = freezed,
    Object? language = freezed,
    Object? externalId = freezed,
    Object? image = freezed,
    Object? companyPartyId = freezed,
    Object? companyName = freezed,
    Object? companyAddress = freezed,
  }) {
    return _then(_User(
      partyId: partyId == freezed
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: firstName == freezed
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: lastName == freezed
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      loginDisabled: loginDisabled == freezed
          ? _value.loginDisabled
          : loginDisabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      loginName: loginName == freezed
          ? _value.loginName
          : loginName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      groupDescription: groupDescription == freezed
          ? _value.groupDescription
          : groupDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      userGroupId: userGroupId == freezed
          ? _value.userGroupId
          : userGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      language: language == freezed
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      externalId: externalId == freezed
          ? _value.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      companyPartyId: companyPartyId == freezed
          ? _value.companyPartyId
          : companyPartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: companyName == freezed
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyAddress: companyAddress == freezed
          ? _value.companyAddress
          : companyAddress // ignore: cast_nullable_to_non_nullable
              as Address?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_User extends _User with DiagnosticableTreeMixin {
  _$_User(
      {this.partyId,
      this.userId,
      this.firstName,
      this.lastName,
      this.loginDisabled,
      this.loginName,
      this.email,
      this.groupDescription,
      this.userGroupId,
      this.language,
      this.externalId,
      @Uint8ListConverter() this.image,
      this.companyPartyId,
      this.companyName,
      this.companyAddress})
      : super._();

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String? partyId;
  @override // allocated by system cannot be changed.
  final String? userId;
  @override // allocated by system cannot be changed.
  final String? firstName;
  @override
  final String? lastName;
  @override
  final bool? loginDisabled;
  @override // login account is required if disabled just dummy
  final String? loginName;
  @override
  final String? email;
  @override // company email address of this person
  final String? groupDescription;
  @override // admin, employee, customer, supplier etc...
  final String? userGroupId;
  @override
  final String? language;
  @override
  final String? externalId;
  @override // when customer register they give their telno
  @Uint8ListConverter()
  final Uint8List? image;
  @override
  final String? companyPartyId;
  @override // allocated by system cannot be changed.
  final String? companyName;
  @override
  final Address? companyAddress;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'User(partyId: $partyId, userId: $userId, firstName: $firstName, lastName: $lastName, loginDisabled: $loginDisabled, loginName: $loginName, email: $email, groupDescription: $groupDescription, userGroupId: $userGroupId, language: $language, externalId: $externalId, image: $image, companyPartyId: $companyPartyId, companyName: $companyName, companyAddress: $companyAddress)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'User'))
      ..add(DiagnosticsProperty('partyId', partyId))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('firstName', firstName))
      ..add(DiagnosticsProperty('lastName', lastName))
      ..add(DiagnosticsProperty('loginDisabled', loginDisabled))
      ..add(DiagnosticsProperty('loginName', loginName))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('groupDescription', groupDescription))
      ..add(DiagnosticsProperty('userGroupId', userGroupId))
      ..add(DiagnosticsProperty('language', language))
      ..add(DiagnosticsProperty('externalId', externalId))
      ..add(DiagnosticsProperty('image', image))
      ..add(DiagnosticsProperty('companyPartyId', companyPartyId))
      ..add(DiagnosticsProperty('companyName', companyName))
      ..add(DiagnosticsProperty('companyAddress', companyAddress));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _User &&
            const DeepCollectionEquality().equals(other.partyId, partyId) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            const DeepCollectionEquality().equals(other.firstName, firstName) &&
            const DeepCollectionEquality().equals(other.lastName, lastName) &&
            const DeepCollectionEquality()
                .equals(other.loginDisabled, loginDisabled) &&
            const DeepCollectionEquality().equals(other.loginName, loginName) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality()
                .equals(other.groupDescription, groupDescription) &&
            const DeepCollectionEquality()
                .equals(other.userGroupId, userGroupId) &&
            const DeepCollectionEquality().equals(other.language, language) &&
            const DeepCollectionEquality()
                .equals(other.externalId, externalId) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            const DeepCollectionEquality()
                .equals(other.companyPartyId, companyPartyId) &&
            const DeepCollectionEquality()
                .equals(other.companyName, companyName) &&
            const DeepCollectionEquality()
                .equals(other.companyAddress, companyAddress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(partyId),
      const DeepCollectionEquality().hash(userId),
      const DeepCollectionEquality().hash(firstName),
      const DeepCollectionEquality().hash(lastName),
      const DeepCollectionEquality().hash(loginDisabled),
      const DeepCollectionEquality().hash(loginName),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(groupDescription),
      const DeepCollectionEquality().hash(userGroupId),
      const DeepCollectionEquality().hash(language),
      const DeepCollectionEquality().hash(externalId),
      const DeepCollectionEquality().hash(image),
      const DeepCollectionEquality().hash(companyPartyId),
      const DeepCollectionEquality().hash(companyName),
      const DeepCollectionEquality().hash(companyAddress));

  @JsonKey(ignore: true)
  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(this);
  }
}

abstract class _User extends User {
  factory _User(
      {String? partyId,
      String? userId,
      String? firstName,
      String? lastName,
      bool? loginDisabled,
      String? loginName,
      String? email,
      String? groupDescription,
      String? userGroupId,
      String? language,
      String? externalId,
      @Uint8ListConverter() Uint8List? image,
      String? companyPartyId,
      String? companyName,
      Address? companyAddress}) = _$_User;
  _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String? get partyId;
  @override // allocated by system cannot be changed.
  String? get userId;
  @override // allocated by system cannot be changed.
  String? get firstName;
  @override
  String? get lastName;
  @override
  bool? get loginDisabled;
  @override // login account is required if disabled just dummy
  String? get loginName;
  @override
  String? get email;
  @override // company email address of this person
  String? get groupDescription;
  @override // admin, employee, customer, supplier etc...
  String? get userGroupId;
  @override
  String? get language;
  @override
  String? get externalId;
  @override // when customer register they give their telno
  @Uint8ListConverter()
  Uint8List? get image;
  @override
  String? get companyPartyId;
  @override // allocated by system cannot be changed.
  String? get companyName;
  @override
  Address? get companyAddress;
  @override
  @JsonKey(ignore: true)
  _$UserCopyWith<_User> get copyWith => throw _privateConstructorUsedError;
}
