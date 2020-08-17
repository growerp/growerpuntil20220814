// To parse this JSON data, do
//
//     final companies = companiesFromJson(jsonString);

import 'dart:convert';
import 'company.dart';

Companies companiesFromJson(String str) => Companies.fromJson(json.decode(str));

String companiesToJson(Companies data) => json.encode(data.toJson());

class Companies {
  Companies({
    this.companies,
  });

  List<Company> companies;

  factory Companies.fromJson(Map<String, dynamic> json) => Companies(
        companies: List<Company>.from(
            json["companies"].map((x) => Company.fromJson(x))).toList(),
      );

  Map<String, dynamic> toJson() => {
        "companies": List<dynamic>.from(this.companies.map((x) => x.toJson())),
      };
  String toString() =>
      "Companies length ${this.companies.length} first: " +
      "${companies[0]?.name}[${companies[0]?.partyId}";
}
