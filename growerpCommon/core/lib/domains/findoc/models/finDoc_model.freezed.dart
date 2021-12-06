// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'finDoc_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FinDoc _$FinDocFromJson(Map<String, dynamic> json) {
  return _FinDoc.fromJson(json);
}

/// @nodoc
class _$FinDocTearOff {
  const _$FinDocTearOff();

  _FinDoc call(
      {String docType = '',
      bool sales = true,
      String? orderId,
      String? shipmentId,
      String? invoiceId,
      String? paymentId,
      String? transactionId,
      String? statusId,
      @DateTimeConverter() DateTime? creationDate,
      @DateTimeConverter() DateTime? placedDate,
      String? description,
      User? otherUser,
      @DecimalConverter() Decimal? grandTotal,
      String? classificationId,
      List<FinDocItem> items = const []}) {
    return _FinDoc(
      docType: docType,
      sales: sales,
      orderId: orderId,
      shipmentId: shipmentId,
      invoiceId: invoiceId,
      paymentId: paymentId,
      transactionId: transactionId,
      statusId: statusId,
      creationDate: creationDate,
      placedDate: placedDate,
      description: description,
      otherUser: otherUser,
      grandTotal: grandTotal,
      classificationId: classificationId,
      items: items,
    );
  }

  FinDoc fromJson(Map<String, Object?> json) {
    return FinDoc.fromJson(json);
  }
}

/// @nodoc
const $FinDoc = _$FinDocTearOff();

/// @nodoc
mixin _$FinDoc {
  String get docType =>
      throw _privateConstructorUsedError; // invoice, payment etc
  bool get sales => throw _privateConstructorUsedError;
  String? get orderId => throw _privateConstructorUsedError;
  String? get shipmentId => throw _privateConstructorUsedError;
  String? get invoiceId => throw _privateConstructorUsedError;
  String? get paymentId => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  String? get statusId => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get creationDate => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get placedDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  User? get otherUser =>
      throw _privateConstructorUsedError; //a single person responsible for finDoc of a single company
  @DecimalConverter()
  Decimal? get grandTotal => throw _privateConstructorUsedError;
  String? get classificationId =>
      throw _privateConstructorUsedError; // is productStore
  List<FinDocItem> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinDocCopyWith<FinDoc> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinDocCopyWith<$Res> {
  factory $FinDocCopyWith(FinDoc value, $Res Function(FinDoc) then) =
      _$FinDocCopyWithImpl<$Res>;
  $Res call(
      {String docType,
      bool sales,
      String? orderId,
      String? shipmentId,
      String? invoiceId,
      String? paymentId,
      String? transactionId,
      String? statusId,
      @DateTimeConverter() DateTime? creationDate,
      @DateTimeConverter() DateTime? placedDate,
      String? description,
      User? otherUser,
      @DecimalConverter() Decimal? grandTotal,
      String? classificationId,
      List<FinDocItem> items});

  $UserCopyWith<$Res>? get otherUser;
}

/// @nodoc
class _$FinDocCopyWithImpl<$Res> implements $FinDocCopyWith<$Res> {
  _$FinDocCopyWithImpl(this._value, this._then);

  final FinDoc _value;
  // ignore: unused_field
  final $Res Function(FinDoc) _then;

  @override
  $Res call({
    Object? docType = freezed,
    Object? sales = freezed,
    Object? orderId = freezed,
    Object? shipmentId = freezed,
    Object? invoiceId = freezed,
    Object? paymentId = freezed,
    Object? transactionId = freezed,
    Object? statusId = freezed,
    Object? creationDate = freezed,
    Object? placedDate = freezed,
    Object? description = freezed,
    Object? otherUser = freezed,
    Object? grandTotal = freezed,
    Object? classificationId = freezed,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      docType: docType == freezed
          ? _value.docType
          : docType // ignore: cast_nullable_to_non_nullable
              as String,
      sales: sales == freezed
          ? _value.sales
          : sales // ignore: cast_nullable_to_non_nullable
              as bool,
      orderId: orderId == freezed
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      shipmentId: shipmentId == freezed
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceId: invoiceId == freezed
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentId: paymentId == freezed
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: transactionId == freezed
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      statusId: statusId == freezed
          ? _value.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as String?,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      placedDate: placedDate == freezed
          ? _value.placedDate
          : placedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      otherUser: otherUser == freezed
          ? _value.otherUser
          : otherUser // ignore: cast_nullable_to_non_nullable
              as User?,
      grandTotal: grandTotal == freezed
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      classificationId: classificationId == freezed
          ? _value.classificationId
          : classificationId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FinDocItem>,
    ));
  }

  @override
  $UserCopyWith<$Res>? get otherUser {
    if (_value.otherUser == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.otherUser!, (value) {
      return _then(_value.copyWith(otherUser: value));
    });
  }
}

