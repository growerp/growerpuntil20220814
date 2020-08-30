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
  String productCategoryId;
  Uint8List image;

  Product({
    this.productId,
    this.name,
    this.description,
    this.price,
    this.productCategoryId,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        name: json["name"],
        description: json["description"],
        price: double.parse(json["price"]),
        productCategoryId: json["productCategoryId"],
        image: json["image"] != null ? base64.decode(json["image"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "name": name,
        "description": description,
        "price": price.toString(),
        "productCategoryId": productCategoryId,
        "image": image != null ? base64.encode(image) : null,
      };

  @override
  String toString() => 'Product name: $name';
}
