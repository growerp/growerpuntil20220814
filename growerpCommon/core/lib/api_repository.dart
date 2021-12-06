import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'services/api_result.dart';
import 'services/dio_client.dart';
import 'services/network_exceptions.dart';
import 'dart:io' show Platform;
import 'domains/domains.dart';
import 'package:core/domains/catalog/models/category_model.dart' as cat;

class APIRepository {
  String classificationId = GlobalConfiguration().get("classificationId");
  String databaseUrl = GlobalConfiguration().get("databaseUrl");
  String databaseUrlDebug = GlobalConfiguration().get("databaseUrlDebug");
  String? sessionToken;
  String? apiKey;
  bool useApiKey = true;

  late DioClient dioClient;
  late String _baseUrl;

  bool restRequestLogs =
      GlobalConfiguration().getValue<bool>("restRequestLogs");
  bool restResponseLogs =
      GlobalConfiguration().getValue<bool>("restResponseLogs");
  int connectTimeoutProd =
      GlobalConfiguration().getValue<int>("connectTimeoutProd") * 1000;
  int receiveTimeoutProd =
      GlobalConfiguration().getValue<int>("receiveTimeoutProd") * 1000;
  int connectTimeoutTest =
      GlobalConfiguration().getValue<int>("connectTimeoutTest") * 1000;
  int receiveTimeoutTest =
      GlobalConfiguration().getValue<int>("receiveTimeoutTest") * 1000;

