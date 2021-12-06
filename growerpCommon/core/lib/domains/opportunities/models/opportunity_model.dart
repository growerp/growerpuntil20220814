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
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/services/jsonConverters.dart';
import 'package:flutter/foundation.dart';
import 'package:core/domains/domains.dart';

part 'opportunity_model.freezed.dart';
part 'opportunity_model.g.dart';

Opportunity opportunityFromJson(String str) =>
    Opportunity.fromJson(json.decode(str)["opportunity"]);
String opportunityToJson(Opportunity data) =>
    '{"opportunity":' + json.encode(data.toJson()) + "}";

List<Opportunity> opportunitiesFromJson(String str) => List<Opportunity>.from(
    json.decode(str)["opportunities"].map((x) => Opportunity.fromJson(x)));
String opportunitiesToJson(List<Opportunity> data) =>
    '{"opportunities":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

@freezed
class Opportunity with _$Opportunity {
  Opportunity._();
  factory Opportunity({
    @DateTimeConverter() DateTime? lastUpdated,
    String? opportunityId,
    String? opportunityName,
    String? description,
    @DecimalConverter() Decimal? estAmount,
    int? estProbability,
    String? stageId,
    String? nextStep,
    User? employeeUser,
    User? leadUser,
  }) = _Opportunity;

  factory Opportunity.fromJson(Map<String, dynamic> json) =>
      _$OpportunityFromJson(json);

  Map<String, dynamic> toJson() =>
      _$$_OpportunityToJson(this as _$_Opportunity);

  Opportunity fromJson(Map<String, dynamic> json) {
    return Opportunity.fromJson(json);
  }
}
