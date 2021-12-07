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
import 'package:core/domains/domains.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

Location locationFromJson(String str) =>
    Location.fromJson(json.decode(str)["location"]);
String locationToJson(Location data) =>
    '{"location":' + json.encode(data.toJson()) + "}";

List<Location> locationsFromJson(String str) => List<Location>.from(
    json.decode(str)["locations"].map((x) => Location.fromJson(x)));
String locationsToJson(List<Location> data) =>
    '{"locations":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

// backend relation: product -> location -> locationReservation -> orderItem

@freezed
class Location with _$Location {
  Location._();
  factory Location({
    final String? locationId,
    final String? locationName,
    final List<Asset>? assets,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$$_LocationToJson(this as _$_Location);

  Location fromJson(Map<String, dynamic> json) {
    return Location.fromJson(json);
  }
}