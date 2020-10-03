import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:master/models/@models.dart';
import '../data.dart';

void main() {
  Dio client;
  String sessionToken;
  String apiKey;
  Map login = Map<dynamic, dynamic>();
  Authenticate authenticate;

  client = Dio();
  client.options.baseUrl = 'http://localhost:8080/rest/';
  client.options.connectTimeout = 20000; //10s
  client.options.receiveTimeout = 40000;
  client.options.headers = {'Content-Type': 'application/json'};
  setUp(() async {
    Response response = await client.get('moquiSessionToken');
    sessionToken = response.data;
  });

  group('Connection test and public api', () {
    test('test connection', () async {
      print("need a local version of Moqui see: README of this project");
      print("=========================================================");
      Response response = await client.get('moquiSessionToken');
      sessionToken = response.data;
      expect(response.data.length, 20);
    });
  });

  group('Register first company, login, upload inmage', () {
    test('register', () async {
      register['moquiSessionToken'] = sessionToken;
      register['username'] = randomString4 + register['emailAddress'];
      register['emailAddress'] = randomString4 + register['emailAddress'];
      dynamic response =
          await client.post('s1/growerp/100/UserAndCompany', data: register);
      Authenticate result = authenticateFromJson(response.toString());
      authenticateNoKey.company.partyId = result.company.partyId;
      authenticateNoKey.user.partyId = result.user.partyId;
      authenticateNoKey.user.name = register['emailAddress'];
      authenticateNoKey.user.email = register['emailAddress'];
      authenticateNoKey.user.image = result.user.image;
      authenticateNoKey.user.userId = result.user.userId;
      authenticateNoKey.company.image = result.company.image;
      authenticateNoKey.company.employees = result.company.employees;
      authenticateNoKey.apiKey = result.apiKey;
      apiKey = result.apiKey;
      // used later for login test
      login.addAll({
        'companyPartyId': result.company.partyId,
        'username': result.user?.name,
        'password': password
      });
      authenticate = authenticateNoKey;
      expect(authenticateToJson(result), authenticateToJson(authenticateNoKey));
    });
    Authenticate loginAuth;

    test('Companies', () async {
      Response response = await client.get('s1/growerp/100/Companies');
      dynamic result = companiesFromJson(response.toString());
      expect(result.length > 0, true);
    });

    test('login', () async {
      dynamic response = await client.post('s1/growerp/100/Login', data: login);
      loginAuth = authenticateFromJson(response.toString());
      authenticate.apiKey = loginAuth.apiKey;
      apiKey = loginAuth.apiKey;
      client.options.headers['api_key'] = loginAuth.apiKey;
      authenticate.moquiSessionToken = loginAuth.moquiSessionToken;
      sessionToken = loginAuth.moquiSessionToken;
      expect(authenticateToJson(loginAuth), authenticateToJson(authenticate));
    });

    test('upload', () async {
      dynamic response = await client.post('s1/growerp/100/Image', data: {
        'type': 'company',
        'id': loginAuth.company.partyId,
        'base64': imageBase64,
        'moquiSessionToken': sessionToken,
      });
      response = await client.get('rest/s1/growerp/100/Company',
          queryParameters: {'partyId': loginAuth.company.partyId});
      loginAuth.company.image = base64.decode(imageBase64);
      expect(companyToJson(loginAuth.company), response.data["company"]);
    });
  });
/*
  group('password reset and update', () {
    test('update password', () async {
      Map updPassword = {
        'username': login['username'],
        'oldPassword': password,
        'newPassword': newPassword,
        'moquiSessionToken': sessionToken,
      };
      dynamic response =
          await client.put('s1/growerp/100/Password', data: updPassword);
      expect(response.data['messages'].substring(0, 16), 'Password updated');
    });
    test('reset password', () async {
      Response response = await client.post('s1/growerp/100/ResetPassword',
          data: {
            'username': login['username'],
            'moquiSessionToken': sessionToken
          });
      expect(response.data['messages'].substring(0, 25),
          'A reset password was sent');
    });
  });
*/
}
