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

  testWidgets('''GrowERP Purchase test''', (tester) async {
    await startApp(tester, clear: true); //clear test data = recreate data
    await CommonTest.login(tester);
    await OrderTest.selectPurchaseOrders(tester);
    await OrderTest.createPurchaseOrder(tester, purchaseOrders);
    await OrderTest.checkPurchaseOrder(tester);
    await OrderTest.sendPurchaseOrder(tester, purchaseOrders);
    await WarehouseTest.selectIncomingShipments(tester);
    await WarehouseTest.checkIncomingShipments(tester);
    await WarehouseTest.acceptShipmentInWarehouse(tester);
    await WarehouseTest.selectWareHouseLocations(tester);
    await WarehouseTest.checkWarehouseQOH(tester);
    await AccountingTest.selectPurchaseInvoices(tester);
    await AccountingTest.checkPurchaseInvoices(tester);
    await AccountingTest.approvePurchaseInvoices(tester);
    await AccountingTest.selectPurchasePayments(tester);
    await AccountingTest.checkPurchasePayments(tester);
    await AccountingTest.selectTransactions(tester);
    await AccountingTest.checkTransactions(tester);
    await OrderTest.selectPurchaseOrders(tester);
    await OrderTest.checkOrderCompleted(tester);
    await AccountingTest.selectPurchasePayments(tester);
    // confirm purchase payment paid
    await AccountingTest.payPurchasePayment(tester);
    // check purchase payment complete
    await AccountingTest.selectPurchasePayments(tester);
    await AccountingTest.checkPurchasePaymentsComplete(tester);
    // check purchase invoice complete
    await AccountingTest.selectPurchaseInvoices(tester);
    await AccountingTest.checkPurchaseInvoicesComplete(tester);
    // check purchase orders complete
    await OrderTest.selectPurchaseOrders(tester);
    await OrderTest.checkPurchaseOrdersComplete(tester);
    await CommonTest.logout(tester);
  }, skip: false);
}

String loginName = 'test@example.com';
String password = 'qqqqqq9!';

List<Product> products = [
  Product(
      productName: '30 mil pvc',
      price: Decimal.parse('0.21'),
      useWarehouse: true),
  Product(
      productName: 'ADHESIVE #66 - GALLON',
      price: Decimal.parse('39.0042'),
      useWarehouse: true),
  Product(
      productName: '8" 90 deg.',
      price: Decimal.parse('30'),
      useWarehouse: true),
  Product(
      productName: '6" 90 deg.',
      price: Decimal.parse('10'),
      useWarehouse: true),
];

List<FinDoc> purchaseOrders = [
  FinDoc(
      sales: false,
      docType: FinDocType.order,
      description: 'The first order',
      otherUser: User(companyName: 'achilles'),
      items: [
        FinDocItem(
          description: products[0].productName,
          price: products[0].price,
          quantity: Decimal.parse('270690'),
        )
      ]),
  FinDoc(
      sales: false,
      docType: FinDocType.order,
      description: 'The second order',
      otherUser: User(companyName: 'ips corp'),
      items: [
        FinDocItem(
          description: products[1].productName,
          price: products[1].price,
          quantity: Decimal.parse('40'),
        )
      ]),
  FinDoc(
      sales: false,
      docType: FinDocType.order,
      description: 'The third order',
      otherUser: User(companyName: 'core & main'),
      items: [
        FinDocItem(
          description: products[2].productName,
          price: products[2].price,
          quantity: Decimal.parse('80'),
        )
      ]),
  FinDoc(
      sales: false,
      docType: FinDocType.order,
      description: 'The fourth order',
      otherUser: User(companyName: 'MELCO LININGS'),
      items: [
        FinDocItem(
          description: products[3].productName,
          price: products[3].price,
          quantity: Decimal.parse('90'),
        )
      ]),
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
