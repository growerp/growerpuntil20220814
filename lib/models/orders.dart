// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';
import 'order.dart';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders {
  Orders({
    this.orders,
  });

  List<Order> orders;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}
