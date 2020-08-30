// To parse this JSON data, do
//
//     final catalog = catalogFromJson(jsonString);

import '@models.dart';
import 'dart:convert';

Catalog catalogFromJson(String str) =>
    Catalog.fromJson(json.decode(str)["catalog"]);

String catalogToJson(Catalog data) =>
    '{"catalog":' + json.encode(data.toJson()) + "}";

class Catalog {
  List<Category> categories;
  List<Product> products;

  Catalog({
    this.categories,
    this.products,
  });

  Category getByCategoryId(String id) =>
      categories.firstWhere((element) => element.productCategoryId == id);
  Category getByCategoryPosition(int position) => categories[position % 2];

  Product getByProductId(String id) =>
      products.firstWhere((element) => element.productId == id);
  Product getByProductPosition(int position) => products[position % 2];

  factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}
