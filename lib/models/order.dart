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
//     final order = orderFromJson(jsonString);

import 'dart:convert';
import 'package:decimal/decimal.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str)["order"]);
String orderToJson(Order data) => '{"order:' + json.encode(data.toJson()) + "}";

List<Order> ordersFromJson(String str) =>
    List<Order>.from(json.decode(str)["orders"].map((x) => Order.fromJson(x)));
String ordersToJson(List<Order> data) =>
    '{"orders":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

class Order {
  String orderId;
  String orderStatusId;
  String currencyId;
  String placedDate;
  String placedTime;
  String companyPartyId;
  String partyId;
  String firstName;
  String lastName;
  String statusId;
  Decimal grandTotal;
  String table;
  String accommodationAreaId;
  String accommodationSpotId;
  List<OrderItem> orderItems;

  Order({
    this.orderId,
    this.orderStatusId, // 'OrderOpen','OrderPlaced','OrderApproved', 'OrderCompleted', 'OrderCancelled'
    this.currencyId,
    this.placedDate,
    this.placedTime,
    this.companyPartyId,
    this.partyId,
    this.firstName,
    this.lastName,
    this.statusId, // 'Open' or 'Closed' for easy selection
    this.grandTotal,
    this.table,
    this.accommodationAreaId,
    this.accommodationSpotId,
    this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderId"],
        orderStatusId: json["orderStatusId"],
        currencyId: json["currencyUomId"],
        placedDate: json["placedDate"],
        placedTime: json["placedTime"],
        companyPartyId: json["companyPartyId"],
        partyId: json["partyId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        statusId: json["statusId"],
        grandTotal: Decimal.parse(json["grandTotal"]),
        accommodationAreaId: json["accommodationAreaId"],
        accommodationSpotId: json["accommodationSpotId"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderStatusId": orderStatusId,
        "currencyUomId": currencyId,
        "placedDate": placedDate,
        "placedTime": placedTime,
        "companyPartyId": companyPartyId,
        "partyId": partyId,
        "firstName": firstName,
        "lastName": lastName,
        "statusId": statusId,
        "grandTotal": grandTotal,
        "table": table,
        "accommodationAreaId": accommodationAreaId,
        "accommodationSpotId": accommodationSpotId,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class OrderItem {
  OrderItem({
    this.orderItemSeqId,
    this.productId,
    this.description,
    this.quantity,
    this.price,
  });

  String orderItemSeqId;
  String productId;
  String description;
  Decimal quantity;
  Decimal price;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
      orderItemSeqId: json["orderItemSeqId"],
      productId: json["productId"],
      description: json["description"],
      quantity: Decimal.parse(json["quantity"]),
      price: Decimal.parse(json["price"]));

  Map<String, dynamic> toJson() => {
        "orderItemSeqId": orderItemSeqId,
        "productId": productId,
        "description": description,
        "quantity": quantity.toString(),
        "price": price.toString()
      };
}
