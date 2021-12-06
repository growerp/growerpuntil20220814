// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'authenticate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Authenticate _$AuthenticateFromJson(Map<String, dynamic> json) {
  return _Authenticate.fromJson(json);
}

/// @nodoc
class _$AuthenticateTearOff {
  const _$AuthenticateTearOff();

  _Authenticate call(
      {String? apiKey,
      String? moquiSessionToken,
      Company? company,
      User? user,
      Stats? stats}) {
    return _Authenticate(
      apiKey: apiKey,
      moquiSessionToken: moquiSessionToken,
      company: company,
      user: user,
      stats: stats,
    );
  }

  Authenticate fromJson(Map<String, Object?> json) {
    return Authenticate.fromJson(json);
  }
}

/// @nodoc
const $Authenticate = _$AuthenticateTearOff();

/// @nodoc
mixin _$Authenticate {
  String? get apiKey => throw _privateConstructorUsedError;
  String? get moquiSessionToken => throw _privateConstructorUsedError;
  Company? get company =>
      throw _privateConstructorUsedError; //postall address not used here, use user comp address
  User? get user =>
      throw _privateConstructorUsedError; // user has a company companyAddress
  Stats? get stats => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthenticateCopyWith<Authenticate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticateCopyWith<$Res> {
  factory $AuthenticateCopyWith(
          Authenticate value, $Res Function(Authenticate) then) =
      _$AuthenticateCopyWithImpl<$Res>;
  $Res call(
      {String? apiKey,
      String? moquiSessionToken,
      Company? company,
      User? user,
      Stats? stats});

  $CompanyCopyWith<$Res>? get company;
  $UserCopyWith<$Res>? get user;
  $StatsCopyWith<$Res>? get stats;
}

/// @nodoc
class _$AuthenticateCopyWithImpl<$Res> implements $AuthenticateCopyWith<$Res> {
  _$AuthenticateCopyWithImpl(this._value, this._then);

  final Authenticate _value;
  // ignore: unused_field
  final $Res Function(Authenticate) _then;

  @override
  $Res call({
    Object? apiKey = freezed,
    Object? moquiSessionToken = freezed,
    Object? company = freezed,
    Object? user = freezed,
    Object? stats = freezed,
  }) {
    return _then(_value.copyWith(
      apiKey: apiKey == freezed
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      moquiSessionToken: moquiSessionToken == freezed
          ? _value.moquiSessionToken
          : moquiSessionToken // ignore: cast_nullable_to_non_nullable
              as String?,
      company: company == freezed
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as Company?,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      stats: stats == freezed
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as Stats?,
    ));
  }

  @override
  $CompanyCopyWith<$Res>? get company {
    if (_value.company == null) {
      return null;
    }

    return $CompanyCopyWith<$Res>(_value.company!, (value) {
      return _then(_value.copyWith(company: value));
    });
  }

  @override
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value));
    });
  }

  @override
  $StatsCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $StatsCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value));
    });
  }
}

/// @nodoc
abstract class _$AuthenticateCopyWith<$Res>
    implements $AuthenticateCopyWith<$Res> {
  factory _$AuthenticateCopyWith(
          _Authenticate value, $Res Function(_Authenticate) then) =
      __$AuthenticateCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? apiKey,
      String? moquiSessionToken,
      Company? company,
      User? user,
      Stats? stats});

  @override
  $CompanyCopyWith<$Res>? get company;
  @override
  $UserCopyWith<$Res>? get user;
  @override
  $StatsCopyWith<$Res>? get stats;
}

/// @nodoc
class __$AuthenticateCopyWithImpl<$Res> extends _$AuthenticateCopyWithImpl<$Res>
    implements _$AuthenticateCopyWith<$Res> {
  __$AuthenticateCopyWithImpl(
      _Authenticate _value, $Res Function(_Authenticate) _then)
      : super(_value, (v) => _then(v as _Authenticate));

  @override
  _Authenticate get _value => super._value as _Authenticate;

  @override
  $Res call({
    Object? apiKey = freezed,
    Object? moquiSessionToken = freezed,
    Object? company = freezed,
    Object? user = freezed,
    Object? stats = freezed,
  }) {
    return _then(_Authenticate(
      apiKey: apiKey == freezed
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      moquiSessionToken: moquiSessionToken == freezed
          ? _value.moquiSessionToken
          : moquiSessionToken // ignore: cast_nullable_to_non_nullable
              as String?,
      company: company == freezed
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as Company?,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      stats: stats == freezed
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as Stats?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Authenticate extends _Authenticate {
  _$_Authenticate(
      {this.apiKey,
      this.moquiSessionToken,
      this.company,
      this.user,
      this.stats})
      : super._();

  factory _$_Authenticate.fromJson(Map<String, dynamic> json) =>
      _$$_AuthenticateFromJson(json);

  @override
  final String? apiKey;
  @override
  final String? moquiSessionToken;
  @override
  final Company? company;
  @override //postall address not used here, use user comp address
  final User? user;
  @override // user has a company companyAddress
  final Stats? stats;

  @override
  String toString() {
    return 'Authenticate(apiKey: $apiKey, moquiSessionToken: $moquiSessionToken, company: $company, user: $user, stats: $stats)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Authenticate &&
            const DeepCollectionEquality().equals(other.apiKey, apiKey) &&
            const DeepCollectionEquality()
                .equals(other.moquiSessionToken, moquiSessionToken) &&
            const DeepCollectionEquality().equals(other.company, company) &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality().equals(other.stats, stats));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(apiKey),
      const DeepCollectionEquality().hash(moquiSessionToken),
      const DeepCollectionEquality().hash(company),
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(stats));

  @JsonKey(ignore: true)
  @override
  _$AuthenticateCopyWith<_Authenticate> get copyWith =>
      __$AuthenticateCopyWithImpl<_Authenticate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthenticateToJson(this);
  }
}

abstract class _Authenticate extends Authenticate {
  factory _Authenticate(
      {String? apiKey,
      String? moquiSessionToken,
      Company? company,
      User? user,
      Stats? stats}) = _$_Authenticate;
  _Authenticate._() : super._();

  factory _Authenticate.fromJson(Map<String, dynamic> json) =
      _$_Authenticate.fromJson;

  @override
  String? get apiKey;
  @override
  String? get moquiSessionToken;
  @override
  Company? get company;
  @override //postall address not used here, use user comp address
  User? get user;
  @override // user has a company companyAddress
  Stats? get stats;
  @override
  @JsonKey(ignore: true)
  _$AuthenticateCopyWith<_Authenticate> get copyWith =>
      throw _privateConstructorUsedError;
}
