import 'package:admin/main.dart';
import 'package:core/api_repository.dart';
import 'package:core/domains/common/functions/persist_functions.dart';
import 'package:core/domains/domains.dart';
import 'package:core/services/chat_server.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/domains/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('''GrowERP sales test''', (tester) async {
    await startApp(tester, clear: true); //clear test data = recreate data
    await CommonTest.login(tester);
    await OrderTest.selectSalesOrders(tester);
    await OrderTest.createSalesOrder(tester, salesOrders);
    await OrderTest.checkSalesOrder(tester);
    await OrderTest.approveSalesOrder(tester, salesOrders);
    await WarehouseTest.selectOutgoingShipments(tester);
    await WarehouseTest.sendOutGoingShipments(tester);
    await AccountingTest.selectSalesInvoices(tester);
    await AccountingTest.checkSalesInvoices(tester);
    await AccountingTest.sendSalesInvoices(tester);
    await OrderTest.selectSalesOrders(tester);
    await OrderTest.checkOrderCompleted(tester);
    await AccountingTest.selectSalesPayments(tester);
    await AccountingTest.checkSalesPayments(tester);
    await AccountingTest.selectTransactions(tester);
    await AccountingTest.checkTransactions(tester);
    await AccountingTest.selectSalesPayments(tester);
    // confirm sales payment received
    await AccountingTest.receiveCustomerPayment(tester);
    // check sales payment complete
    await AccountingTest.checkSalesPaymentsComplete(tester);
    // check sales invoice complete
    await AccountingTest.selectSalesInvoices(tester);
    await AccountingTest.checkSalesInvoicesComplete(tester);
    await CommonTest.logout(tester);
  }, skip: false);
}

String loginName = 'test@example.com';
String password = 'qqqqqq9!';

List<Product> products = [
  Product(
      productName: '30 mil pvc',
      price: Decimal.parse('0.267'),
      useWarehouse: true),
  Product(
      productName: 'ADHESIVE #66 - GALLON',
      price: Decimal.parse('49.00'),
      useWarehouse: true),
  Product(
      productName: '8" 90 deg.',
      price: Decimal.parse('35'),
      useWarehouse: true),
  Product(
      productName: '6" 90 deg.',
      price: Decimal.parse('35'),
      useWarehouse: true),
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
  Location(locationName: "For purchase order 0"),
  Location(locationName: "For purchase order 1"),
  Location(locationName: "For purchase order 2"),
  Location(locationName: "For purchase order 3"),
];

Future<void> startApp(WidgetTester tester,
    {bool newRandom = true, bool clear = true}) async {
  if (clear) {
    await PersistFunctions.removeFindocList();
  }
  await GlobalConfiguration().loadFromAsset("app_settings");

  await tester
      .pumpWidget(TopApp(dbServer: APIRepository(), chatServer: ChatServer()));

  await tester.pumpAndSettle(const Duration(seconds: 2));
  await tester.pumpAndSettle(const Duration(seconds: 5));
}
