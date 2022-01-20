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
  name: "MainCompany",
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
  Company(
      name: 'companyName', currency: Currency(description: 'Baht')), // owner
  Company(name: 'companyName1', currency: Currency(description: 'Euro')),
  Company(name: 'companyName2', currency: Currency(description: 'Dollar')),
  Company(name: 'companyName3', currency: Currency(description: 'Euro')),
  Company(name: 'companyName4', currency: Currency(description: 'USD')),
  Company(name: 'companyName5', currency: Currency(description: 'Euro')),
  Company(name: 'companyName6', currency: Currency(description: 'USD')),
  Company(name: 'companyName7', currency: Currency(description: 'Euro')),
  Company(name: 'companyName8', currency: Currency(description: 'USD')),
];

List<User> administrators = [
  User(
    firstName: 'administrator1',
    lastName: 'last Name',
    userGroup: UserGroup.Admin,
    companyName: companies[0].name,
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'administrator2',
    lastName: 'last Name',
    userGroup: UserGroup.Admin,
    companyName: companies[0].name,
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'administrator3',
    lastName: 'last Name',
    userGroup: UserGroup.Admin,
    companyName: companies[0].name,
    email: 'email${seq++}@example.org',
  ),
];
List<User> employees = [
  User(
    firstName: 'employee1',
    lastName: 'last Name',
    userGroup: UserGroup.Employee,
    companyName: companies[0].name,
    userId: 'username${seq++}',
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'employee2',
    lastName: 'last Name',
    userGroup: UserGroup.Employee,
    companyName: companies[0].name,
    email: 'email${seq++}@example.org',
  )
];

List<User> leads = [
  User(
    firstName: 'lead1',
    lastName: 'last Name',
    userGroup: UserGroup.Lead,
    companyName: companies[5].name,
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'lead2',
    lastName: 'last Name',
    userGroup: UserGroup.Lead,
    companyName: companies[6].name,
    email: 'email${seq++}@example.org',
  )
];

List<User> suppliers = [
  User(
    firstName: 'supplier1',
    lastName: 'last Name',
    userGroup: UserGroup.Supplier,
    companyName: companies[7].name,
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'supplier2',
    lastName: 'last Name',
    userGroup: UserGroup.Supplier,
    companyName: companies[8].name,
    email: 'email${seq++}@example.org',
  )
];
List<User> customers = [
  User(
    firstName: 'customer1',
    lastName: 'last Name',
    userGroup: UserGroup.Customer,
    companyName: companies[7].name,
    email: 'email${seq++}@example.org',
  ),
  User(
    firstName: 'customer2',
    lastName: 'last Name',
    userGroup: UserGroup.Customer,
    companyName: companies[8].name,
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
      categoryName: 'FirstCategory1',
      description: 'FirstCategory1 description',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits)),
  Category(
      categoryName: 'FirstCategory2',
      description: 'FirstCategory2 description',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits)),
];

List<Product> products = [
  Product(
      productName: 'This is the first product 1',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits),
      price: Decimal.parse('23.99'),
      category: categories[0],
      description: 'This is a dummy description of first product 1'),
  Product(
      productName: 'This is the second product 2',
      image: Uint8List.fromList('R0lGODlhAQABAAAAACwAAAAAAQABAAA='.codeUnits),
      price: Decimal.parse('73.99'),
      category: categories[1],
      description: 'This is a dummy description of second product 1'),
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
      otherUser: User(companyName: 'achilles'),
      items: [
        FinDocItem(
            description: '30 mil pvc',
            quantity: Decimal.parse('20400'),
            price: Decimal.parse('0.21'))
      ]),
  FinDoc(
      sales: false,
      docType: FinDocType.order,
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
      docType: FinDocType.order,
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
      docType: FinDocType.order,
      description: 'The fourth order',
      otherUser: User(companyName: 'MELCO LININGS'),
      items: [
        FinDocItem(
            description: '6" 90 deg. PVC',
            quantity: Decimal.parse('40'),
            price: Decimal.parse('10'))
      ]),
];

List<FinDoc> salesOrders = [
  FinDoc(
      sales: false,
      docType: FinDocType.order,
      description: 'The first order',
      otherUser: User(companyName: 'Thompson Construction'),
      items: [
        FinDocItem(
          description: products[0].productName,
          price: products[0].price,
          quantity: Decimal.parse('27069'),
        ),
        FinDocItem(
          description: products[1].productName,
          price: products[1].price,
          quantity: Decimal.parse('4'),
        ),
        FinDocItem(
          description: products[2].productName,
          price: products[2].price,
          quantity: Decimal.parse('8'),
        ),
        FinDocItem(
          description: products[3].productName,
          price: products[3].price,
          quantity: Decimal.parse('9'),
        )
      ]),
];

List<Location> warehouseLocations = [
  Location(locationName: 'For purchase order 0'),
  Location(locationName: 'For purchase order 1'),
  Location(locationName: 'For purchase order 2'),
  Location(locationName: 'For purchase order 3'),
];
