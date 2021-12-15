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
import 'package:core/domains/domains.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/services/jsonConverters.dart';

part 'asset_model.freezed.dart';
part 'asset_model.g.dart';

Asset assetFromJson(String str) => Asset.fromJson(json.decode(str)["asset"]);
String assetToJson(Asset data) =>
    '{"asset":' + json.encode(data.toJson()) + "}";

List<Asset> assetsFromJson(String str) =>
    List<Asset>.from(json.decode(str)["assets"].map((x) => Asset.fromJson(x)));
String assetsToJson(List<Asset> data) =>
    '{"assets":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

@freezed
class Asset with _$Asset {
  Asset._();
  factory Asset({
    @Default("") String assetId,
    String? assetClassId, // room, table etc
    String? assetName, // include room number/name
    String? statusId,
    @DecimalConverter() Decimal? quantityOnHand,
    @DecimalConverter() Decimal? availableToPromise,
    String? parentAssetId,
    @DateTimeConverter() DateTime? receivedDate,
    @DateTimeConverter() DateTime? expectedEndOfLife,
    Product? product,
    Location? location,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}

List<String> assetClassIds = [
  'Hotel Room',
  'Restaurant Table',
  'Restaurant Table Area'
];

List<String> assetStatusValues = ['Available', 'Deactivated', 'In Use'];
