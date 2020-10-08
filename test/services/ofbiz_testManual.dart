import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin/models/@models.dart';
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
  Authenticate authenticate;
  String username = randomString4 + emailAddress;
  String password = "qqqqqq9!";

  client = Dio();

  client.options.baseUrl = 'https://localhost:8443/rest/';
  client.options.connectTimeout = 20000; //10s
  client.options.receiveTimeout = 40000;
  client.options.headers = {'Content-Type': 'application/json'};
  print("need a local trunk version of OFBiz with REST and Growerp plugin");
  print("=========================================================");
/*
  client.interceptors
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
    if (e.response != null) {
      print("=== e.response.data: ${e.response.data}");
      print("=== e.response.headers: ${e.response.headers}");
      print("=== e.response.request: ${e.response.request}");
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print("=== e.request: ${e.request}");
      print("=== e.message: ${e.message}");
    }
    return e; //continue
  }));
*/
  String getResponseData(Response input) {
    Map jsonData = json.decode(input.toString()) as Map;
    return json.encode(jsonData["data"]);
  }

  setUpAll(() async {
    // register new company, user and login
    try {
      return client.post('services/registerUserAndCompany100',
          data: jsonEncode({
            "companyName": companyName,
            "currencyId": currencyId,
            "firstName": firstName,
            "lastName": lastName,
            "classificationId": classificationId,
            "emailAddress": emailAddress,
            "companyEmail": emailAddress,
            "username": username,
            "userGroupId": 'GROWERP_M_ADMIN',
            "password": password,
            "passwordVerify": password,
          }));
    } catch (e) {
      print("==catch e======${e.response}");
    }
  });

  group('Public tests>>>>', () {
    test('get companies no auth', () async {
      dynamic result;
      try {
        Response response = await client.get(
            'services/getCompanies100?inParams=' +
                Uri.encodeComponent(
                    '{"classificationId": "$classificationId" }'));
        result = companiesFromJson(getResponseData(response));
        print("number of companies: ${result != null ? result?.length : 0}");
      } catch (e) {
        print("catch ${e.toString()}");
      }
      expect(result.length, greaterThan(0));
    });

    test('login', () async {
      // get token
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      client.options.headers["Authorization"] = basicAuth;
      Response response = await client.post('auth/token');
      Map jsonData = json.decode(response.toString()) as Map;
      String token = jsonData["data"]["access_token"];

      client.options.headers["Authorization"] = 'Bearer ' + token;

      expect(jsonData["statusCode"], 200);

      // get company and user data using token
      response = await client.get('services/getAuthenticate100');
      authenticate = authenticateFromJson(getResponseData(response));
      authenticateNoKey.company.partyId = authenticate.company.partyId;
      authenticateNoKey.user.partyId = authenticate.user?.partyId;
      authenticateNoKey.company.image = null;
      authenticateNoKey.company.employees = authenticate.company.employees;
      authenticateNoKey.user.name = username;
      authenticateNoKey.user.image = null;
      authenticateNoKey.user.email = emailAddress;
      authenticateNoKey.company.email = emailAddress;
      authenticateNoKey.user.groupDescription =
          authenticate.user.groupDescription;
      expect(authenticateToJson(authenticate),
          authenticateToJson(authenticateNoKey));
    });
  });
/* 
    test('update password', () async {
      Map updPassword = {
        'username': username,
        'oldPassword': password,
        'newPassword': newPassword,
      };
      dynamic response =
          await client.post('s1/growerp/100/Password', data: updPassword);
      expect(response.data['messages'].substring(0, 16), 'Password updated');
    });
    test('reset password', () async {
      Response response = await client.post('s1/growerp/100/ResetPassword',
          data: {
            'username': username,
            'moquiSessionToken': sessionToken
          });
      expect(response.data['messages'].substring(0, 25),
          'A reset password was sent');
    });
  });
*/
  group('User operations >>>>> ', () {
    test('update loggedin user', () async {
      try {
        Response response = await client.post('services/updateUser100',
            data: userToJson(authenticate.user));
        dynamic result = userFromJson(getResponseData(response));
        expect(userToJson(result), userToJson(authenticate.user));
      } catch (e) {
        print("==catch==${e?.response?.data} ${e.response.headers}");
      }
    });
  });
}
