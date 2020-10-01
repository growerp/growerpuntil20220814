import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:master/models/@models.dart';
import '../data.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    HttpClient client = super.createHttpClient(context); //<<--- notice 'super'
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  Dio client;
  String apiKey;
  Map login = Map<dynamic, dynamic>();
  Authenticate authenticate;

  client = Dio();

  client.options.baseUrl = 'https://localhost:8443/rest/';
  client.options.connectTimeout = 10000; //10s
  client.options.receiveTimeout = 20000;
  client.options.headers = {'Content-Type': 'application/json'};
  print("need a local trunk version of OFBiz with REST and Growerp plugin");
  print("=========================================================");

/*  client.interceptors
      .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
    print('===Outgoing dio request path: ${options.path}');
    print('===Outgoing dio request headers: ${options.headers}');
    print('===Outgoing dio request data: ${options.data}');
    print('===Outgoing dio request method: ${options.method}');
    // Do something before request is sent
    return options; //continue
    // If you want to resolve the request with some custom data，
    // you can return a `Response` object or return `dio.resolve(data)`.
    // If you want to reject the request with a error message,
    // you can return a `DioError` object or return `dio.reject(errMsg)`
  }, onResponse: (Response response) async {
    // Do something with response data
    print("===incoming response: ${response.toString()}");
    return response; // continue
  }, onError: (DioError e) async {
    // Do something with response error
    print("error: $e");
    return e; //continue
  }));
*/
  String getResponseData(Response input) {
    Map jsonData = json.decode(input.toString()) as Map;
    return json.encode(jsonData["data"]);
  }

  group('Register first company', () {
    test('register', () async {
      dynamic response = await client.post('services/registerUserAndCompany',
          data: jsonEncode({
            "companyName": companyName,
            "currencyId": currencyId,
            "firstName": firstName,
            "lastName": lastName,
            "classificationId": classificationId,
            "emailAddress": randomString4 + "dummy@example.com",
            "companyEmail": randomString4 + "1dummy@example.com",
            "username": randomString4 + "dummy@example.com",
            "userGroupId": 'GROWERP_M_ADMIN'
          }));
      Authenticate result = authenticateFromJson(getResponseData(response));
      authenticateNoKey.company.partyId = result.company.partyId;
      authenticateNoKey.user.partyId = result.user?.partyId;
      authenticateNoKey.user.email = result.user?.email;
      authenticateNoKey.user.name = result.user?.name;
      authenticateNoKey.company.email = result.company?.email;
      authenticateNoKey.company.image = null;
      authenticateNoKey.company.employees = result.company.employees;
      authenticateNoKey.user.image = null;
      authenticateNoKey.user.groupDescription = result.user.groupDescription;
      login.addAll({
        'companyPartyId': result.company.partyId,
        'username': result.user?.name,
        'password': password
      });
      authenticate = authenticateNoKey;
      expect(authenticateToJson(result), authenticateToJson(authenticateNoKey));
    });
  });

  test('get companies no auth', () async {
    Response response = await client.get('services/getCompanies?inParams=' +
        Uri.encodeComponent('{"classificationId":"$classificationId"}'));
    dynamic result = companiesFromJson(getResponseData(response));
    //expect(companies, companiesFromJson(result));
  });

  test(' get token', () async {
    String username = 'admin';
    String password = 'ofbiz';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    client.options.headers["Authorization"] = basicAuth;
    Response response = await client.post('auth/token');
    Map jsonData = json.decode(response.toString()) as Map;
    String token = jsonData["data"]["access_token"];

    client.options.headers["Authorization"] = 'Bearer ' + token;

    expect(jsonData["statusCode"], 200);
  });

/*    group('Check companies and login:', () {
      test('Companies', () async {
        Response response = await client.get('s1/growerp/100/Companies');
        dynamic result = companiesFromJson(response.toString());
        expect(result.length > 0, true);
      });

      test('login', () async {
        dynamic response =
            await client.post('s1/growerp/100/Login', data: login);
        Authenticate loginAuth = authenticateFromJson(response.toString());
        authenticate.apiKey = loginAuth.apiKey;
        apiKey = loginAuth.apiKey;
        authenticate.moquiSessionToken = loginAuth.moquiSessionToken;
        sessionToken = loginAuth.moquiSessionToken;
        expect(authenticateToJson(loginAuth), authenticateToJson(authenticate));
      });
    });

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
