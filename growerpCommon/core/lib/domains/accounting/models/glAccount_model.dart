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
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'glAccount_model.freezed.dart';
part 'glAccount_model.g.dart';

GlAccount glAccountFromJson(String str) => GlAccount.fromJson(json.decode(str));
String glAccountToJson(GlAccount data) => json.encode(data.toJson());

List<GlAccount> glAccountListFromJson(String str) => List<GlAccount>.from(
    json.decode(str)["glAccountList"].map((x) => GlAccount.fromJson(x)));
String glAccountListToJson(List<GlAccount> data) =>
    '{"glAccountList":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

@freezed
class GlAccount with _$GlAccount {
  GlAccount._();
  factory GlAccount({
    String? id,
    int? l,
    String? classId,
    String? isDebit,
    String? accountName,
    double? postedBalance,
    double? rollUp,
    @Default([]) List<GlAccount> children,
  }) = _GlAccount;

  factory GlAccount.fromJson(Map<String, dynamic> json) =>
      _$GlAccountFromJson(json);

  Map<String, dynamic> toJson() => _$$_GlAccountToJson(this as _$_GlAccount);

  GlAccount fromJson(Map<String, dynamic> json) {
    return GlAccount.fromJson(json);
  }
}
