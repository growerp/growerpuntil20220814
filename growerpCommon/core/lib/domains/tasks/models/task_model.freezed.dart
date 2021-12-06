// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
class _$TaskTearOff {
  const _$TaskTearOff();

  _Task call(
      {String? taskId,
      String? parentTaskId,
      String? status,
      String? taskName,
      String? description,
      User? customerUser,
      User? vendorUser,
      User? employeeUser,
      @DecimalConverter() Decimal? rate,
      @DateTimeConverter() DateTime? startDate,
      @DateTimeConverter() DateTime? endDate,
      @DecimalConverter() Decimal? unInvoicedHours,
      List<TimeEntry> timeEntries = const []}) {
    return _Task(
      taskId: taskId,
      parentTaskId: parentTaskId,
      status: status,
      taskName: taskName,
      description: description,
      customerUser: customerUser,
      vendorUser: vendorUser,
      employeeUser: employeeUser,
      rate: rate,
      startDate: startDate,
      endDate: endDate,
      unInvoicedHours: unInvoicedHours,
      timeEntries: timeEntries,
    );
  }

  Task fromJson(Map<String, Object?> json) {
    return Task.fromJson(json);
  }
}

/// @nodoc
const $Task = _$TaskTearOff();

/// @nodoc
mixin _$Task {
  String? get taskId => throw _privateConstructorUsedError;
  String? get parentTaskId => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get taskName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  User? get customerUser => throw _privateConstructorUsedError;
  User? get vendorUser => throw _privateConstructorUsedError;
  User? get employeeUser => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal? get rate => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get startDate => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get endDate => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal? get unInvoicedHours => throw _privateConstructorUsedError;
  List<TimeEntry> get timeEntries => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res>;
  $Res call(
      {String? taskId,
      String? parentTaskId,
      String? status,
      String? taskName,
      String? description,
      User? customerUser,
      User? vendorUser,
      User? employeeUser,
      @DecimalConverter() Decimal? rate,
      @DateTimeConverter() DateTime? startDate,
      @DateTimeConverter() DateTime? endDate,
      @DecimalConverter() Decimal? unInvoicedHours,
      List<TimeEntry> timeEntries});

  $UserCopyWith<$Res>? get customerUser;
  $UserCopyWith<$Res>? get vendorUser;
  $UserCopyWith<$Res>? get employeeUser;
}

/// @nodoc
class _$TaskCopyWithImpl<$Res> implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  final Task _value;
  // ignore: unused_field
  final $Res Function(Task) _then;

  @override
  $Res call({
    Object? taskId = freezed,
    Object? parentTaskId = freezed,
    Object? status = freezed,
    Object? taskName = freezed,
    Object? description = freezed,
    Object? customerUser = freezed,
    Object? vendorUser = freezed,
    Object? employeeUser = freezed,
    Object? rate = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? unInvoicedHours = freezed,
    Object? timeEntries = freezed,
  }) {
    return _then(_value.copyWith(
      taskId: taskId == freezed
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentTaskId: parentTaskId == freezed
          ? _value.parentTaskId
          : parentTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      taskName: taskName == freezed
          ? _value.taskName
          : taskName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      customerUser: customerUser == freezed
          ? _value.customerUser
          : customerUser // ignore: cast_nullable_to_non_nullable
              as User?,
      vendorUser: vendorUser == freezed
          ? _value.vendorUser
          : vendorUser // ignore: cast_nullable_to_non_nullable
              as User?,
      employeeUser: employeeUser == freezed
          ? _value.employeeUser
          : employeeUser // ignore: cast_nullable_to_non_nullable
              as User?,
      rate: rate == freezed
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      startDate: startDate == freezed
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: endDate == freezed
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unInvoicedHours: unInvoicedHours == freezed
          ? _value.unInvoicedHours
          : unInvoicedHours // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      timeEntries: timeEntries == freezed
          ? _value.timeEntries
          : timeEntries // ignore: cast_nullable_to_non_nullable
              as List<TimeEntry>,
    ));
  }

  @override
  $UserCopyWith<$Res>? get customerUser {
    if (_value.customerUser == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.customerUser!, (value) {
      return _then(_value.copyWith(customerUser: value));
    });
  }

  @override
  $UserCopyWith<$Res>? get vendorUser {
    if (_value.vendorUser == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.vendorUser!, (value) {
      return _then(_value.copyWith(vendorUser: value));
    });
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
}

