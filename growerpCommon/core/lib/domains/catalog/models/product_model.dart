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
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/services/jsonConverters.dart';
import 'package:core/domains/domains.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

Product productFromJson(String str) =>
    Product.fromJson(json.decode(str)["product"]);
String productToJson(Product data) =>
    '{"product":' + json.encode(data.toJson()) + "}";

List<Product> productsFromJson(String str) => List<Product>.from(
    json.decode(str)["products"].map((x) => Product.fromJson(x)));
String productsToJson(List<Product> data) =>
    '{"products":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

@freezed
class Product with _$Product {
  Product._();
  factory Product({
    @Default("") String productId,
    @Default("") String pseudoId,
    String? productTypeId, // assetUse(rental)
    String? assetClassId, // room, restaurant table
    String? productName,
    String? description,
    @DecimalConverter() Decimal? price,
    Category? category,
    @Default(false) bool useWarehouse,
    int? assetCount,
    @Uint8ListConverter() Uint8List? image,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$$_ProductToJson(this as _$_Product);

  Product fromJson(Map<String, dynamic> json) {
    return Product.fromJson(json);
  }
}

List<String> productTypes = ['Physical Good', 'Service', 'Rental'];
