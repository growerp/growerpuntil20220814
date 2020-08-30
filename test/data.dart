import 'package:master/models/@models.dart';
import 'dart:math';

final String randomString4 = Random().nextInt(9999).toString();

User user = userFromJson('''
  {"user": {"firstName": "dummyFirstName",
            "lastName": "dummyLastName",
            "email": "dummy@example.com",
            "name": "dummyUsername",
            "image": "R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==",
            "userGroupId":"GROWERP_M_ADMIN"
            }
  }
''');
List<User> users = usersFromJson('''
  {"users": [
      { "partyId": "12345",
        "firstName": "dummyFirstName",
        "lastName": "dummyLastName",
        "email": "dummy@example.com",
        "name": "dummyUsername",
        "image": "R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==",
        "userGroupId":"GROWERP_M_ADMIN"
        },
      { "partyId": "12346",
        "firstName": "dummyFirstName",
        "lastName": "dummyLastName",
        "email": "dummy@example.com",
        "name": "dummyUsername",
        "image": "R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==",
        "userGroupId":"GROWERP_M_ADMIN"
        }
  ]}
''');

Company company = companyFromJson('''
    {  "company": {"name": "Dummy Company Name 2",
                  "partyId": "100001",
                  "currency": "dummyCurrency",
                  "classificationId": "AppEcommerceShop",
                  "classificationDescr": "App for Ecommerce and shop",
                  "email": "dummy@example.com",
      "image": "R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
      }
    }
''');
List<Company> companies = companiesFromJson('''
  {"companies": [
      {"name": "Dummy Company Name",
        "partyId": "100001",
        "currency": "dummyCurrency",
        "classificationId": "AppEcommerceShop",
        "classificationDescr": "App for Ecommerce and shop",
        "email": "dummy@example.com",
        "image": "R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
      },
      {  "name": "Dummy Company Name 2",
          "partyId": "100002",
          "currency": "dummyCurrency",
          "classificationId": "AppEcommerceShop",
          "classificationDescr": "App for Ecommerce and shop",
          "email": "dummy@example.com",
      "image": "R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
      }
  ]}
''');

Authenticate authenticateNoKey = authenticateFromJson('''
           {  "company": {"name": "Dummy Company Name",
                          "partyId": "100001",
                          "currency": "dummyCurrency",
                          "classificationId": "AppEcommerceShop",
                          "classificationDescr": "App for Ecommerce and shop",
                          "email": "dummy@example.com",
      "image": "R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
                          },
              "user": {"firstName": "dummyFirstName",
                       "lastName": "dummyLastName",
                       "email": "dummy@example.com",
                       "name": "dummyUsername",
                       "image": null,
                       "groupDescription": "Admin",
                       "userGroupId":"GROWERP_M_ADMIN"
                       },
              "apiKey": null
            }
      ''');
Authenticate authenticate = authenticateFromJson('''
           {  "company": {"name": "Dummy Company Name",
                          "partyId": "100001",
                          "currency": "dummyCurrency"
                          },
              "user": {"firstName": "dummyFirstName",
                       "lastName": "dummyLastName",
                       "email": "dummy@example.com",
                       "name": "dummyUsername",
        "image": "R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==",
                       "userGroupId":"GROWERP_M_ADMIN"
                       },
              "apiKey": "dummyKey"
            }
      ''');

final String errorMessage = 'Dummy error message';
final String screenMessage = 'Dummy screen message';
final String companyName = 'Dummy Company Name';
final String companyPartyId = '100001';
final String firstName = 'dummyFirstName';
final String lastName = 'dummyLastName';
final String username = 'dummyUsername';
final String password = 'dummyPassword9!';
final String newPassword = 'dummyNewPassword9!';
final String email = 'dummy@example.com';

