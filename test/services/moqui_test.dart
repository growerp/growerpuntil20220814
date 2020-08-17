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
  client.options.connectTimeout = 10000; //10s
  client.options.receiveTimeout = 20000;
  client.options.headers = {'Content-Type': 'application/json'};

  setUp(() async {
    Response response = await client.get('moquiSessionToken');
    sessionToken = response.data;
  });

  test('test connection', () async {
    print("need a local version of Moqui see: README of this project");
    print("=========================================================");
    Response response = await client.get('moquiSessionToken');
    sessionToken = response.data;
    expect(response.data.length, 20);
  });

  test('CurrencyList', () async {
    Response response = await client.get('s1/growerp/100/CurrencyList');
    dynamic result = currencyListFromJson(response.toString()).currencyList;
    expect(result.length,
        170); // TODO: if wrong is detected but test will not fail
  });

  test('Companies', () async {
    Response response = await client.get('s1/growerp/100/Companies');
    dynamic result = companiesFromJson(response.toString()).companies;
    expect(result.length > 0, true);
  });

  test('register', () async {
    register['moquiSessionToken'] = sessionToken;
    register['emailAddress'] = randomString4 + register['emailAddress'];
    register['companyEmail'] = register['emailAddress'];
    register['username'] = register['emailAddress'];
    authenticateNoKey.user.email = register['emailAddress'];
    dynamic response =
        await client.post('s1/growerp/100/UserAndCompany', data: register);
    Authenticate result = authenticateFromJson(response.toString());
    authenticateNoKey.company.partyId = result.company.partyId;
    authenticateNoKey.user.partyId = result.user.partyId;
    authenticateNoKey.user.userId = result.user.userId;
    authenticateNoKey.user.email = result.user.email;
    authenticateNoKey.user.name = result.user.name;
    authenticateNoKey.company.email = result.company.email;
    authenticateNoKey.apiKey = result.apiKey;
    apiKey = result.apiKey;
    login.addAll({
      'companyPartyId': result.company.partyId,
      'username': result.user.name,
      'password': password
    });
    authenticate = authenticateNoKey;
    expect(authenticateToJson(result), authenticateToJson(authenticateNoKey));
  });

  test('login', () async {
    dynamic response = await client.post('s1/growerp/100/Login', data: login);
    Authenticate loginAuth = authenticateFromJson(response.toString());
    authenticate.apiKey = loginAuth.apiKey;
    print("==========apiKey: ${loginAuth.apiKey}");
    apiKey = loginAuth.apiKey;
    authenticate.moquiSessionToken = loginAuth.moquiSessionToken;
    sessionToken = loginAuth.moquiSessionToken;
    expect(authenticateToJson(loginAuth), authenticateToJson(authenticate));
  });
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
  test('get catalog', () async {
    Response response = await client.get('s1/growerp/100/CategoriesAndProducts',
        queryParameters: {'companyPartyId': login['companyPartyId']});
    Catalog result = catalogFromJson(response.toString());
    expect(result.products.length, 2);
    expect(result.categories.length, 2);
  });
}
