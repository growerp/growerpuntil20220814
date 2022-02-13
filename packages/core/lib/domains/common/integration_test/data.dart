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

import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:core/domains/domains.dart';

int seq = 0;

Company company = Company(
  name: "Main Company",
  currency: currencies[0],
  salesPerc: Decimal.parse("5"),
  vatPerc: Decimal.parse("20"),
  address: Address(
      address1: 'mountain Ally 223',
      address2: 'suite 23',
      postalCode: '90210',
      city: 'Los Angeles',
      province: 'California',
      country: countries[0].name),
);

User admin = User(
  firstName: "John",
  lastName: "Doe",
  email: "test${seq++}@example.com",
  userGroup: UserGroup.Admin,
);

List<Company> companies = [
  Company(name: 'companyName0', currency: Currency(description: 'Baht')),
  Company(name: 'companyName1', currency: Currency(description: 'Euro')),
  Company(name: 'companyName2', currency: Currency(description: 'Dollar')),
  Company(name: 'companyName3', currency: Currency(description: 'Euro')),
  Company(name: 'companyName4', currency: Currency(description: 'USD')),
  Company(name: 'companyName5', currency: Currency(description: 'Euro')),
  Company(name: 'companyName6', currency: Currency(description: 'USD')),
];

List<User> administrators = [
  User(
    firstName: 'administrator1',
    lastName: 'last Name',
    userGroup: UserGroup.Admin,
    companyName: company.name,
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'administrator2',
    lastName: 'last Name',
    userGroup: UserGroup.Admin,
    companyName: company.name,
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'administrator3',
    lastName: 'last Name',
    userGroup: UserGroup.Admin,
    companyName: company.name,
    email: 'email${seq++}@example.org',
  ),
];
List<User> employees = [
  User(
    firstName: 'employee1',
    lastName: 'last Name',
    userGroup: UserGroup.Employee,
    companyName: company.name,
    userId: 'username${seq++}',
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'employee2',
    lastName: 'last Name',
    userGroup: UserGroup.Employee,
    companyName: company.name,
    email: 'email${seq++}@example.org',
  )
];

List<User> leads = [
  User(
    firstName: 'lead1',
    lastName: 'last Name 1',
    userGroup: UserGroup.Lead,
    companyName: companies[0].name,
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'lead2',
    lastName: 'last Name 2',
    userGroup: UserGroup.Lead,
    companyName: companies[1].name,
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'lead3',
    lastName: 'last Name 3',
    userGroup: UserGroup.Lead,
    companyName: companies[2].name,
    email: 'email${seq++}@example.org',
  ),
];

List<User> suppliers = [
  User(
    firstName: 'supplier1',
    lastName: 'last Name',
    userGroup: UserGroup.Supplier,
    companyName: companies[3].name,
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'supplier2',
    lastName: 'last Name',
    userGroup: UserGroup.Supplier,
    companyName: companies[4].name,
    email: 'email${seq++}@example.org',
  )
];
List<User> customers = [
  User(
    firstName: 'customer1',
    lastName: 'last Name',
    userGroup: UserGroup.Customer,
    companyName: companies[5].name,
    email: 'email${seq++}@example.org',
    companyAddress: Address(
        address1: 'soi 5',
        address2: 'suite 23',
        postalCode: '30071',
        city: 'Pucket',
        province: 'California',
        country: countries[3].name),
  ),
  User(
    firstName: 'customer2',
    lastName: 'last Name',
    userGroup: UserGroup.Customer,
    companyName: companies[6].name,
    email: 'email${seq++}@example.org',
  )
];

