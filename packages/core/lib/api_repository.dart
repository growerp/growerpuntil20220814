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
  String classificationId = GlobalConfiguration().get('classificationId');
  String databaseUrl = GlobalConfiguration().get('databaseUrl');
  String databaseUrlDebug = GlobalConfiguration().get('databaseUrlDebug');
  String? sessionToken;
  String? apiKey;

  late DioClient dioClient;
  late String _baseUrl;

  bool restRequestLogs =
      GlobalConfiguration().getValue<bool>('restRequestLogs');
  bool restResponseLogs =
      GlobalConfiguration().getValue<bool>('restResponseLogs');
  int connectTimeoutProd =
      GlobalConfiguration().getValue<int>('connectTimeoutProd') * 1000;
  int receiveTimeoutProd =
      GlobalConfiguration().getValue<int>('receiveTimeoutProd') * 1000;
  int connectTimeoutTest =
      GlobalConfiguration().getValue<int>('connectTimeoutTest') * 1000;
  int receiveTimeoutTest =
      GlobalConfiguration().getValue<int>('receiveTimeoutTest') * 1000;

  APIRepository() {
    var dio = Dio();
    _baseUrl = kReleaseMode
        ? '$databaseUrl/'
        : (kIsWeb || Platform.isIOS || Platform.isLinux)
            ? '$databaseUrlDebug/'
            : 'http://10.0.2.2:8080/';

    print('Production config url: $databaseUrl');
    print('Using base backend url: $_baseUrl');

    dioClient = DioClient(_baseUrl, dio, interceptors: []);
  }

  /// Json model List decoding
  ApiResult<List<T>> getResponseList<T>(String name, String result,
      T Function(Map<String, dynamic> json) fromJson) {
    final l = json.decode(result)[name] as Iterable;
    return ApiResult.success(data: List<T>.from(l.map<T>(
        // ignore: avoid_as, avoid_annotating_with_dynamic
        (dynamic i) => fromJson(i as Map<String, dynamic>))));
  }

  /// Json model decoding
  ApiResult<T> getResponse<T>(String name, String result,
      T Function(Map<String, dynamic> json) fromJson) {
    return ApiResult.success(
        data: fromJson(json.decode(result)[name] as Map<String, dynamic>));
  }

  Future<ApiResult<bool>> getConnected() async {
    try {
      final response = await dioClient.get('growerp/moquiSessionToken', null);
      this.sessionToken = response.toString();
      return ApiResult.success(
          data: sessionToken != null); // return true if session token ok
    } on Exception catch (e) {
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
      return getResponse<Authenticate>(
          "authenticate", response, (json) => Authenticate.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<bool>> checkCompany(String partyId) async {
    try {
      // no apykey required, if not valid will report no company
      final response = await dioClient.get(
          'rest/s1/growerp/100/CheckCompany', null,
          queryParameters: <String, dynamic>{'partyId': partyId});
      return ApiResult.success(
          data: jsonDecode(response.toString())['ok'] == 'ok');
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Company>>> getCompanies(
      {bool mainCompanies = true, // just owner organizations or all?
      int? start,
      int? limit,
      String? filter}) async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/Companies', null,
          queryParameters: <String, dynamic>{
            'mainCompanies': mainCompanies.toString(),
            'start': start,
            'limit': limit,
            'filter': filter,
          });
      return getResponseList<Company>(
          "companies", response, (json) => Company.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<ItemType>>> getItemTypes({required bool sales}) async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/ItemTypes', apiKey!,
          queryParameters: <String, dynamic>{
            'sales': sales,
          });
      return getResponseList<ItemType>(
          "itemTypes", response, (json) => ItemType.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<PaymentType>>> getPaymentTypes(
      {bool sales = true}) async {
    try {
      final response =
          await dioClient.get('rest/s1/growerp/100/PaymentTypes', apiKey!);
      return getResponseList<PaymentType>(
          "paymentTypes", response, (json) => PaymentType.fromJson(json));
    } on Exception catch (e) {
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
        data: <String, dynamic>{
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
      return getResponse<Authenticate>(
          "authenticate", response, (json) => Authenticate.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Authenticate>> login(
      {required String username, required String password}) async {
    try {
      final response = await dioClient
          .post('rest/s1/growerp/100/Login', null, data: <String, dynamic>{
        'username': username,
        'password': password,
        'moquiSessionToken': this.sessionToken
      });
      return getResponse<Authenticate>(
          "authenticate", response, (json) => Authenticate.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<void>> resetPassword({required String username}) async {
    try {
      await dioClient.post('rest/s1/growerp/100/ResetPassword', null,
          data: <String, dynamic>{
            'username': username,
            'moquiSessionToken': this.sessionToken
          });
      return ApiResult.success(data: null);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<void>> updatePassword(
      {required String username,
      required String oldPassword,
      required String newPassword}) async {
    try {
      await dioClient.post('rest/s1/growerp/100/Password', apiKey!,
          data: <String, dynamic>{
            'username': username,
            'oldPassword': oldPassword,
            'newPassword': newPassword,
            'moquiSessionToken': this.sessionToken
          });
      return ApiResult.success(data: null);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<String>> logout() async {
    try {
      final response = await dioClient.post('growerp/logout', apiKey!);
      return ApiResult.success(data: response);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<User>>> getUser(
      {int? start,
      int? limit,
      List<UserGroup>? userGroups,
      String? userPartyId,
      String? filter,
      String? searchString}) async {
    try {
      final response = await dioClient.get('rest/s1/growerp/100/User', apiKey!,
          queryParameters: <String, dynamic>{
            'userPartyId': userPartyId,
            'userGroupIds':
                userGroups != null ? UserGroup.getIdList(userGroups) : null,
            'filter': filter,
            'start': start,
            'limit': limit,
            'search': searchString
          });
      return getResponseList<User>(
          "users", response, (json) => User.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // for ecommerce
  Future<ApiResult<User>> registerUser(User user, String ownerPartyId) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/RegisterUser', apiKey!,
          data: <String, dynamic>{
            'user': jsonEncode(user.toJson()),
            'moquiSessionToken': sessionToken,
            'classificationId': classificationId,
            'ownerPartyId': ownerPartyId,
            'password': kReleaseMode ? null : 'qqqqqq9!',
          });
      return getResponse<User>("user", response, (json) => User.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<User>> updateUser(User user) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/User', apiKey!, data: <String, dynamic>{
        'user': jsonEncode(user.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<User>("user", response, (json) => User.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<User>> createUser(User user) async {
    try {
      final response = await dioClient
          .post('rest/s1/growerp/100/User', apiKey!, data: <String, dynamic>{
        'user': jsonEncode(user.toJson()),
        'password': kDebugMode ? 'qqqqqq9!' : null,
        'moquiSessionToken': sessionToken
      });
      return getResponse<User>("user", response, (json) => User.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<User>> deleteUser(String partyId) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/User', apiKey!,
          queryParameters: <String, dynamic>{'partyId': partyId});
      return getResponse<User>("user", response, (json) => User.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  /// not implemented yet
  Future<ApiResult<Company>> createCompany(Company company) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/Company', apiKey!, data: <String, dynamic>{
        'company': jsonEncode(company.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<Company>(
          "company", response, (json) => Company.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Company>> updateCompany(Company company) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Company', apiKey!, data: <String, dynamic>{
        'company': jsonEncode(company.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<Company>(
          "company", response, (json) => Company.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<FinDoc>> updateFinDoc(FinDoc finDoc) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/FinDoc', apiKey!, data: <String, dynamic>{
        'finDoc': jsonEncode(finDoc.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<FinDoc>(
          "finDoc", response, (json) => FinDoc.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<FinDoc>> createFinDoc(FinDoc finDoc) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/FinDoc', apiKey!, data: <String, dynamic>{
        'finDoc': jsonEncode(finDoc.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<FinDoc>(
          "finDoc", response, (json) => FinDoc.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<FinDoc>> receiveShipment(FinDoc finDoc) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/FinDocShipment', apiKey!,
          data: <String, dynamic>{
            'finDoc': jsonEncode(finDoc.toJson()),
            'moquiSessionToken': sessionToken
          });
      return getResponse<FinDoc>(
          "finDoc", response, (json) => FinDoc.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  /*Future<ApiResult<FinDoc>> confirmPurchasePayment(String paymentId) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Payment', apiKey!, data: <String, dynamic>{
        'paymentId': paymentId,
        'moquiSessionToken': sessionToken
      });
      return getResponse<FinDoc>(
          "finDoc", response, (json) => FinDoc.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
*/
  Future<ApiResult<List<FinDoc>>> getFinDoc(
      {int? start,
      int? limit,
      bool? open,
      bool? sales,
      FinDocType? docType,
      DateTime? startDate,
      String? finDocId,
      String? searchString,
      String? customerCompanyPartyId}) async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/FinDoc', apiKey!,
          queryParameters: <String, dynamic>{
            'sales': sales,
            'docType': docType,
            'open': open,
            'finDocId': finDocId,
            'startDate': '${startDate?.year.toString()}-'
                '${startDate?.month.toString().padLeft(2, '0')}-'
                '${startDate?.day.toString().padLeft(2, '0')}',
            'start': start,
            'limit': limit,
            'search': searchString,
            'classificationId': classificationId,
            'customerCompanyPartyId': customerCompanyPartyId,
          });
      return getResponseList<FinDoc>(
          "finDocs", response, (json) => FinDoc.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<String>>> getRentalOccupancy(
      {required String productId}) async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/RentalOccupancy', apiKey!,
          queryParameters: <String, dynamic>{
            'productId': productId,
          });
      var json = jsonDecode(response.toString())['rentalFullDates'];
      List<dynamic> list = List.from(json);
      List<String> stringList = [];
      // change members from dynamic to string
      for (String string in list) stringList.add(string);
      return ApiResult.success(data: stringList);
    } on Exception catch (e) {
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
      final response = await dioClient.get(
          'rest/s1/growerp/100/Categories', apiKey ?? null,
          queryParameters: <String, dynamic>{
            'start': start,
            'limit': limit,
            'companyPartyId': companyPartyId,
            'filter': filter,
            'search': searchString,
            'classificationId': classificationId,
          });
      return getResponseList<cat.Category>(
          "categories", response, (json) => cat.Category.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<cat.Category>> createCategory(cat.Category category) async {
    // no categoryId is add
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/Category', apiKey!,
          data: <String, dynamic>{
            'category': jsonEncode(category.toJson()),
            'classificationId': classificationId,
            'moquiSessionToken': sessionToken
          });
      return getResponse<cat.Category>(
          "category", response, (json) => cat.Category.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<cat.Category>> updateCategory(cat.Category category) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Category', apiKey!,
          data: <String, dynamic>{
            'category': jsonEncode(category.toJson()),
            'classificationId': classificationId,
            'moquiSessionToken': sessionToken
          });
      return getResponse<cat.Category>(
          "category", response, (json) => cat.Category.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<cat.Category>> deleteCategory(cat.Category category) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/Category', apiKey!,
          queryParameters: <String, dynamic>{
            'category': jsonEncode(category.toJson()),
            'classificationId': classificationId,
            'moquiSessionToken': sessionToken
          });
      return getResponse<cat.Category>(
          "category", response, (json) => cat.Category.fromJson(json));
    } on Exception catch (e) {
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
      final response = await dioClient.get(
          'rest/s1/growerp/100/Location', apiKey!,
          queryParameters: <String, dynamic>{
            'start': start,
            'limit': limit,
            'filter': filter,
            'search': searchString,
          });
      return getResponseList<Location>(
          "locations", response, (json) => Location.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Location>> createLocation(Location location) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/Location', apiKey!, data: <String, dynamic>{
        'location': jsonEncode(location.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<Location>(
          "location", response, (json) => Location.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Location>> updateLocation(Location location) async {
    // no categoryId is add
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Location', apiKey!, data: <String, dynamic>{
        'location': jsonEncode(location.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<Location>(
          "location", response, (json) => Location.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Location>> deleteLocation(Location location) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/Location', apiKey!,
          queryParameters: <String, dynamic>{
            'location': jsonEncode(location.toJson()),
          });
      return getResponse<Location>(
          "location", response, (json) => Location.fromJson(json));
    } on Exception catch (e) {
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
      final response = await dioClient.get(
          'rest/s1/growerp/100/Products', apiKey ?? null,
          queryParameters: <String, dynamic>{
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
      return getResponseList<Product>(
          "products", response, (json) => Product.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Product>> createProduct(Product product) async {
    // no productId is add
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/Product', apiKey!, data: <String, dynamic>{
        'product': jsonEncode(product.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<Product>(
          "product", response, (json) => Product.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Product>> updateProduct(Product product) async {
    // no productId is add
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Product', apiKey!, data: <String, dynamic>{
        'product': jsonEncode(product.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<Product>(
          "product", response, (json) => Product.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Product>> deleteProduct(Product product) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/Product', apiKey!,
          queryParameters: <String, dynamic>{
            'product': jsonEncode(product.toJson()),
          });
      return getResponse<Product>(
          "product", response, (json) => Product.fromJson(json));
    } on Exception catch (e) {
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
      final response = await dioClient.get('rest/s1/growerp/100/Asset', apiKey!,
          queryParameters: <String, dynamic>{
            'companyPartyId': companyPartyId,
            'assetId': assetId,
            'assetClassId': assetClassId,
            'productId': productId,
            'start': start,
            'limit': limit,
            'filter': filter,
            'search': searchString
          });
      return getResponseList<Asset>(
          "assets", response, (json) => Asset.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Asset>> createAsset(Asset asset) async {
    try {
      final response = await dioClient
          .post('rest/s1/growerp/100/Asset', apiKey!, data: <String, dynamic>{
        'asset': jsonEncode(asset.toJson()),
        'classificationId': classificationId,
        'moquiSessionToken': sessionToken
      });
      return getResponse<Asset>(
          "asset", response, (json) => Asset.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Asset>> updateAsset(Asset asset) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Asset', apiKey!, data: <String, dynamic>{
        'asset': jsonEncode(asset.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<Asset>(
          "asset", response, (json) => Asset.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Asset>> deleteAsset(Asset asset) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/Asset', apiKey!,
          queryParameters: <String, dynamic>{
            'asset': jsonEncode(asset.toJson()),
          });
      return getResponse<Asset>(
          "asset", response, (json) => Asset.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Opportunity>>> getOpportunity({
    int? start,
    int? limit,
    String? opportunityId,
    bool? my,
    String? searchString,
  }) async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/Opportunity', apiKey!,
          queryParameters: <String, dynamic>{
            'opportunityId': opportunityId,
            'start': start,
            'limit': limit,
            'my': my.toString(),
            'search': searchString
          });
      return getResponseList<Opportunity>(
          "opportunities", response, (json) => Opportunity.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Opportunity>> createOpportunity(
      Opportunity opportunity) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/Opportunity', apiKey!,
          data: <String, dynamic>{
            'opportunity': jsonEncode(opportunity.toJson()),
            'moquiSessionToken': sessionToken
          });
      return getResponse<Opportunity>(
          "opportunity", response, (json) => Opportunity.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Opportunity>> updateOpportunity(
      Opportunity opportunity) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Opportunity', apiKey!,
          data: <String, dynamic>{
            'opportunity': jsonEncode(opportunity.toJson()),
            'moquiSessionToken': sessionToken
          });
      return getResponse<Opportunity>(
          "opportunity", response, (json) => Opportunity.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Opportunity>> deleteOpportunity(
      Opportunity opportunity) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/Opportunity', apiKey!,
          queryParameters: <String, dynamic>{
            'opportunity': jsonEncode(opportunity.toJson()),
          });
      return getResponse<Opportunity>(
          "opportunity", response, (json) => Opportunity.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<GlAccount>>> getGlAccount() async {
    try {
      final response =
          await dioClient.get('rest/s1/growerp/100/Ledger', apiKey!);
      return getResponseList<GlAccount>(
          "glAccountList", response, (json) => GlAccount.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<ChatRoom>>> getChatRooms(
      {int? start,
      int? limit,
      String? chatRoomName,
      String? userId,
      bool? isPrivate,
      String? searchString,
      String? filter}) async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/ChatRoom', apiKey!,
          queryParameters: <String, dynamic>{
            'chatRoomName': chatRoomName,
            'userId': userId,
            'start': start,
            'limit': limit,
            'isPrivate': isPrivate,
            'search': searchString,
            'filter': filter,
          });
      return getResponseList<ChatRoom>(
          "chatRooms", response, (json) => ChatRoom.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ChatRoom>> getChatRoom({
    required String? chatRoomId,
  }) async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/ChatRoom', apiKey!,
          queryParameters: <String, dynamic>{
            'chatRoomId': chatRoomId,
          });
      return getResponse<ChatRoom>(
          "chatRoom", response, (json) => ChatRoom.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ChatRoom>> updateChatRoom(ChatRoom chatRoom) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/ChatRoom', apiKey!, data: <String, dynamic>{
        'chatRoom': jsonEncode(chatRoom.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<ChatRoom>(
          "chatRoom", response, (json) => ChatRoom.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ChatRoom>> createChatRoom(ChatRoom chatRoom) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/ChatRoom', apiKey!, data: <String, dynamic>{
        'chatRoom': jsonEncode(chatRoom.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<ChatRoom>(
          "chatRoom", response, (json) => ChatRoom.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ChatRoom>> deleteChatRoom(String chatRoomId) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/ChatRoom', apiKey!,
          queryParameters: <String, dynamic>{'chatRoomId': chatRoomId});
      //    return response.data["chatRoomId"];
      return getResponse<ChatRoom>(
          "chatRoom", response, (json) => ChatRoom.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<ChatMessage>>> getChatMessages(
      {String? chatRoomId,
      int? start,
      int? limit,
      String? searchString}) async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/ChatMessage', apiKey!,
          queryParameters: <String, dynamic>{
            'chatRoomId': chatRoomId,
            'start': start,
            'limit': limit,
            'search': searchString,
          });
      return getResponseList<ChatMessage>(
          "chatMessages", response, (json) => ChatMessage.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Task>>> getTask({
    int? start,
    int? limit,
    String? taskId,
    bool? open,
    String? searchString,
  }) async {
    try {
      final response = await dioClient.get('rest/s1/growerp/100/Task', apiKey!,
          queryParameters: <String, dynamic>{
            'taskId': taskId,
            'start': start,
            'limit': limit,
            'open': open.toString(),
            'search': searchString
          });
      return getResponseList<Task>(
          "tasks", response, (json) => Task.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Task>> createTask(Task task) async {
    try {
      final response = await dioClient.post('rest/s1/growerp/100/Task', apiKey!,
          data: <String, dynamic>{
            'task': jsonEncode(taskToJson(task)),
            'moquiSessionToken': sessionToken
          });
      return getResponse<Task>("task", response, (json) => Task.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Task>> updateTask(Task task) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Task', apiKey!, data: <String, dynamic>{
        'task': jsonEncode(taskToJson(task)),
        'moquiSessionToken': sessionToken
      });
      return getResponse<Task>("task", response, (json) => Task.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<TimeEntry>> deleteTimeEntry(TimeEntry timeEntry) async {
    try {
      final response = await dioClient.delete(
          'rest/s1/growerp/100/TimeEntry', apiKey!,
          queryParameters: <String, dynamic>{
            'timeEntry': jsonEncode(timeEntryToJson(timeEntry)),
            'moquiSessionToken': sessionToken
          });
      return getResponse<TimeEntry>(
          "timeEntry", response, (json) => TimeEntry.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<TimeEntry>> createTimeEntry(TimeEntry timeEntry) async {
    try {
      final response = await dioClient.post(
          'rest/s1/growerp/100/TimeEntry', apiKey!,
          data: <String, dynamic>{
            'timeEntry': jsonEncode(timeEntryToJson(timeEntry)),
            'moquiSessionToken': sessionToken
          });
      return getResponse<TimeEntry>(
          "timeEntry", response, (json) => TimeEntry.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<TimeEntry>> updateTimeEntry(TimeEntry timeEntry) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/TimeEntry', apiKey!,
          data: <String, dynamic>{
            'timeEntry': jsonEncode(timeEntryToJson(timeEntry)),
            'moquiSessionToken': sessionToken
          });
      return getResponse<TimeEntry>(
          "timeEntry", response, (json) => TimeEntry.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Website>> getWebsite() async {
    try {
      final response = await dioClient.get(
          'rest/s1/growerp/100/Website', apiKey!,
          queryParameters: <String, dynamic>{
            'classificationId': classificationId
          });
      return getResponse<Website>(
          "website", response, (json) => Website.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Website>> updateWebsite(Website website) async {
    try {
      final response = await dioClient.patch(
          'rest/s1/growerp/100/Website', apiKey!, data: <String, dynamic>{
        'website': jsonEncode(website.toJson()),
        'moquiSessionToken': sessionToken
      });
      return getResponse<Website>(
          "website", response, (json) => Website.fromJson(json));
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
