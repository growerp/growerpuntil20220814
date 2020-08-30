// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));
String orderToJson(Order data) => json.encode(data.toJson());

List<Order> ordersFromJson(String str) =>
    List<Order>.from(json.decode(str)["orders"].map((x) => Order.fromJson(x)));
String ordersToJson(List<Order> data) =>
    '{"orders":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

class Order {
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
  double grandTotal;
  String table;
  String accommodationAreaId;
  String accommodationSpotId;
  List<OrderItem> orderItems;

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
        grandTotal: double.parse(json["grandTotal"]),
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
  int quantity;
  double price;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
      orderItemSeqId: json["orderItemSeqId"],
      productId: json["productId"],
      description: json["description"],
      quantity: int.parse(json["quantity"]),
      price: double.parse(json["price"]));

  Map<String, dynamic> toJson() => {
        "orderItemSeqId": orderItemSeqId,
        "productId": productId,
        "description": description,
        "quantity": quantity.toString(),
        "price": price.toString()
      };
}