List<Task> tasks = [
  Task(
    taskName: 'task1',
    status: 'In Progress',
    description: 'This is the description of the task1',
    rate: Decimal.parse('22'),
    timeEntries: [],
  ),
  Task(
    taskName: 'task2',
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
    opportunityName: 'Dummy Opp Name 1',
    description: 'Dummmy descr 1',
    stageId: 'Qualification',
    nextStep: 'testing1',
    employeeUser: administrators[0], // initial logged admin[0]
    leadUser: leads[0],
    estAmount: Decimal.parse('30000'),
    estProbability: int.parse('30'),
  ),
  Opportunity(
    opportunityName: 'Dummy Opp Name 2',
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
      categoryName: 'Category1',
      description: 'Category1 description',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits)),
  Category(
      categoryName: 'Category2',
      description: 'Category2 description',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits)),
  Category(
      categoryName: 'Category3',
      description: 'Category3 description',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits)),
  Category(
      categoryName: 'Category4 to be deleted',
      description: 'Category4 description',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits)),
];

List<Product> products = [
  Product(
      productName: 'This is shipable product 1',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits),
      price: Decimal.parse('23.99'),
      category: categories[0],
      productTypeId: productTypes[0],
      description: 'This is a dummy description of first product'),
  Product(
      productName: 'This is shipable product 2',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits),
      price: Decimal.parse('73.99'),
      category: categories[1],
      productTypeId: productTypes[0],
      description: 'This is a dummy description of second product'),
  Product(
      productName: 'This is rental product 3',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits),
      price: Decimal.parse('93.99'),
      category: categories[0],
      productTypeId: productTypes[2],
      description: 'This is a dummy description of third product'),
  Product(
      productName: 'This is service product 4',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits),
      price: Decimal.parse('22.44'),
      category: categories[0],
      productTypeId: productTypes[1],
      description: 'This is the fourth product to be deleted'),
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

List<FinDoc> purchaseOrders = [
  FinDoc(
      sales: false,
      docType: FinDocType.order,
      description: 'The first order',
      otherUser: suppliers[0],
      items: [
        FinDocItem(
            description: products[0].productName,
            quantity: Decimal.parse('20'),
            price: Decimal.parse('7.21'))
      ]),
  FinDoc(
      sales: false,
      docType: FinDocType.order,
      description: 'The second order',
      otherUser: suppliers[1],
      items: [
        FinDocItem(
            description: products[1].productName,
            quantity: Decimal.parse('40'),
            price: Decimal.parse('17.21')),
      ]),
];

List<FinDoc> salesOrders = [
  FinDoc(
      sales: false,
      docType: FinDocType.order,
      description: 'The first sales order',
      otherUser: customers[0],
      items: [
        FinDocItem(
          description: products[0].productName,
          price: products[0].price,
          quantity: Decimal.parse('20'),
        ),
        FinDocItem(
          description: products[1].productName,
          price: products[1].price,
          quantity: Decimal.parse('40'),
        ),
      ]),
];

List<Location> warehouseLocations = [
  Location(locationName: 'For purchase order 0'),
  Location(locationName: 'For purchase order 1'),
  Location(locationName: 'For purchase order 2'),
  Location(locationName: 'For purchase order 3'),
];

List<Asset> assets = [
  Asset(
    assetName: 'asset name 1',
    availableToPromise: Decimal.parse('100'),
    quantityOnHand: Decimal.parse('100'),
    product: products[0],
    statusId: assetStatusValues[0],
    receivedDate: DateTime.now().subtract(Duration(days: 4)),
  ),
  Asset(
    assetName: 'asset name 2',
    availableToPromise: Decimal.parse('200'),
    quantityOnHand: Decimal.parse('200'),
    product: products[1],
    statusId: assetStatusValues[0],
    receivedDate: DateTime.now().subtract(Duration(days: 4)),
  ),
  Asset(
    assetName: 'asset name 3',
    availableToPromise: Decimal.parse('300'),
    quantityOnHand: Decimal.parse('300'),
    product: products[1],
    statusId: assetStatusValues[0],
    receivedDate: DateTime.now().subtract(Duration(days: 4)),
  ),
  Asset(
    assetName: 'asset name 4 to be deleted',
    availableToPromise: Decimal.parse('400'),
    quantityOnHand: Decimal.parse('400'),
    product: products[0],
    statusId: assetStatusValues[0],
    receivedDate: DateTime.now().subtract(Duration(days: 4)),
  ),
];