  APIRepository() {
    var dio = Dio();
    _baseUrl = kReleaseMode
        ? databaseUrl
        : (kIsWeb || Platform.isIOS || Platform.isLinux)
            ? databaseUrlDebug
            : 'http://10.0.2.2:8080/';

    print("Production config url: $databaseUrl");
    print("Using base backend url: $_baseUrl");

    List<Interceptor> interceptors = [];
    interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      // print("====interceptor apiKey: ${this.apiKey}");
      if (this.apiKey != null && useApiKey)
        options.headers["api_key"] = this.apiKey;
      else {
        options.headers.remove("api_key");
        useApiKey = true; // one time only
      }
      if (restRequestLogs) {
        print(
            '===Outgoing dio request path: ${options.baseUrl}${options.path}');
        print('===Outgoing dio request headers: ${options.headers}');
        print('===Outgoing dio request data: ${options.data}');
      }
      return handler.next(options); //continue
    }, onResponse: (response, handler) async {
      if (restResponseLogs) {
        print("===incoming response: $response");
      }
      return handler.next(response); // continue
    }, onError: (DioError e, handler) async {
      // Do something with response error
      if (e.response != null) {
        print("=== e.response.data: ${e.response!.data}");
        print("=== e.response.headers: ${e.response!.headers}");
        print("=== e.response.request: ${e.response!.requestOptions}");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print("=== e.request: ${e.requestOptions}");
        print("=== e.message: ${e.message}");
      }
      return handler.next(e); //continue
    }));

    dioClient = DioClient(_baseUrl, dio, interceptors: interceptors);
  }

  Future<ApiResult<bool>> getConnected() async {
    try {
      final response = await dioClient.get('growerp/moquiSessionToken', null);
      this.sessionToken = response.toString();
      return ApiResult.success(
          data: sessionToken != null); // return true if session token ok
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  void setApiKey(String apiKey, String sessionToken) {
    this.apiKey = apiKey;
    this.sessionToken = sessionToken;
  }

  Future<ApiResult<Authenticate>> getAuthenticate() async {
    try {
      final response =
          await dioClient.get('rest/s1/growerp/100/Authenticate', apiKey!);
      return ApiResult.success(data: authenticateFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<bool>> checkCompany(String partyId) async {
    try {
      useApiKey =
          false; // no apykey required, if not valid will report no company
      Response response = await dioClient.get(
          'rest/s1/growerp/100/CheckCompany', apiKey!,
          queryParameters: {'partyId': partyId});
      return ApiResult.success(data: response.data["ok"] == "ok");
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Company>>> getCompanies(
      {bool mainCompanies = true, // just owner organizations or all?
      int? start,
      int? limit,
      String? filter}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/Companies', null, queryParameters: {
        "mainCompanies": mainCompanies.toString(),
        'start': start,
        'limit': limit,
        'filter': filter,
      });
      return ApiResult.success(data: companiesFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<ItemType>>> getItemTypes({bool sales = true}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/ItemTypes', apiKey!, queryParameters: {
        "sales": sales,
      });
      return ApiResult.success(data: itemTypesFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  /// The demo store can only register as a customer.
  /// Any other store it depends on the person logging in.
  Future<ApiResult<Authenticate>> register({
    required String companyName,
    required String firstName,
    required String lastName,
    required String currencyId,
    required String email,
    bool demoData = true,
  }) async {
    try {
      var locale;
      // if (!kIsWeb) locale = await Devicelocale.currentLocale;
      final response = await dioClient.post(
        'rest/s1/growerp/100/UserAndCompany',
        null,
        data: {
          'username': email,
          'emailAddress': email,
          'newPassword': kReleaseMode ? null : 'qqqqqq9!',
          'firstName': firstName,
          'lastName': lastName,
          'companyName': companyName,
          'locale': locale,
          'currencyId': currencyId,
          'companyEmailAddress': email,
          'classificationId': classificationId,
          'productionEnvironment': kReleaseMode.toString(),
          'moquiSessionToken': sessionToken,
          'demoData': demoData.toString()
        },
      );
      return ApiResult.success(data: authenticateFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Authenticate>> login(
      {required String username, required String password}) async {
    try {
      final response =
          await dioClient.post('rest/s1/growerp/100/Login', null, data: {
        'username': username,
        'password': password,
        'classificationId': classificationId,
        'moquiSessionToken': this.sessionToken
      });
      return ApiResult.success(data: authenticateFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<void>> resetPassword({required String username}) async {
    try {
      await dioClient.post('rest/s1/growerp/100/ResetPassword', null,
          data: {'username': username, 'moquiSessionToken': this.sessionToken});
      return ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<void>> updatePassword(
      {required String username,
      required String oldPassword,
      required String newPassword}) async {
    try {
      await dioClient.post('rest/s1/growerp/100/Password', apiKey!, data: {
        'username': username,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'moquiSessionToken': this.sessionToken
      });
      return ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<String>> logout() async {
    try {
      final response = await dioClient.post('growerp/logout', apiKey!);
      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<User>>> getUser(
      {int? start,
      int? limit,
      List<String>? userGroupIds,
      String? userPartyId,
      String? filter,
      String? searchString}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/User', apiKey!, queryParameters: {
        'userPartyId': userPartyId,
        'userGroupIds': userGroupIds,
        'filter': filter,
        'start': start,
        'limit': limit,
        'search': searchString
      });
      return ApiResult.success(data: usersFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // for ecommerce
  Future<ApiResult<User>> registerUser(String user, String ownerPartyId) async {
    try {
      final response = await dioClient
          .post('rest/s1/growerp/100/RegisterUser', apiKey!, data: {
        'user': user,
        'moquiSessionToken': sessionToken,
        'classificationId': classificationId,
        'ownerPartyId': ownerPartyId,
        'password': kReleaseMode ? null : 'qqqqqq9!',
      });
      return ApiResult.success(data: userFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<User>> updateUser(User user) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/User', apiKey!,
          data: {'user': userToJson(user), 'moquiSessionToken': sessionToken});
      return ApiResult.success(data: userFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<User>> createUser(User user) async {
    try {
      final response = await dioClient.post('rest/s1/growerp/100/User', apiKey!,
          data: {'user': userToJson(user), 'moquiSessionToken': sessionToken});
      return ApiResult.success(data: userFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<User>> deleteUser(String partyId) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/User', apiKey!,
          queryParameters: {'partyId': partyId});
      return ApiResult.success(data: userFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Company>> updateCompany(Company company) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/Company', apiKey!,
          data: {'company': company, 'moquiSessionToken': sessionToken});
      return ApiResult.success(data: companyFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<FinDoc>> updateFinDoc(FinDoc finDoc) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/FinDoc', apiKey!, data: {
        'finDoc': finDocToJson(finDoc),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: finDocFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<FinDoc>> createFinDoc(FinDoc finDoc) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/FinDoc', apiKey!, data: {
        'finDoc': finDocToJson(finDoc),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: finDocFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<FinDoc>> receiveShipment(FinDoc finDoc) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/FinDocShipment', apiKey!, data: {
        'finDoc': finDocToJson(finDoc),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: finDocFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<FinDoc>>> getFinDoc(
      {int? start,
      int? limit,
      bool? open,
      bool? sales,
      String? docType,
      DateTime? startDate,
      String? finDocId,
      String? search,
      String? customerCompanyPartyId}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/FinDoc', apiKey!, queryParameters: {
        'sales': sales,
        'docType': docType,
        'open': open,
        'finDocId': finDocId,
        'startDate': '${startDate?.year.toString()}-'
            '${startDate?.month.toString().padLeft(2, '0')}-'
            '${startDate?.day.toString().padLeft(2, '0')}',
        'start': start,
        'limit': limit,
        'search': search,
        'classificationId': classificationId,
        'customerCompanyPartyId': customerCompanyPartyId,
      });
      return ApiResult.success(data: finDocsFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<String>>> getRentalOccupancy(
      {required String productId}) async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/RentalOccupancy', apiKey!,
          queryParameters: {
            'productId': productId,
          });
      var json = jsonDecode(response.toString())['rentalFullDates'];
      List<dynamic> list = List.from(json);
      List<String> stringList = [];
      // change members from dynamic to string
      for (String string in list) stringList.add(string);
      return ApiResult.success(data: stringList);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<cat.Category>>> getCategory(
      {int? start,
      int? limit,
      String? companyPartyId,
      String? filter,
      String? searchString}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/Categories', apiKey!, queryParameters: {
        'start': start,
        'limit': limit,
        'companyPartyId': companyPartyId,
        'filter': filter,
        'search': searchString,
        'classificationId': classificationId,
      });
      return ApiResult.success(data: categoriesFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<cat.Category>> createCategory(cat.Category category) async {
    // no categoryId is add
    try {
      final response =
          await dioClient.post('rest/s1/growerp/100/Category', apiKey!, data: {
        'category': categoryToJson(category),
        'classificationId': classificationId,
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: categoryFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<cat.Category>> updateCategory(cat.Category category) async {
    try {
      final response =
          await dioClient.patch('rest/s1/growerp/100/Category', apiKey!, data: {
        'category': categoryToJson(category),
        'classificationId': classificationId,
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: categoryFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<cat.Category>> deleteCategory(cat.Category category) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/Category', apiKey!,
          queryParameters: {'category': categoryToJson(category)});
      return ApiResult.success(data: categoryFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Location>>> getLocation(
      {int? start,
      int? limit,
      String? locationId,
      String? filter,
      String? searchString}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/Location', apiKey!, queryParameters: {
        'start': start,
        'limit': limit,
        'filter': filter,
        'search': searchString,
      });
      return ApiResult.success(data: locationsFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Location>> createLocation(Location location) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/Location', apiKey!, data: {
        'location': locationToJson(location),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: locationFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Location>> updateLocation(Location location) async {
    // no categoryId is add
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Location', apiKey!, data: {
        'location': locationToJson(location),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: locationFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Location>> deleteLocation(Location location) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/Location', apiKey!,
          queryParameters: {'location': locationToJson(location)});
      return ApiResult.success(data: locationFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Product>>> getProduct(
      {int? start,
      int? limit,
      String? companyPartyId,
      String? categoryId,
      String? productId,
      String? productTypeId,
      String? assetClassId,
      String? filter,
      String? searchString}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/Products', apiKey!, queryParameters: {
        'companyPartyId': companyPartyId,
        'categoryId': categoryId,
        'productId': productId,
        'productTypeId': productTypeId,
        'assetClassId': assetClassId,
        'start': start,
        'limit': limit,
        'filter': filter,
        'search': searchString
      });
      return ApiResult.success(data: productsFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Product>> createProduct(Product product) async {
    // no productId is add
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/Product', apiKey!, data: {
        'product': productToJson(product),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: productFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Product>> updateProduct(Product product) async {
    // no productId is add
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Product', apiKey!, data: {
        'product': productToJson(product),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: productFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Product>> deleteProduct(Product product) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/Product', apiKey!,
          queryParameters: {'product': productToJson(product)});
      return ApiResult.success(data: productFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Asset>>> getAsset(
      {int? start,
      int? limit,
      String? companyPartyId,
      String? assetClassId,
      String? assetId,
      String? productId,
      String? filter,
      String? searchString}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/Asset', apiKey!, queryParameters: {
        'companyPartyId': companyPartyId,
        'assetId': assetId,
        'assetClassId': assetClassId,
        'productId': productId,
        'start': start,
        'limit': limit,
        'filter': filter,
        'search': searchString
      });
      return ApiResult.success(data: assetsFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Asset>> createAsset(Asset asset) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/Asset', apiKey!, data: {
        'asset': assetToJson(asset),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: assetFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Asset>> updateAsset(Asset asset) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Asset', apiKey!, data: {
        'asset': assetToJson(asset),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: assetFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Asset>> deleteAsset(Asset asset) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/Asset', apiKey!,
          queryParameters: {'asset': assetToJson(asset)});
      return ApiResult.success(data: assetFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Opportunity>>> getOpportunity(
      {int? start,
      int? limit,
      String? opportunityId,
      bool? my,
      String? search}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/Opportunity', apiKey!, queryParameters: {
        'opportunityId': opportunityId,
        'start': start,
        'limit': limit,
        'my': my.toString(),
        'search': search
      });
      return ApiResult.success(
          data: opportunitiesFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Opportunity>> createOpportunity(
      Opportunity opportunity) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/Opportunity', apiKey!, data: {
        'opportunity': opportunityToJson(opportunity),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: opportunityFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Opportunity>> updateOpportunity(
      Opportunity opportunity) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Opportunity', apiKey!, data: {
        'opportunity': opportunityToJson(opportunity),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: opportunityFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Opportunity>> deleteOpportunity(
      Opportunity opportunity) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/Opportunity', apiKey!,
          queryParameters: {'opportunity': opportunityToJson(opportunity)});
      return ApiResult.success(data: opportunityFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<GlAccount>> getGlAccount() async {
    try {
      final response =
          await dioClient.get('rest/s1/growerp/100/Ledger', apiKey!);
      //    return glAccountListFromJson(response.toString());
      return ApiResult.success(data: glAccountFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<ChatRoom>>> getChatRooms(
      {int? start,
      int? limit,
      String? chatRoomId,
      String? chatRoomName,
      String? userId,
      bool? isPrivate,
      String? search,
      String? filter}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/ChatRoom', apiKey!, queryParameters: {
        'chatRoomId': chatRoomId,
        'chatRoomName': chatRoomName,
        'userId': userId,
        'start': start,
        'limit': limit,
        'isPrivate': isPrivate,
        'search': search,
        'filter': filter,
      });
      return ApiResult.success(data: chatRoomsFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ChatRoom>> updateChatRoom(ChatRoom chatRoom) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/ChatRoom', apiKey!, data: {
        'chatRoom': chatRoomToJson(chatRoom),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: chatRoomFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ChatRoom>> createChatRoom(ChatRoom chatRoom) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/ChatRoom', apiKey!, data: {
        'chatRoom': chatRoomToJson(chatRoom),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: chatRoomFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ChatRoom>> deleteChatRoom(String chatRoomId) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/ChatRoom', apiKey!,
          queryParameters: {'chatRoomId': chatRoomId});
      //    return response.data["chatRoomId"];
      return ApiResult.success(data: chatRoomFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<ChatMessage>>> getChatMessages(
      {required String chatRoomId,
      int? start,
      int? limit,
      String? search}) async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/ChatMessage', apiKey!, queryParameters: {
        'chatRoomId': chatRoomId,
        'start': start,
        'limit': limit,
        'search': search
      });
      return ApiResult.success(data: chatMessagesFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Task>>> getTask(
      {int? start,
      int? limit,
      String? taskId,
      bool? open,
      String? search}) async {
    try {
      final response = await dioClient
          .get('rest/s1/growerp/100/Task', apiKey!, queryParameters: {
        'taskId': taskId,
        'start': start,
        'limit': limit,
        'open': open.toString(),
        'search': search
      });
      return ApiResult.success(data: tasksFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Task>> createTask(Task task) async {
    try {
      final response = await dioClient.post('rest/s1/growerp/100/Task', apiKey!,
          data: {'task': taskToJson(task), 'moquiSessionToken': sessionToken});
      return ApiResult.success(data: taskFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Task>> updateTask(Task task) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Task', apiKey!,
          data: {'task': taskToJson(task), 'moquiSessionToken': sessionToken});
      return ApiResult.success(data: taskFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<TimeEntry>> deleteTimeEntry(TimeEntry timeEntry) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/TimeEntry', apiKey!, data: {
        'timeEntry': timeEntryToJson(timeEntry),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: timeEntryFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<TimeEntry>> createTimeEntry(TimeEntry timeEntry) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/TimeEntry', apiKey!, data: {
        'timeEntry': timeEntryToJson(timeEntry),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: timeEntryFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<TimeEntry>> updateTimeEntry(TimeEntry timeEntry) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/TimeEntry', apiKey!, data: {
        'timeEntry': timeEntryToJson(timeEntry),
        'moquiSessionToken': sessionToken
      });
      return ApiResult.success(data: timeEntryFromJson(response.toString()));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
