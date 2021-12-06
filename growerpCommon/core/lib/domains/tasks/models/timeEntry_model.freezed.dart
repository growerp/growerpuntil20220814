// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'timeEntry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) {
  return _TimeEntry.fromJson(json);
}

/// @nodoc
class _$TimeEntryTearOff {
  const _$TimeEntryTearOff();

  _TimeEntry call(
      {String? timeEntryId,
      String? taskId,
      String? partyId,
      @DecimalConverter() Decimal? hours,
      String? comments,
      @DateTimeConverter() DateTime? date}) {
    return _TimeEntry(
      timeEntryId: timeEntryId,
      taskId: taskId,
      partyId: partyId,
      hours: hours,
      comments: comments,
      date: date,
    );
  }

  TimeEntry fromJson(Map<String, Object?> json) {
    return TimeEntry.fromJson(json);
  }
}

/// @nodoc
const $TimeEntry = _$TimeEntryTearOff();

/// @nodoc
mixin _$TimeEntry {
  String? get timeEntryId => throw _privateConstructorUsedError;
  String? get taskId => throw _privateConstructorUsedError;
  String? get partyId => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal? get hours => throw _privateConstructorUsedError;
  String? get comments => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TimeEntryCopyWith<TimeEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeEntryCopyWith<$Res> {
  factory $TimeEntryCopyWith(TimeEntry value, $Res Function(TimeEntry) then) =
      _$TimeEntryCopyWithImpl<$Res>;
  $Res call(
      {String? timeEntryId,
      String? taskId,
      String? partyId,
      @DecimalConverter() Decimal? hours,
      String? comments,
      @DateTimeConverter() DateTime? date});
}

/// @nodoc
class _$TimeEntryCopyWithImpl<$Res> implements $TimeEntryCopyWith<$Res> {
  _$TimeEntryCopyWithImpl(this._value, this._then);

  final TimeEntry _value;
  // ignore: unused_field
  final $Res Function(TimeEntry) _then;

  @override
  $Res call({
    Object? timeEntryId = freezed,
    Object? taskId = freezed,
    Object? partyId = freezed,
    Object? hours = freezed,
    Object? comments = freezed,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      timeEntryId: timeEntryId == freezed
          ? _value.timeEntryId
          : timeEntryId // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: taskId == freezed
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      partyId: partyId == freezed
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String?,
      hours: hours == freezed
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      comments: comments == freezed
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String?,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
abstract class _$TimeEntryCopyWith<$Res> implements $TimeEntryCopyWith<$Res> {
  factory _$TimeEntryCopyWith(
          _TimeEntry value, $Res Function(_TimeEntry) then) =
      __$TimeEntryCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? timeEntryId,
      String? taskId,
      String? partyId,
      @DecimalConverter() Decimal? hours,
      String? comments,
      @DateTimeConverter() DateTime? date});
}

/// @nodoc
class __$TimeEntryCopyWithImpl<$Res> extends _$TimeEntryCopyWithImpl<$Res>
    implements _$TimeEntryCopyWith<$Res> {
  __$TimeEntryCopyWithImpl(_TimeEntry _value, $Res Function(_TimeEntry) _then)
      : super(_value, (v) => _then(v as _TimeEntry));

  @override
  _TimeEntry get _value => super._value as _TimeEntry;

  @override
  $Res call({
    Object? timeEntryId = freezed,
    Object? taskId = freezed,
    Object? partyId = freezed,
    Object? hours = freezed,
    Object? comments = freezed,
    Object? date = freezed,
  }) {
    return _then(_TimeEntry(
      timeEntryId: timeEntryId == freezed
          ? _value.timeEntryId
          : timeEntryId // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: taskId == freezed
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      partyId: partyId == freezed
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String?,
      hours: hours == freezed
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      comments: comments == freezed
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String?,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TimeEntry extends _TimeEntry with DiagnosticableTreeMixin {
  _$_TimeEntry(
      {this.timeEntryId,
      this.taskId,
      this.partyId,
      @DecimalConverter() this.hours,
      this.comments,
      @DateTimeConverter() this.date})
      : super._();

  factory _$_TimeEntry.fromJson(Map<String, dynamic> json) =>
      _$$_TimeEntryFromJson(json);

  @override
  final String? timeEntryId;
  @override
  final String? taskId;
  @override
  final String? partyId;
  @override
  @DecimalConverter()
  final Decimal? hours;
  @override
  final String? comments;
  @override
  @DateTimeConverter()
  final DateTime? date;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TimeEntry(timeEntryId: $timeEntryId, taskId: $taskId, partyId: $partyId, hours: $hours, comments: $comments, date: $date)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TimeEntry'))
      ..add(DiagnosticsProperty('timeEntryId', timeEntryId))
      ..add(DiagnosticsProperty('taskId', taskId))
      ..add(DiagnosticsProperty('partyId', partyId))
      ..add(DiagnosticsProperty('hours', hours))
      ..add(DiagnosticsProperty('comments', comments))
      ..add(DiagnosticsProperty('date', date));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TimeEntry &&
            const DeepCollectionEquality()
                .equals(other.timeEntryId, timeEntryId) &&
            const DeepCollectionEquality().equals(other.taskId, taskId) &&
            const DeepCollectionEquality().equals(other.partyId, partyId) &&
            const DeepCollectionEquality().equals(other.hours, hours) &&
            const DeepCollectionEquality().equals(other.comments, comments) &&
            const DeepCollectionEquality().equals(other.date, date));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(timeEntryId),
      const DeepCollectionEquality().hash(taskId),
      const DeepCollectionEquality().hash(partyId),
      const DeepCollectionEquality().hash(hours),
      const DeepCollectionEquality().hash(comments),
      const DeepCollectionEquality().hash(date));

  @JsonKey(ignore: true)
  @override
  _$TimeEntryCopyWith<_TimeEntry> get copyWith =>
      __$TimeEntryCopyWithImpl<_TimeEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TimeEntryToJson(this);
  }
}

abstract class _TimeEntry extends TimeEntry {
  factory _TimeEntry(
      {String? timeEntryId,
      String? taskId,
      String? partyId,
      @DecimalConverter() Decimal? hours,
      String? comments,
      @DateTimeConverter() DateTime? date}) = _$_TimeEntry;
  _TimeEntry._() : super._();

  factory _TimeEntry.fromJson(Map<String, dynamic> json) =
      _$_TimeEntry.fromJson;

  @override
  String? get timeEntryId;
  @override
  String? get taskId;
  @override
  String? get partyId;
  @override
  @DecimalConverter()
  Decimal? get hours;
  @override
  String? get comments;
  @override
  @DateTimeConverter()
  DateTime? get date;
  @override
  @JsonKey(ignore: true)
  _$TimeEntryCopyWith<_TimeEntry> get copyWith =>
      throw _privateConstructorUsedError;
}
