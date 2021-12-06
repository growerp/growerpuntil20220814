/*
 * This GrowERP software is in the public domain under CC0 1.0 Universal plus a
 * Grant of Patent License.
 * 
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any
 * warranty.
 * 
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software (see the LICENSE.md file). If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

import 'dart:convert';
import 'dart:typed_data';
import 'package:core/domains/common/models/currency_model.dart';
import 'package:decimal/decimal.dart';
import 'address_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/services/jsonConverters.dart';
import 'package:flutter/foundation.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

List<Company> companiesFromJson(String str) => List<Company>.from(
    json.decode(str)["companies"].map((x) => Company.fromJson(x)));
String companiesToJson(List<Company> data) =>
    '{"companies":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

Company companyFromJson(String str) =>
    Company.fromJson(json.decode(str)["company"]);
String companyToJson(Company data) =>
    '{"company":' + json.encode(data.toJson()) + "}";

@freezed
class Company with _$Company {
  Company._();
  factory Company({
    String? partyId,
    String? name,
    String? email,
    Currency? currency,
    @Uint8ListConverter() Uint8List? image,
    Address? address,
    Decimal? vatPerc,
    Decimal? salesPerc,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$$_CompanyToJson(this as _$_Company);

  Company fromJson(Map<String, dynamic> json) {
    return Company.fromJson(json);
  }
}
