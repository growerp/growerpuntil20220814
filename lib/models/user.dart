// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String partyId;
  String userId;
  String firstName;
  String lastName;
  String name;
  String email;
  String groupDescription;
  List<String> roles;
  String userGroupId;
  dynamic locale;
  dynamic externalId;
  String image;

  User({
    this.partyId,
    this.userId,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.groupDescription,
    this.roles,
    this.userGroupId,
    this.locale,
    this.externalId,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        partyId: json["partyId"],
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        name: json["name"],
        email: json["email"],
        groupDescription: json["groupDescription"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        userGroupId: json["userGroupId"],
        locale: json["locale"],
        externalId: json["externalId"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "partyId": partyId,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "name": name,
        "email": email,
        "groupDescription": groupDescription,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "userGroupId": userGroupId,
        "locale": locale,
        "externalId": externalId,
        "image": image,
      };
}