/// @nodoc
abstract class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) then) =
      __$TaskCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? taskId,
      String? parentTaskId,
      String? status,
      String? taskName,
      String? description,
      User? customerUser,
      User? vendorUser,
      User? employeeUser,
      @DecimalConverter() Decimal? rate,
      @DateTimeConverter() DateTime? startDate,
      @DateTimeConverter() DateTime? endDate,
      @DecimalConverter() Decimal? unInvoicedHours,
      List<TimeEntry> timeEntries});

  @override
  $UserCopyWith<$Res>? get customerUser;
  @override
  $UserCopyWith<$Res>? get vendorUser;
  @override
  $UserCopyWith<$Res>? get employeeUser;
}

/// @nodoc
class __$TaskCopyWithImpl<$Res> extends _$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(_Task _value, $Res Function(_Task) _then)
      : super(_value, (v) => _then(v as _Task));

  @override
  _Task get _value => super._value as _Task;

  @override
  $Res call({
    Object? taskId = freezed,
    Object? parentTaskId = freezed,
    Object? status = freezed,
    Object? taskName = freezed,
    Object? description = freezed,
    Object? customerUser = freezed,
    Object? vendorUser = freezed,
    Object? employeeUser = freezed,
    Object? rate = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? unInvoicedHours = freezed,
    Object? timeEntries = freezed,
  }) {
    return _then(_Task(
      taskId: taskId == freezed
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentTaskId: parentTaskId == freezed
          ? _value.parentTaskId
          : parentTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      taskName: taskName == freezed
          ? _value.taskName
          : taskName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      customerUser: customerUser == freezed
          ? _value.customerUser
          : customerUser // ignore: cast_nullable_to_non_nullable
              as User?,
      vendorUser: vendorUser == freezed
          ? _value.vendorUser
          : vendorUser // ignore: cast_nullable_to_non_nullable
              as User?,
      employeeUser: employeeUser == freezed
          ? _value.employeeUser
          : employeeUser // ignore: cast_nullable_to_non_nullable
              as User?,
      rate: rate == freezed
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      startDate: startDate == freezed
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: endDate == freezed
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unInvoicedHours: unInvoicedHours == freezed
          ? _value.unInvoicedHours
          : unInvoicedHours // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      timeEntries: timeEntries == freezed
          ? _value.timeEntries
          : timeEntries // ignore: cast_nullable_to_non_nullable
              as List<TimeEntry>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Task extends _Task with DiagnosticableTreeMixin {
  _$_Task(
      {this.taskId,
      this.parentTaskId,
      this.status,
      this.taskName,
      this.description,
      this.customerUser,
      this.vendorUser,
      this.employeeUser,
      @DecimalConverter() this.rate,
      @DateTimeConverter() this.startDate,
      @DateTimeConverter() this.endDate,
      @DecimalConverter() this.unInvoicedHours,
      this.timeEntries = const []})
      : super._();

  factory _$_Task.fromJson(Map<String, dynamic> json) => _$$_TaskFromJson(json);

  @override
  final String? taskId;
  @override
  final String? parentTaskId;
  @override
  final String? status;
  @override
  final String? taskName;
  @override
  final String? description;
  @override
  final User? customerUser;
  @override
  final User? vendorUser;
  @override
  final User? employeeUser;
  @override
  @DecimalConverter()
  final Decimal? rate;
  @override
  @DateTimeConverter()
  final DateTime? startDate;
  @override
  @DateTimeConverter()
  final DateTime? endDate;
  @override
  @DecimalConverter()
  final Decimal? unInvoicedHours;
  @JsonKey(defaultValue: const [])
  @override
  final List<TimeEntry> timeEntries;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Task(taskId: $taskId, parentTaskId: $parentTaskId, status: $status, taskName: $taskName, description: $description, customerUser: $customerUser, vendorUser: $vendorUser, employeeUser: $employeeUser, rate: $rate, startDate: $startDate, endDate: $endDate, unInvoicedHours: $unInvoicedHours, timeEntries: $timeEntries)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Task'))
      ..add(DiagnosticsProperty('taskId', taskId))
      ..add(DiagnosticsProperty('parentTaskId', parentTaskId))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('taskName', taskName))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('customerUser', customerUser))
      ..add(DiagnosticsProperty('vendorUser', vendorUser))
      ..add(DiagnosticsProperty('employeeUser', employeeUser))
      ..add(DiagnosticsProperty('rate', rate))
      ..add(DiagnosticsProperty('startDate', startDate))
      ..add(DiagnosticsProperty('endDate', endDate))
      ..add(DiagnosticsProperty('unInvoicedHours', unInvoicedHours))
      ..add(DiagnosticsProperty('timeEntries', timeEntries));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Task &&
            const DeepCollectionEquality().equals(other.taskId, taskId) &&
            const DeepCollectionEquality()
                .equals(other.parentTaskId, parentTaskId) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.taskName, taskName) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality()
                .equals(other.customerUser, customerUser) &&
            const DeepCollectionEquality()
                .equals(other.vendorUser, vendorUser) &&
            const DeepCollectionEquality()
                .equals(other.employeeUser, employeeUser) &&
            const DeepCollectionEquality().equals(other.rate, rate) &&
            const DeepCollectionEquality().equals(other.startDate, startDate) &&
            const DeepCollectionEquality().equals(other.endDate, endDate) &&
            const DeepCollectionEquality()
                .equals(other.unInvoicedHours, unInvoicedHours) &&
            const DeepCollectionEquality()
                .equals(other.timeEntries, timeEntries));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(taskId),
      const DeepCollectionEquality().hash(parentTaskId),
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(taskName),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(customerUser),
      const DeepCollectionEquality().hash(vendorUser),
      const DeepCollectionEquality().hash(employeeUser),
      const DeepCollectionEquality().hash(rate),
      const DeepCollectionEquality().hash(startDate),
      const DeepCollectionEquality().hash(endDate),
      const DeepCollectionEquality().hash(unInvoicedHours),
      const DeepCollectionEquality().hash(timeEntries));

  @JsonKey(ignore: true)
  @override
  _$TaskCopyWith<_Task> get copyWith =>
      __$TaskCopyWithImpl<_Task>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TaskToJson(this);
  }
}

