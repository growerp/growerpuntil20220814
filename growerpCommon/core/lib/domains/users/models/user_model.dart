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

import 'dart:convert';
import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'address_model.dart';
import 'package:core/services/jsonConverters.dart';
import 'package:flutter/foundation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

List<User> usersFromJson(String str) =>
    List<User>.from(json.decode(str)["users"].map((x) => User.fromJson(x)));
String usersToJson(List<User> data) =>
    '{"users":' +
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))) +
    "}";

User userFromJson(String str) => User.fromJson(json.decode(str)["user"]);
String userToJson(User data) => '{"user":' + json.encode(data.toJson()) + "}";

@freezed
class User with _$User {
  User._();
  factory User({
    String? partyId, // allocated by system cannot be changed.
    String? userId, // allocated by system cannot be changed.
    String? firstName,
    String? lastName,
    bool? loginDisabled, // login account is required if disabled just dummy
    String? loginName,
    String? email, // company email address of this person
    String? groupDescription, // admin, employee, customer, supplier etc...
    String? userGroupId,
    String? language,
    String? externalId, // when customer register they give their telno
    @Uint8ListConverter() Uint8List? image,
    String? companyPartyId, // allocated by system cannot be changed.
    String? companyName,
    Address? companyAddress,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  get username => null;

  Map<String, dynamic> toJson() => _$$_UserToJson(this as _$_User);

  User fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}
