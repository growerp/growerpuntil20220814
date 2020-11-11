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

// To parse this JSON data, do
//
//      product = productFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

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

class Product {
  String productId;
  String name;
  String description;
  double price;
  String categoryId;
  Uint8List image;

  Product({
    this.productId,
    this.name,
    this.description,
    this.price,
    this.categoryId,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        name: json["name"],
        description: json["description"],
        price: double.parse(json["price"]),
        categoryId: json["categoryId"],
        image: json["image"] != null ? base64.decode(json["image"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "name": name,
        "description": description,
        "price": price.toString(),
        "categoryId": categoryId,
        "image": image != null ? base64.encode(image) : null,
      };

  String toString() => 'Product name: $name categoryId: $categoryId';
}
