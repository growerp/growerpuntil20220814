import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:admin/models/@models.dart';
import 'package:admin/services/@services.dart';
import 'package:mockito/mockito.dart';
import '../data.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final Dio tdio = Dio();
  DioAdapterMock dioAdapterMock;
  Moqui repos;

  setUpAll(() async {
    dioAdapterMock = DioAdapterMock();
    tdio.httpClientAdapter = dioAdapterMock;
    await GlobalConfiguration().loadFromAsset("app_settings");
    repos = Moqui(client: tdio);
  });

  group('Repos test', () {
    test('Initial connection', () async {
      final responsepayload = jsonEncode({"data": "ytryrruyuuy"});
      final httpResponse = ResponseBody.fromString(
        responsepayload,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = await repos.getConnected();
      final expected = true;

      expect(response, equals(expected));
    });

    test('Get companies', () async {
      final responsepayload = companiesToJson(companies);
      final httpResponse = ResponseBody.fromString(
        responsepayload,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = await repos.getCompanies();
      final expected = companies;
      expect(companiesToJson(response), equals(companiesToJson(expected)));
    });

    test('Register', () async {
      final responsepayload = jsonEncode(authenticateNoKey);
      final httpResponse =
          ResponseBody.fromString(responsepayload, 200, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      });

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = await repos.register(
          companyName: companyName,
          firstName: firstName,
          lastName: lastName,
          currencyId: currencyId,
          email: emailAddress);
      final expected = authenticateNoKey;

      expect(
          authenticateToJson(response), equals(authenticateToJson(expected)));
    });
    test('Login', () async {
      final responsepayload = jsonEncode(authenticate);
      final httpResponse =
          ResponseBody.fromString(responsepayload, 200, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      });

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response =
          await repos.login(username: username, password: password);
      final expected = authenticate;

      expect(
          authenticateToJson(response), equals(authenticateToJson(expected)));
    });
    test('Reset Password', () async {
      final responsepayload =
          jsonEncode({'messages': 'A reset password was sent'});
      final httpResponse =
          ResponseBody.fromString(responsepayload, 200, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      });

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = await repos.resetPassword(username: username);
      final expected = {'messages': 'A reset password was sent'};

      expect(response, equals(expected));
    });
  });
}
