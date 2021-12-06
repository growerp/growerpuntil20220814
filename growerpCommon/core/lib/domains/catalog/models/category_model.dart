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

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/services/jsonConverters.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

Category categoryFromJson(String str) =>
    Category.fromJson(json.decode(str)["category"]);
String categoryToJson(Category data) =>
    '{"category":' + json.encode(data.toJson()) + "}";

List<Category> categoriesFromJson(String str) => List<Category>.from(
    json.decode(str)["categories"].map((x) => Category.fromJson(x)));
String categoriesToJson(List<Category> data) =>
    '{"categories":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

@freezed
class Category with _$Category {
  Category._();
  factory Category({
    @Default("") String categoryId,
    String? categoryName,
    String? description,
    @Uint8ListConverter() Uint8List? image,
    int? nbrOfProducts,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$$_CategoryToJson(this as _$_Category);

  Category fromJson(Map<String, dynamic> json) {
    return Category.fromJson(json);
  }
}
