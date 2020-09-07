// To parse this JSON data, do
//
//      currency = currencyFromJson(jsonString);

import 'dart:convert';

Currency currencyFromJson(String str) =>
    Currency.fromJson(json.decode(str)["currency"]);
String currencyToJson(Currency data) =>
    '{"currency":' + json.encode(data.toJson()) + "}";

List<Currency> currenciesFromJson(String str) => List<Currency>.from(
    json.decode(str)["currencies"].map((x) => Currency.fromJson(x)));
String currenciesToJson(List<Currency> data) =>
    '{"currencies":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

class Currency {
  String currencyId;
  String description;

  Currency({
    this.currencyId,
    this.description,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        currencyId: json["currencyId"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "currencyId": currencyId,
        "description": description,
      };

  @override
  String toString() => 'Currency name: $description [$currencyId]';
}

List<Currency> currencies = [
  Currency(currencyId: 'EUR', description: 'European Euro'),
  Currency(currencyId: 'USD', description: 'United States Dollar'),
  Currency(currencyId: 'THB', description: 'Thailand Baht')
];