abstract class _Task extends Task {
  factory _Task(
      {String? taskId,
      String? parentTaskId,
      String? status,
      String? taskName,
      String? description,
      User? customerUser,
      User? vendorUser,
      User? employeeUser,
      @DecimalConverter() Decimal? rate,
      @DateTimeConverter() DateTime? startDate,
      @DateTimeConverter() DateTime? endDate,
      @DecimalConverter() Decimal? unInvoicedHours,
      List<TimeEntry> timeEntries}) = _$_Task;
  _Task._() : super._();

  factory _Task.fromJson(Map<String, dynamic> json) = _$_Task.fromJson;

  @override
  String? get taskId;
  @override
  String? get parentTaskId;
  @override
  String? get status;
  @override
  String? get taskName;
  @override
  String? get description;
  @override
  User? get customerUser;
  @override
  User? get vendorUser;
  @override
  User? get employeeUser;
  @override
  @DecimalConverter()
  Decimal? get rate;
  @override
  @DateTimeConverter()
  DateTime? get startDate;
  @override
  @DateTimeConverter()
  DateTime? get endDate;
  @override
  @DecimalConverter()
  Decimal? get unInvoicedHours;
  @override
  List<TimeEntry> get timeEntries;
  @override
  @JsonKey(ignore: true)
  _$TaskCopyWith<_Task> get copyWith => throw _privateConstructorUsedError;
}
