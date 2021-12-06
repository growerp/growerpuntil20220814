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

part 'itemType_model.freezed.dart';
part 'itemType_model.g.dart';

List<ItemType> itemTypesFromJson(String str) => List<ItemType>.from(
    json.decode(str)["itemTypes"].map((x) => ItemType.fromJson(x)));
String itemTypesToJson(List<ItemType> data) =>
    '{"itemTypes":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

@freezed
class ItemType with _$ItemType {
  ItemType._();
  factory ItemType({
    String? itemTypeId,
    String? itemTypeName,
  }) = _ItemType;

  factory ItemType.fromJson(Map<String, dynamic> json) =>
      _$ItemTypeFromJson(json);

  Map<String, dynamic> toJson() => _$$_ItemTypeToJson(this as _$_ItemType);

  ItemType fromJson(Map<String, dynamic> json) {
    return ItemType.fromJson(json);
  }
}
