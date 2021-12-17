import 'dart:convert';
import 'dart:typed_data';
import 'package:core/domains/domains.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class Uint8ListConverter implements JsonConverter<Uint8List?, String?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(String? json) {
    if (json == null) return null;
    return base64.decode(json);
  }

  @override
  String? toJson(Uint8List? object) {
    if (object == null) return null;
    return base64.encode(object);
  }
}

class DecimalConverter implements JsonConverter<Decimal?, String?> {
  const DecimalConverter();

  @override
  Decimal? fromJson(String? json) {
    if (json == null) return null;
    return Decimal.parse(json);
  }

  @override
  String? toJson(Decimal? object) {
    if (object == null) return null;
    return object.toString();
  }
}

class DateTimeConverter implements JsonConverter<DateTime?, String?> {
  const DateTimeConverter();

  @override
  DateTime? fromJson(String? json) {
    if (json == null) return null;
    return DateTime.tryParse(json);
  }

  @override
  String? toJson(DateTime? object) {
    if (object == null) return null;
    return object.toString();
  }
}

class FinDocTypeConverter implements JsonConverter<FinDocType?, String?> {
  const FinDocTypeConverter();

  @override
  FinDocType? fromJson(String? json) {
    if (json == null) return null;
    return FinDocType.tryParse(json);
  }

  @override
  String? toJson(FinDocType? object) {
    if (object == null) return null;
    return object.toString();
  }
}
