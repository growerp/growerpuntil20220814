// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category extends Equatable {
  final String productCategoryId;
  final String categoryName;
  final String preparationAreaId;
  final String description;
  final MemoryImage image;

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
      image: json["image"] != null && json["image"].indexOf('data:image') == 0
          ? MemoryImage(base64.decode(json["image"].substring(22)))
          : MemoryImage(base64.decode("R0lGODlhAQABAAAAACw=")));

  Map<String, dynamic> toJson() => {
        "productCategoryId": productCategoryId,
        "categoryName": categoryName,
        "preparationAreaId": preparationAreaId,
        "description": description,
        "image": image.toString(),
      };

  @override
  List get props =>
      [productCategoryId, categoryName, preparationAreaId, description, image];
}
