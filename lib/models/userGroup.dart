// To parse this JSON data, do
//
//      userGroup = userGroupFromJson(jsonString);

import 'dart:convert';

UserGroup userGroupFromJson(String str) =>
    UserGroup.fromJson(json.decode(str)["userGroup"]);
String userGroupToJson(UserGroup data) =>
    '{"userGroup":' + json.encode(data.toJson()) + "}";

List<UserGroup> userGroupsFromJson(String str) => List<UserGroup>.from(
    json.decode(str)["userGroups"].map((x) => UserGroup.fromJson(x)));
String userGroupsToJson(List<UserGroup> data) =>
    '{"userGroups":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

class UserGroup {
  String userGroupId;
  String description;

  UserGroup({
    this.userGroupId,
    this.description,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) => UserGroup(
        userGroupId: json["userGroupId"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "userGroupId": userGroupId,
        "description": description,
      };

  @override
  String toString() => 'UserGroup name: $description [$userGroupId]';
}

List<UserGroup> userGroups = [
  UserGroup(userGroupId: 'GROWERP_M_ADMIN', description: 'Admin'),
  UserGroup(userGroupId: 'GROWERP_M_CUSTOMER', description: 'Customer'),
  UserGroup(userGroupId: 'GROWERP_M_EMPLOYEE', description: 'Employee')
];