Map register = {
  'username': username,
  'emailAddress': email,
  'newPassword': password,
  'firstName': firstName,
  'lastName': lastName,
  'companyName': companyName,
  'currencyId': currencyId,
  'companyEmail': email,
  'partyClassificationId': 'AppEcommerceShop',
  'environment': true, // true for production, false for debug
  'moquiSessionToken': null // need to be set when used!
};

final Catalog emptyCatalog = Catalog(categories: [], products: []);
final Catalog catalog = Catalog(categories: categories, products: products);

final Category category = categoryFromJson('''
  { "category":
      {"productCategoryId": "dummyFirstCategory", "categoryName": "1stCat",
      "description": "this is the long description of category first", 
      "image": "R0lGODlhAQABAAAAACwAAAAAAQABAAA="}
  }''');

final List<Category> categories = categoriesFromJson('''
    {
      "categories": [ 
      {"productCategoryId": "dummyFirstCategory", "categoryName": "1stCat",
      "description": "this is the long description of category first", 
      "image": "R0lGODlhAQABAAAAACwAAAAAAQABAAA="},
      {"productCategoryId": "secondCategory", "categoryName": "This is the second category",
      "description": "this is the long description of category second",
      "image": "R0lGODlhAQABAAAAACwAAAAAAQABAAA="}]
}''');
final List<Product> products = productsFromJson('''
{     "products": [
      {"productId": "dummyFirstProduct", "name": "This is the first product",
      "image": "R0lGODlhAQABAAAAACwAAAAAAQABAAA=",
      "price": "23.99", "productCategoryId": "dummyFirstCategory",
      "description": "This is a dummy description of first product"},
      {"productId": "secondProduct", "name": "This is the second product",
       "image": "R0lGODlhAQABAAAAACwAAAAAAQABAAA=",
       "price": "17.13", "productCategoryId": "dummyFirstCategory",
       "description": "This is a dummy description of second product"},
      {"productId": "thirdProduct", "name": "This is the third product",
       "image": "R0lGODlhAQABAAAAACwAAAAAAQABAAA=",
       "price": "12.33", "productCategoryId": "secondCategory",
       "description": "This is a dummy description of third product"}]
}
    ''');
final Product product = productFromJson('''
{ "product":
      {"productId": "secondProduct", "name": "This is the second product",
       "image": "R0lGODlhAQABAAAAACwAAAAAAQABAAA=",
       "price": "17.13", "productCategoryId": "dummyFirstCategory",
       "description": "This is a dummy description"}
}    ''');
final CurrencyList currencyList = currencyListFromJson('''
  { "currencyList" : ["Thailand Baht [THB]", "Euro [EUR]",
    "United States Dollar [USD]"] } ''');
final String currencyId = 'USD';
final currencies = [
  "Thailand Baht [THB]",
  "Euro [EUR]",
  "United States Dollar [USD]"
];

final Order order = orderFromJson('''
  { "orderId": null, "orderStatusId": "OrderOpen", "currencyUomId": "THB",
    "placedDate": null, "placedTime": null, "partyId": null,
    "firstName": "dummyFirstName", "lastName": "dummylastName", "statusId": "Open", 
    "grandTotal": "44.53", "table": null, "accommodationAreaId": null,
    "accommodationSpotId": null,
  "orderItems": [
  { "orderItemSeqId": "01", "productId": null, "description": "Cola",
    "quantity": "5", "price": "1.5"},
  { "orderItemSeqId": "02", "productId": null, "description": "Macaroni",
    "quantity": "3", "price": "4.5"}
   ]}
''');
final Order emptyOrder = Order(currencyId: 'THB', orderItems: []);
final OrderItem orderItem1 = OrderItem(
    productId: "dummyFirstProduct",
    description: "This is the first product",
    quantity: 5,
    price: 3.3);
final OrderItem orderItem2 = OrderItem(
    productId: "dummySecondProduct",
    description: "This is the second product",
    quantity: 3,
    price: 2.2);
final Order totalOrder =
    Order(currencyId: 'THB', orderItems: [orderItem1, orderItem2]);
