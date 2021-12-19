/*
 * This software is in the public domain under CC0 1.0 Universal plus a
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

import 'dart:math';
import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:core/domains/domains.dart';

String random = Random.secure().nextInt(1024).toString();
String seq = '$random';
String seq1 = '$random-1';
String seq2 = '$random-2';
String seq3 = '$random-3';
String seq4 = '$random-4';
String seq5 = '$random-5';
String seq6 = '$random-6';
String seq7 = '$random-7';
String seq8 = '$random-8';

String loginName = 'admin';
String password = '!kdQ9QT5sjA4';

List<Company> companies = [
  Company(
      name: 'companyName$seq',
      currency: Currency(description: 'Baht')), // owner
  Company(name: 'companyName$seq1', currency: Currency(description: 'Euro')),
  Company(name: 'companyName$seq2', currency: Currency(description: 'Dollar')),
  Company(name: 'companyName$seq3', currency: Currency(description: 'Euro')),
  Company(name: 'companyName$seq4', currency: Currency(description: 'USD')),
  Company(name: 'companyName$seq5', currency: Currency(description: 'Euro')),
  Company(name: 'companyName$seq6', currency: Currency(description: 'USD')),
  Company(name: 'companyName$seq7', currency: Currency(description: 'Euro')),
  Company(name: 'companyName$seq8', currency: Currency(description: 'USD')),
];

List<User> administrators = [
  User(
    firstName: 'administrator$seq',
    lastName: 'login Name',
    userGroup: UserGroup.SuperAdmin,
    companyName: companies[0].name,
    userId: 'username$seq',
    email: 'email$seq@example.org',
  ),
  User(
    firstName: 'administrator$seq1',
    lastName: 'last Name',
    userGroup: UserGroup.SuperAdmin,
    companyName: companies[0].name,
    userId: 'username$seq1',
    email: 'email$seq1@example.org',
  ),
  User(
    firstName: 'administrator$seq2',
    lastName: 'last Name',
    userGroup: UserGroup.SuperAdmin,
    companyName: companies[0].name,
    userId: 'username$seq2',
    email: 'email$seq2@example.org',
  ),
];
List<User> employees = [
  User(
    firstName: 'employee$seq3',
    lastName: 'last Name',
    userGroup: UserGroup.Employee,
    companyName: companies[0].name,
    userId: 'username$seq3',
    email: 'email$seq3@example.org',
  ),
  User(
    firstName: 'employee$seq4',
    lastName: 'last Name',
    userGroup: UserGroup.Employee,
    companyName: companies[0].name,
    userId: 'username$seq4',
    email: 'email$seq4@example.org',
  )
];

List<User> leads = [
  User(
    firstName: 'lead$seq5',
    lastName: 'last Name',
    userGroup: UserGroup.Lead,
    companyName: companies[5].name,
    userId: 'username$seq5',
    email: 'email$seq5@example.org',
  ),
  User(
    firstName: 'lead$seq6',
    lastName: 'last Name',
    userGroup: UserGroup.Lead,
    companyName: companies[6].name,
    userId: 'username$seq6',
    email: 'email$seq6@example.org',
  )
];

List<User> suppliers = [
  User(
    firstName: 'supplier$seq7',
    lastName: 'last Name',
    userGroup: UserGroup.SuperAdmin,
    companyName: companies[7].name,
    userId: 'username$seq7',
    email: 'email$seq7@example.org',
  ),
  User(
    firstName: 'supplier$seq8',
    lastName: 'last Name',
    userGroup: UserGroup.SuperAdmin,
    companyName: companies[8].name,
    userId: 'username$seq8',
    email: 'email$seq8@example.org',
  )
];

List<Task> tasks = [
  Task(
    taskName: 'task$seq1',
    status: 'In Progress',
    description: 'This is the description of the task1',
    rate: Decimal.parse('22'),
    timeEntries: [],
  ),
  Task(
    taskName: 'task$seq2',
    status: 'In Progress',
    description: 'This is the description of the task2',
    rate: Decimal.parse('23'),
    timeEntries: [],
  )
];

List<TimeEntry> timeEntries = [
  TimeEntry(
      hours: Decimal.parse('4'),
      date: DateTime.now().subtract(Duration(days: 4))),
  TimeEntry(
      hours: Decimal.parse('3'),
      date: DateTime.now().subtract(Duration(days: 3))),
  TimeEntry(
      hours: Decimal.parse('2'),
      date: DateTime.now().subtract(Duration(days: 2)))
];

List<Opportunity> opportunities = [
  Opportunity(
    opportunityName: 'Dummy Opp Name $seq1',
    description: 'Dummmy descr 1',
    stageId: 'Qualification',
    nextStep: 'testing1',
    employeeUser: administrators[0], // initial logged admin[0]
    leadUser: leads[0],
    estAmount: Decimal.parse('30000'),
    estProbability: int.parse('30'),
  ),
  Opportunity(
    opportunityName: 'Dummy Opp Name $seq2',
    description: 'Dummmy descr2',
    stageId: 'Prospecting',
    nextStep: 'testing2',
    employeeUser: administrators[1],
    leadUser: leads[1],
    estAmount: Decimal.parse('40000'),
    estProbability: int.parse('40'),
  )
];

List<Category> categories = [
  Category(
      categoryName: 'FirstCategory$seq1',
      description: 'FirstCategory$seq1 description',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits)),
  Category(
      categoryName: 'FirstCategory$seq2',
      description: 'FirstCategory$seq2 description',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits)),
];

List<Product> products = [
  Product(
      productName: 'This is the first product $seq1',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits),
      price: Decimal.parse('23.99'),
      category: categories[0],
      description: 'This is a dummy description of first product $seq1'),
  Product(
      productName: 'This is the second product $seq2',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits),
      price: Decimal.parse('73.99'),
      category: categories[1],
      description: 'This is a dummy description of second product $seq1'),
];

List<ItemType> salesItems = [
  ItemType(itemTypeId: 'slstype1', itemTypeName: 'slstype 1 description'),
  ItemType(itemTypeId: 'slstype2', itemTypeName: 'slstype 2 description'),
  ItemType(itemTypeId: 'slstype3', itemTypeName: 'slstype 3 description')
];
List<ItemType> purchaseItems = [
  ItemType(itemTypeId: 'purchtype1', itemTypeName: 'purchtype 1 description'),
  ItemType(itemTypeId: 'purchtype2', itemTypeName: 'purchtype 2 description'),
  ItemType(itemTypeId: 'purchtype3', itemTypeName: 'purchtype 3 description')
];

final FinDoc finDoc = finDocFromJson('''
  { "finDoc":
    { "orderId": null, "sales": "true", "docType": "invoice", 
      "statusId": "FinDocCompleted", 
      "placedDate": "2012-02-27 13:27:00.123456z",
      "otherUser": { "partyId": "dummy"},
      "grandTotal": "44.53",
      "items": [
        { "itemSeqId": "01", "productId": null, "description": "Cola",
          "quantity": "5", "price": "1.5" , "deliveryDate": "2012-02-27 13:27:00.123456z"},
        { "itemSeqId": "02", "productId": null, "description": "Macaroni",
          "quantity": "3", "price": "4.5", "deliveryDate": null} 
   ]}}
''');

final List<FinDoc> finDocs = finDocsFromJson('''
  { "finDocs": [
    { "invoiceId": "00002", "statusId": "OrderOpen", "sales": "true",
      "placedDate": "2012-02-27 13:27:00.123456z",
      "otherUser": { "partyId": "dummy"},
      "grandTotal": "44.53",
      "items": [
        { "itemSeqId": "01", "productId": null, "description": "Cola",
          "quantity": "5", "price": "1.5", "deliveryDate": null},
        { "itemSeqId": "02", "productId": null, "description": "Macaroni",
          "quantity": "3", "price": "4.5", "deliveryDate": null}
      ]},
    { "paymentId": "00003", "statusId": "OrderOpen", "sales": "false",
      "placedDate": "2012-02-27 13:27:00.123456z",
      "otherUser": { "partyId": "dummy"},
      "grandTotal": "44.53", 
      "items": [
        { "itemSeqId": "01", "productId": null, "description": "Cola",
          "quantity": "5", "price": "1.5", "deliveryDate": null},
        { "itemSeqId": "02", "productId": null, "description": "Macaroni",
          "quantity": "3", "price": "4.5", "deliveryDate": null}
      ]}
   ]}
''');

List<FinDoc> purchaseOrders = [
  FinDoc(
      sales: false,
      docType: FinDocType.Order,
      description: 'The first order',
      otherUser: User(companyName: 'achilles'),
      items: [
        FinDocItem(
            description: '30 mil pvc',
            quantity: Decimal.parse('20400'),
            price: Decimal.parse('0.21'))
      ]),
  FinDoc(
      sales: false,
      docType: FinDocType.Order,
      description: 'The second order',
      otherUser: User(companyName: 'ips corp'),
      items: [
        FinDocItem(
            description: 'ADHESIVE #66 - GALLON',
            quantity: Decimal.parse('108'),
            price: Decimal.parse('39.0042'))
      ]),
  FinDoc(
      sales: false,
      docType: FinDocType.Order,
      description: 'The third order',
      otherUser: User(companyName: 'core & main'),
      items: [
        FinDocItem(
            description: '8" 90 deg. PVC',
            quantity: Decimal.parse('40'),
            price: Decimal.parse('30'))
      ]),
  FinDoc(
      sales: false,
      docType: FinDocType.Order,
      description: 'The fourth order',
      otherUser: User(companyName: 'MELCO LININGS'),
      items: [
        FinDocItem(
            description: '6" 90 deg. PVC',
            quantity: Decimal.parse('40'),
            price: Decimal.parse('10'))
      ]),
];

List<Location> warehouseLocations = [
  Location(locationName: 'For purchase order 0'),
  Location(locationName: 'For purchase order 1'),
  Location(locationName: 'For purchase order 2'),
  Location(locationName: 'For purchase order 3'),
];
