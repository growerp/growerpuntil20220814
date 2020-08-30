// To parse this JSON data, do
//
//      category = categoryFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));
String categoryToJson(Category data) => json.encode(data.toJson());

List<Category> categoriesFromJson(String str) => List<Category>.from(
    json.decode(str)["categories"].map((x) => Category.fromJson(x)));
String categoriesToJson(List<Category> data) =>
    '{"categories":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

class Category {
  String productCategoryId;
  String categoryName;
  String preparationAreaId;
  String description;
  Uint8List image;

  Category({
    this.productCategoryId,
    this.categoryName,
    this.preparationAreaId,
    this.description,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        productCategoryId: json["productCategoryId"],
        categoryName: json["categoryName"],
        preparationAreaId: json["preparationAreaId"],
        description: json["description"],
        image: json["image"] != null ? base64.decode(json["image"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "productCategoryId": productCategoryId,
        "categoryName": categoryName,
        "preparationAreaId": preparationAreaId,
        "description": description,
        // image upload separate
      };

  String toString() => 'Category name: $categoryName';
}
