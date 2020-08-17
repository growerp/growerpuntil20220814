// To parse this JSON data, do
//
//     final currencyList = currencyListFromJson(jsonString);

import 'dart:convert';

CurrencyList currencyListFromJson(String str) =>
    CurrencyList.fromJson(json.decode(str));

String currencyListToJson(CurrencyList data) => json.encode(data.toJson());

class CurrencyList {
  CurrencyList({
    this.currencyList,
  });

  List<String> currencyList;

  factory CurrencyList.fromJson(Map<String, dynamic> json) => CurrencyList(
        currencyList: List<String>.from(json["currencyList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "currencyList": List<dynamic>.from(currencyList.map((x) => x)),
      };
  String toString() => 'Curencies length ${this.currencyList.length}';
}
