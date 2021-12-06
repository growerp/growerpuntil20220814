// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'opportunity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Opportunity _$OpportunityFromJson(Map<String, dynamic> json) {
  return _Opportunity.fromJson(json);
}

/// @nodoc
class _$OpportunityTearOff {
  const _$OpportunityTearOff();

  _Opportunity call(
      {@DateTimeConverter() DateTime? lastUpdated,
      String? opportunityId,
      String? opportunityName,
      String? description,
      @DecimalConverter() Decimal? estAmount,
      int? estProbability,
      String? stageId,
      String? nextStep,
      User? employeeUser,
      User? leadUser}) {
    return _Opportunity(
      lastUpdated: lastUpdated,
      opportunityId: opportunityId,
      opportunityName: opportunityName,
      description: description,
      estAmount: estAmount,
      estProbability: estProbability,
      stageId: stageId,
      nextStep: nextStep,
      employeeUser: employeeUser,
      leadUser: leadUser,
    );
  }

  Opportunity fromJson(Map<String, Object?> json) {
    return Opportunity.fromJson(json);
  }
}

/// @nodoc
const $Opportunity = _$OpportunityTearOff();

/// @nodoc
mixin _$Opportunity {
  @DateTimeConverter()
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  String? get opportunityId => throw _privateConstructorUsedError;
  String? get opportunityName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal? get estAmount => throw _privateConstructorUsedError;
  int? get estProbability => throw _privateConstructorUsedError;
  String? get stageId => throw _privateConstructorUsedError;
  String? get nextStep => throw _privateConstructorUsedError;
  User? get employeeUser => throw _privateConstructorUsedError;
  User? get leadUser => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OpportunityCopyWith<Opportunity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpportunityCopyWith<$Res> {
  factory $OpportunityCopyWith(
          Opportunity value, $Res Function(Opportunity) then) =
      _$OpportunityCopyWithImpl<$Res>;
  $Res call(
      {@DateTimeConverter() DateTime? lastUpdated,
      String? opportunityId,
      String? opportunityName,
      String? description,
      @DecimalConverter() Decimal? estAmount,
      int? estProbability,
      String? stageId,
      String? nextStep,
      User? employeeUser,
      User? leadUser});

  $UserCopyWith<$Res>? get employeeUser;
  $UserCopyWith<$Res>? get leadUser;
}

/// @nodoc
class _$OpportunityCopyWithImpl<$Res> implements $OpportunityCopyWith<$Res> {
  _$OpportunityCopyWithImpl(this._value, this._then);

  final Opportunity _value;
  // ignore: unused_field
  final $Res Function(Opportunity) _then;

  @override
  $Res call({
    Object? lastUpdated = freezed,
    Object? opportunityId = freezed,
    Object? opportunityName = freezed,
    Object? description = freezed,
    Object? estAmount = freezed,
    Object? estProbability = freezed,
    Object? stageId = freezed,
    Object? nextStep = freezed,
    Object? employeeUser = freezed,
    Object? leadUser = freezed,
  }) {
    return _then(_value.copyWith(
      lastUpdated: lastUpdated == freezed
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      opportunityId: opportunityId == freezed
          ? _value.opportunityId
          : opportunityId // ignore: cast_nullable_to_non_nullable
              as String?,
      opportunityName: opportunityName == freezed
          ? _value.opportunityName
          : opportunityName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      estAmount: estAmount == freezed
          ? _value.estAmount
          : estAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      estProbability: estProbability == freezed
          ? _value.estProbability
          : estProbability // ignore: cast_nullable_to_non_nullable
              as int?,
      stageId: stageId == freezed
          ? _value.stageId
          : stageId // ignore: cast_nullable_to_non_nullable
              as String?,
      nextStep: nextStep == freezed
          ? _value.nextStep
          : nextStep // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeUser: employeeUser == freezed
          ? _value.employeeUser
          : employeeUser // ignore: cast_nullable_to_non_nullable
              as User?,
      leadUser: leadUser == freezed
          ? _value.leadUser
          : leadUser // ignore: cast_nullable_to_non_nullable
              as User?,
    ));
  }

  @override
  $UserCopyWith<$Res>? get employeeUser {
    if (_value.employeeUser == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.employeeUser!, (value) {
      return _then(_value.copyWith(employeeUser: value));
    });
  }

  @override
  $UserCopyWith<$Res>? get leadUser {
    if (_value.leadUser == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.leadUser!, (value) {
      return _then(_value.copyWith(leadUser: value));
    });
  }
}

/// @nodoc
abstract class _$OpportunityCopyWith<$Res>
    implements $OpportunityCopyWith<$Res> {
  factory _$OpportunityCopyWith(
          _Opportunity value, $Res Function(_Opportunity) then) =
      __$OpportunityCopyWithImpl<$Res>;
  @override
  $Res call(
      {@DateTimeConverter() DateTime? lastUpdated,
      String? opportunityId,
      String? opportunityName,
      String? description,
      @DecimalConverter() Decimal? estAmount,
      int? estProbability,
      String? stageId,
      String? nextStep,
      User? employeeUser,
      User? leadUser});

  @override
  $UserCopyWith<$Res>? get employeeUser;
  @override
  $UserCopyWith<$Res>? get leadUser;
}

/// @nodoc
class __$OpportunityCopyWithImpl<$Res> extends _$OpportunityCopyWithImpl<$Res>
    implements _$OpportunityCopyWith<$Res> {
  __$OpportunityCopyWithImpl(
      _Opportunity _value, $Res Function(_Opportunity) _then)
      : super(_value, (v) => _then(v as _Opportunity));

  @override
  _Opportunity get _value => super._value as _Opportunity;

  @override
  $Res call({
    Object? lastUpdated = freezed,
    Object? opportunityId = freezed,
    Object? opportunityName = freezed,
    Object? description = freezed,
    Object? estAmount = freezed,
    Object? estProbability = freezed,
    Object? stageId = freezed,
    Object? nextStep = freezed,
    Object? employeeUser = freezed,
    Object? leadUser = freezed,
  }) {
    return _then(_Opportunity(
      lastUpdated: lastUpdated == freezed
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      opportunityId: opportunityId == freezed
          ? _value.opportunityId
          : opportunityId // ignore: cast_nullable_to_non_nullable
              as String?,
      opportunityName: opportunityName == freezed
          ? _value.opportunityName
          : opportunityName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      estAmount: estAmount == freezed
          ? _value.estAmount
          : estAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      estProbability: estProbability == freezed
          ? _value.estProbability
          : estProbability // ignore: cast_nullable_to_non_nullable
              as int?,
      stageId: stageId == freezed
          ? _value.stageId
          : stageId // ignore: cast_nullable_to_non_nullable
              as String?,
      nextStep: nextStep == freezed
          ? _value.nextStep
          : nextStep // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeUser: employeeUser == freezed
          ? _value.employeeUser
          : employeeUser // ignore: cast_nullable_to_non_nullable
              as User?,
      leadUser: leadUser == freezed
          ? _value.leadUser
          : leadUser // ignore: cast_nullable_to_non_nullable
              as User?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Opportunity extends _Opportunity with DiagnosticableTreeMixin {
  _$_Opportunity(
      {@DateTimeConverter() this.lastUpdated,
      this.opportunityId,
      this.opportunityName,
      this.description,
      @DecimalConverter() this.estAmount,
      this.estProbability,
      this.stageId,
      this.nextStep,
      this.employeeUser,
      this.leadUser})
      : super._();

  factory _$_Opportunity.fromJson(Map<String, dynamic> json) =>
      _$$_OpportunityFromJson(json);

  @override
  @DateTimeConverter()
  final DateTime? lastUpdated;
  @override
  final String? opportunityId;
  @override
  final String? opportunityName;
  @override
  final String? description;
  @override
  @DecimalConverter()
  final Decimal? estAmount;
  @override
  final int? estProbability;
  @override
  final String? stageId;
  @override
  final String? nextStep;
  @override
  final User? employeeUser;
  @override
  final User? leadUser;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Opportunity(lastUpdated: $lastUpdated, opportunityId: $opportunityId, opportunityName: $opportunityName, description: $description, estAmount: $estAmount, estProbability: $estProbability, stageId: $stageId, nextStep: $nextStep, employeeUser: $employeeUser, leadUser: $leadUser)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Opportunity'))
      ..add(DiagnosticsProperty('lastUpdated', lastUpdated))
      ..add(DiagnosticsProperty('opportunityId', opportunityId))
      ..add(DiagnosticsProperty('opportunityName', opportunityName))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('estAmount', estAmount))
      ..add(DiagnosticsProperty('estProbability', estProbability))
      ..add(DiagnosticsProperty('stageId', stageId))
      ..add(DiagnosticsProperty('nextStep', nextStep))
      ..add(DiagnosticsProperty('employeeUser', employeeUser))
      ..add(DiagnosticsProperty('leadUser', leadUser));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Opportunity &&
            const DeepCollectionEquality()
                .equals(other.lastUpdated, lastUpdated) &&
            const DeepCollectionEquality()
                .equals(other.opportunityId, opportunityId) &&
            const DeepCollectionEquality()
                .equals(other.opportunityName, opportunityName) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.estAmount, estAmount) &&
            const DeepCollectionEquality()
                .equals(other.estProbability, estProbability) &&
            const DeepCollectionEquality().equals(other.stageId, stageId) &&
            const DeepCollectionEquality().equals(other.nextStep, nextStep) &&
            const DeepCollectionEquality()
                .equals(other.employeeUser, employeeUser) &&
            const DeepCollectionEquality().equals(other.leadUser, leadUser));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(lastUpdated),
      const DeepCollectionEquality().hash(opportunityId),
      const DeepCollectionEquality().hash(opportunityName),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(estAmount),
      const DeepCollectionEquality().hash(estProbability),
      const DeepCollectionEquality().hash(stageId),
      const DeepCollectionEquality().hash(nextStep),
      const DeepCollectionEquality().hash(employeeUser),
      const DeepCollectionEquality().hash(leadUser));

  @JsonKey(ignore: true)
  @override
  _$OpportunityCopyWith<_Opportunity> get copyWith =>
      __$OpportunityCopyWithImpl<_Opportunity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OpportunityToJson(this);
  }
}

abstract class _Opportunity extends Opportunity {
  factory _Opportunity(
      {@DateTimeConverter() DateTime? lastUpdated,
      String? opportunityId,
      String? opportunityName,
      String? description,
      @DecimalConverter() Decimal? estAmount,
      int? estProbability,
      String? stageId,
      String? nextStep,
      User? employeeUser,
      User? leadUser}) = _$_Opportunity;
  _Opportunity._() : super._();

  factory _Opportunity.fromJson(Map<String, dynamic> json) =
      _$_Opportunity.fromJson;

  @override
  @DateTimeConverter()
  DateTime? get lastUpdated;
  @override
  String? get opportunityId;
  @override
  String? get opportunityName;
  @override
  String? get description;
  @override
  @DecimalConverter()
  Decimal? get estAmount;
  @override
  int? get estProbability;
  @override
  String? get stageId;
  @override
  String? get nextStep;
  @override
  User? get employeeUser;
  @override
  User? get leadUser;
  @override
  @JsonKey(ignore: true)
  _$OpportunityCopyWith<_Opportunity> get copyWith =>
      throw _privateConstructorUsedError;
}
