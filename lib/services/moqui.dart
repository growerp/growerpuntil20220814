import 'package:dio/dio.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'dart:async';
import '../models/@models.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Moqui {
  final Dio client;

  String sessionToken;
  String partyClassificationId =
      GlobalConfiguration().getValue("partyClassificationId");

  Moqui({@required this.client}) {
    if (kReleaseMode) {
      //platform not supported on the web
      // is Release Mode ??
      client.options.baseUrl = 'https://test.growerp.org/';
    } else if (kIsWeb || Platform.isIOS || Platform.isLinux) {
      client.options.baseUrl = 'http://localhost:8080/';
    } else if (Platform.isAndroid) {
      client.options.baseUrl = 'http://10.0.2.2:8080/';
    }
    client.options.connectTimeout = 20000; //20s
    client.options.receiveTimeout = 40000;
    client.options.headers = {'Content-Type': 'application/json'};

/*    client.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      print('===Outgoing dio request path: ${options.path}');
      print('===Outgoing dio request headers: ${options.headers}');
      print('===Outgoing dio request data: ${options.data}');
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
  }

  String responseMessage(e) {
    String errorDescription = e.toString();
    if (e is DioError) {
      DioError dioError = e;
      switch (dioError.type) {
        case DioErrorType.CANCEL:
          errorDescription = 'Request to API server was cancelled';
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = 'Connection timeout with API server';
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
              'Connection to API server failed due to internet connection';
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = 'Receive timeout in connection with API server';
          break;
        case DioErrorType.RESPONSE:
          errorDescription = 'Internet or server problem?';
          break;
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = 'Send timeout in connection with API server';
          break;
      }
      print("====dio error: $errorDescription");
    }
    if (e?.response != null && e?.response?.data != null) {
      errorDescription = e.response.data["errors"];
    }
//    if (e.response != null) {
    // print('dio error data: ${e.response.data}');
    // print('dio error headers: ${e.response.headers}');
    // print('dio error request: ${e.response.request}');
//    } else {
    // Something happened in setting up or sending the request that triggered an Error
    // print('dio no response, request: ${e.request}');
    // print('dio no response, message: ${e.message}');
//    }
    print('==repos.dart: returning error message: $errorDescription');
    return errorDescription;
  }

// -----------------------------general ------------------------
  Future<dynamic> getConnected() async {
    try {
      Response response = await client.get('rest/moquiSessionToken');
      this.sessionToken = response.toString();
      return sessionToken != null; // return true if session token ok
    } catch (e) {
      return responseMessage(e);
    }
  }

  void setApikey(String apiKey) {
    client.options.headers['api_key'] = apiKey;
  }

  Future<dynamic> checkApikey() async {
    try {
      Response response = await client.get('rest/s1/growerp/100/CheckApiKey');
      return response.data["ok"] == "ok"; // return true if session token ok
    } catch (e) {
      return responseMessage(e);
    }
  }

  Future<dynamic> checkCompany(String partyId) async {
    try {
      Response response = await client.get('rest/s1/growerp/100/CheckCompany',
          queryParameters: {'partyId': partyId});
      return response.data["ok"] == 'ok'; // return true if session token ok
    } catch (e) {
      return responseMessage(e);
    }
  }

  Future<dynamic> getCompanies() async {
    try {
      Response response = await client.get('rest/s1/growerp/100/Companies');
      return companiesFromJson(response.toString());
    } catch (e) {
      return responseMessage(e);
    }
  }

  /// The demo store can only register as a customer.
  /// Any other store it depends on the person logging in.
  Future<dynamic> register(
      {String companyName,
      String companyPartyId, // if empty will create new company too!
      @required String firstName,
      @required String lastName,
      String currency,
      @required String email,
      List data}) async {
    try {
      var locale;
      // if (!kIsWeb) locale = await Devicelocale.currentLocale;
      Response response =
          await client.post('rest/s1/growerp/100/UserAndCompany',
              data: {
                'username': email, 'emailAddress': email,
                'newPassword': 'qqqqqq9!', 'firstName': firstName,
                'lastName': lastName, 'locale': locale,
                'companyPartyId': companyPartyId, // for existing companies
                'companyName': companyName, 'currencyUomId': currency,
                'companyEmail': email,
                'partyClassificationId': 'AppMaster',
                'environment': kReleaseMode,
                'moquiSessionToken': sessionToken
              },
              options: Options(headers: {'api_key': null}));
      return authenticateFromJson(response.toString());
    } catch (e) {
      return responseMessage(e);
    }
  }

  Future<dynamic> login(
      {@required String username, @required String password}) async {
    try {
      Response response = await client.post('rest/s1/growerp/100/Login', data: {
        'username': username,
        'password': password,
        'moquiSessionToken': this.sessionToken
      });
      dynamic result = jsonDecode(response.toString());
      if (result['passwordChange'] == 'true') return 'passwordChange';
      this.sessionToken = result['moquiSessionToken'];
      client.options.headers['api_key'] = result["apiKey"];
      return authenticateFromJson(response.toString());
    } catch (e) {
      return (responseMessage(e));
    }
  }

  Future<dynamic> resetPassword({@required String username}) async {
    try {
      Response result = await client.post('rest/s1/growerp/100/ResetPassword',
          data: {'username': username, 'moquiSessionToken': this.sessionToken});
      return json.decode(result.toString());
    } catch (e) {
      return responseMessage(e);
    }
  }

  Future<dynamic> updatePassword(
      {@required String username,
      @required String oldPassword,
      @required String newPassword}) async {
    try {
      await client.put('rest/s1/growerp/100/Password', data: {
        'username': username,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'moquiSessionToken': this.sessionToken
      });
      return getAuthenticate();
    } catch (e) {
      return responseMessage(e);
    }
  }

  Future<dynamic> logout() async {
    try {
      await client.post('rest/logout');
      Authenticate authenticate = await getAuthenticate();
      authenticate.apiKey = null;
      persistAuthenticate(authenticate);
      return authenticate;
    } catch (e) {
      return responseMessage(e);
    }
  }

  Future<void> persistAuthenticate(Authenticate authenticate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (authenticate != null) {
      await prefs.setString('authenticate', authenticateToJson(authenticate));
    } else {
      await prefs.setString('authenticate', null);
    }
    client.options.headers['api_key'] = authenticate?.apiKey;
  }

  Future<Authenticate> getAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString('authenticate');
    if (result != null) return authenticateFromJson(result);
    return null;
  }

  Future<dynamic> getUser(String partyId) async {
    try {
      Response response = await client.get('rest/s1/growerp/100/User',
          queryParameters: {'partyId': partyId});
      if (partyId == null)
        return usersFromJson(response.toString());
      else {
        return userFromJson(response.toString());
      }
    } catch (e) {
      return responseMessage(e);
    }
  }

/*
  async uploadImage(size, base64, type, id) {
    axios.post('s1/growerp/UploadImage',
      {   type: type, id: id,
        size: size, contentFile: base64 })}
  async downloadImage(size, type, id) {
    return await axios.post('s1/growerp/DownloadImage',
      {   size: size, type: type, id: id })}
*/
  Future<dynamic> updateUser(User user, String imagePath) async {
    // no partyId is add
    try {
      if (imagePath != null) {
        String justName = imagePath.split('/').last;
        FormData formData = FormData.fromMap({
          "type": 'user',
          "id": user.partyId,
          "file": await MultipartFile.fromFile(imagePath, filename: justName),
          "moquiSessionToken": this.sessionToken
        });
        await client.post("growerp/uploadImage", data: formData);
      }
      Response response;
      if (user.partyId != null) {
        response = await client.patch('rest/s1/growerp/100/User', data: {
          'user': userToJson(user),
          'moquiSessionToken': sessionToken
        });
      } else {
        await client.put('rest/s1/growerp/100/User', data: {
          'user': userToJson(user),
          'moquiSessionToken': sessionToken
        });
      }
      return userFromJson(response.toString());
    } catch (e) {
      return responseMessage(e);
    }
  }

  Future<dynamic> deleteUser(String partyId) async {
    try {
      Response response = await client.delete('rest/s1/growerp/100/User',
          queryParameters: {'partyId': partyId});
      return response.data["partyId"];
    } catch (e) {
      return responseMessage(e);
    }
  }

  Future<dynamic> updateCompany(Company company, String imagePath) async {
    try {
      if (imagePath != null) {
        String justName = imagePath.split('/').last;
        FormData formData = FormData.fromMap({
          "type": 'company',
          "id": company.partyId,
          "file": await MultipartFile.fromFile(imagePath, filename: justName),
          "moquiSessionToken": this.sessionToken
        });
        await client.post("growerp/uploadImage", data: formData);
      }
      Response response = await client.post('rest/s1/growerp/100/Company',
          data: {
            'company': companyToJson(company),
            'moquiSessionToken': sessionToken
          });
      print("===aaa==${response.toString()}=");
      return companyFromJson(response.toString());
    } catch (e) {
      print("===catch: $e");
      return responseMessage(e);
    }
  }
}
