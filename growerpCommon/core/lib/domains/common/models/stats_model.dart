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

part 'stats_model.freezed.dart';
part 'stats_model.g.dart';

Stats statsFromJson(String str) => Stats.fromJson(json.decode(str)["stats"]);
String statsToJson(Stats data) =>
    '{"stats":' + json.encode(data.toJson()) + "}";

@freezed
class Stats with _$Stats {
  Stats._();
  factory Stats({
    @Default(0) int admins,
    @Default(0) int employees,
    @Default(0) int suppliers,
    @Default(0) int leads,
    @Default(0) int customers,
    @Default(0) int openSlsOrders,
    @Default(0) int openPurOrders,
    @Default(0) int opportunities,
    @Default(0) int myOpportunities,
    @Default(0) int categories,
    @Default(0) int products,
    @Default(0) int assets,
    @Default(0) int salesInvoicesNotPaidCount,
    @DecimalConverter() Decimal? salesInvoicesNotPaidAmount,
    @Default(0) int purchInvoicesNotPaidCount,
    @DecimalConverter() Decimal? purchInvoicesNotPaidAmount,
    @Default(0) int allTasks,
    @Default(0) int notInvoicedHours,
    @Default(0) int incomingShipments,
    @Default(0) int outgoingShipments,
    @Default(0) int whLocations,
  }) = _Stats;

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$$_StatsToJson(this as _$_Stats);

  Stats fromJson(Map<String, dynamic> json) {
    return Stats.fromJson(json);
  }
}
