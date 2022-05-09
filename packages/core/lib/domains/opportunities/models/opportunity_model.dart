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

import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/services/jsonConverters.dart';
import 'package:flutter/foundation.dart';
import 'package:core/domains/domains.dart';

part 'opportunity_model.freezed.dart';
part 'opportunity_model.g.dart';

@freezed
class Opportunity with _$Opportunity {
  Opportunity._();
  factory Opportunity({
    @DateTimeConverter() DateTime? lastUpdated,
    @Default("") String opportunityId,
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
}
