// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

Company companyFromJson(String str) =>
    Company.fromJson(json.decode(str)["company"]);
String companyToJson(Company data) =>
    '{"company":' + json.encode(data.toJson()) + "}";

List<Company> companiesFromJson(String str) => List<Company>.from(
    json.decode(str)["companies"].map((x) => Company.fromJson(x)));
String companiesToJson(List<Company> data) =>
    '{"companies":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

class Company {
  String partyId;
  String name;
  String classificationId;
  String classificationDescr;
  String email;
  dynamic currencyId;
  Uint8List image;

  Company({
    this.partyId,
    this.name,
    this.classificationId,
    this.classificationDescr,
    this.email,
    this.currencyId,
    this.image,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        partyId: json["partyId"],
        name: json["name"],
        classificationId: json["classificationId"],
        classificationDescr: json["classificationDescr"],
        email: json["email"],
        currencyId: json["currencyId"],
        image: json["image"] != null ? base64.decode(json["image"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "partyId": partyId,
        "name": name,
        "classificationId": classificationId,
        "classificationDescr": classificationDescr,
        "email": email,
        "currencyId": currencyId,
        "image": image != null ? base64.encode(image) : null,
      };
}