/// @nodoc
abstract class _$FinDocCopyWith<$Res> implements $FinDocCopyWith<$Res> {
  factory _$FinDocCopyWith(_FinDoc value, $Res Function(_FinDoc) then) =
      __$FinDocCopyWithImpl<$Res>;
  @override
  $Res call(
      {String docType,
      bool sales,
      String? orderId,
      String? shipmentId,
      String? invoiceId,
      String? paymentId,
      String? transactionId,
      String? statusId,
      @DateTimeConverter() DateTime? creationDate,
      @DateTimeConverter() DateTime? placedDate,
      String? description,
      User? otherUser,
      @DecimalConverter() Decimal? grandTotal,
      String? classificationId,
      List<FinDocItem> items});

  @override
  $UserCopyWith<$Res>? get otherUser;
}

/// @nodoc
class __$FinDocCopyWithImpl<$Res> extends _$FinDocCopyWithImpl<$Res>
    implements _$FinDocCopyWith<$Res> {
  __$FinDocCopyWithImpl(_FinDoc _value, $Res Function(_FinDoc) _then)
      : super(_value, (v) => _then(v as _FinDoc));

  @override
  _FinDoc get _value => super._value as _FinDoc;

  @override
  $Res call({
    Object? docType = freezed,
    Object? sales = freezed,
    Object? orderId = freezed,
    Object? shipmentId = freezed,
    Object? invoiceId = freezed,
    Object? paymentId = freezed,
    Object? transactionId = freezed,
    Object? statusId = freezed,
    Object? creationDate = freezed,
    Object? placedDate = freezed,
    Object? description = freezed,
    Object? otherUser = freezed,
    Object? grandTotal = freezed,
    Object? classificationId = freezed,
    Object? items = freezed,
  }) {
    return _then(_FinDoc(
      docType: docType == freezed
          ? _value.docType
          : docType // ignore: cast_nullable_to_non_nullable
              as String,
      sales: sales == freezed
          ? _value.sales
          : sales // ignore: cast_nullable_to_non_nullable
              as bool,
      orderId: orderId == freezed
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      shipmentId: shipmentId == freezed
          ? _value.shipmentId
          : shipmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceId: invoiceId == freezed
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentId: paymentId == freezed
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: transactionId == freezed
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      statusId: statusId == freezed
          ? _value.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as String?,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      placedDate: placedDate == freezed
          ? _value.placedDate
          : placedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      otherUser: otherUser == freezed
          ? _value.otherUser
          : otherUser // ignore: cast_nullable_to_non_nullable
              as User?,
      grandTotal: grandTotal == freezed
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      classificationId: classificationId == freezed
          ? _value.classificationId
          : classificationId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FinDocItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FinDoc extends _FinDoc {
  _$_FinDoc(
      {this.docType = '',
      this.sales = true,
      this.orderId,
      this.shipmentId,
      this.invoiceId,
      this.paymentId,
      this.transactionId,
      this.statusId,
      @DateTimeConverter() this.creationDate,
      @DateTimeConverter() this.placedDate,
      this.description,
      this.otherUser,
      @DecimalConverter() this.grandTotal,
      this.classificationId,
      this.items = const []})
      : super._();

  factory _$_FinDoc.fromJson(Map<String, dynamic> json) =>
      _$$_FinDocFromJson(json);

  @JsonKey(defaultValue: '')
  @override
  final String docType;
  @JsonKey(defaultValue: true)
  @override // invoice, payment etc
  final bool sales;
  @override
  final String? orderId;
  @override
  final String? shipmentId;
  @override
  final String? invoiceId;
  @override
  final String? paymentId;
  @override
  final String? transactionId;
  @override
  final String? statusId;
  @override
  @DateTimeConverter()
  final DateTime? creationDate;
  @override
  @DateTimeConverter()
  final DateTime? placedDate;
  @override
  final String? description;
  @override
  final User? otherUser;
  @override //a single person responsible for finDoc of a single company
  @DecimalConverter()
  final Decimal? grandTotal;
  @override
  final String? classificationId;
  @JsonKey(defaultValue: const [])
  @override // is productStore
  final List<FinDocItem> items;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FinDoc &&
            const DeepCollectionEquality().equals(other.docType, docType) &&
            const DeepCollectionEquality().equals(other.sales, sales) &&
            const DeepCollectionEquality().equals(other.orderId, orderId) &&
            const DeepCollectionEquality()
                .equals(other.shipmentId, shipmentId) &&
            const DeepCollectionEquality().equals(other.invoiceId, invoiceId) &&
            const DeepCollectionEquality().equals(other.paymentId, paymentId) &&
            const DeepCollectionEquality()
                .equals(other.transactionId, transactionId) &&
            const DeepCollectionEquality().equals(other.statusId, statusId) &&
            const DeepCollectionEquality()
                .equals(other.creationDate, creationDate) &&
            const DeepCollectionEquality()
                .equals(other.placedDate, placedDate) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.otherUser, otherUser) &&
            const DeepCollectionEquality()
                .equals(other.grandTotal, grandTotal) &&
            const DeepCollectionEquality()
                .equals(other.classificationId, classificationId) &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(docType),
      const DeepCollectionEquality().hash(sales),
      const DeepCollectionEquality().hash(orderId),
      const DeepCollectionEquality().hash(shipmentId),
      const DeepCollectionEquality().hash(invoiceId),
      const DeepCollectionEquality().hash(paymentId),
      const DeepCollectionEquality().hash(transactionId),
      const DeepCollectionEquality().hash(statusId),
      const DeepCollectionEquality().hash(creationDate),
      const DeepCollectionEquality().hash(placedDate),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(otherUser),
      const DeepCollectionEquality().hash(grandTotal),
      const DeepCollectionEquality().hash(classificationId),
      const DeepCollectionEquality().hash(items));

  @JsonKey(ignore: true)
  @override
  _$FinDocCopyWith<_FinDoc> get copyWith =>
      __$FinDocCopyWithImpl<_FinDoc>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FinDocToJson(this);
  }
}

abstract class _FinDoc extends FinDoc {
  factory _FinDoc(
      {String docType,
      bool sales,
      String? orderId,
      String? shipmentId,
      String? invoiceId,
      String? paymentId,
      String? transactionId,
      String? statusId,
      @DateTimeConverter() DateTime? creationDate,
      @DateTimeConverter() DateTime? placedDate,
      String? description,
      User? otherUser,
      @DecimalConverter() Decimal? grandTotal,
      String? classificationId,
      List<FinDocItem> items}) = _$_FinDoc;
  _FinDoc._() : super._();

  factory _FinDoc.fromJson(Map<String, dynamic> json) = _$_FinDoc.fromJson;

  @override
  String get docType;
  @override // invoice, payment etc
  bool get sales;
  @override
  String? get orderId;
  @override
  String? get shipmentId;
  @override
  String? get invoiceId;
  @override
  String? get paymentId;
  @override
  String? get transactionId;
  @override
  String? get statusId;
  @override
  @DateTimeConverter()
  DateTime? get creationDate;
  @override
  @DateTimeConverter()
  DateTime? get placedDate;
  @override
  String? get description;
  @override
  User? get otherUser;
  @override //a single person responsible for finDoc of a single company
  @DecimalConverter()
  Decimal? get grandTotal;
  @override
  String? get classificationId;
  @override // is productStore
  List<FinDocItem> get items;
  @override
  @JsonKey(ignore: true)
  _$FinDocCopyWith<_FinDoc> get copyWith => throw _privateConstructorUsedError;
}
