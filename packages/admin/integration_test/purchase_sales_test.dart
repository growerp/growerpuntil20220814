import 'package:admin/main.dart';
import 'package:core/api_repository.dart';
import 'package:core/domains/integration_test.dart';
import 'package:core/services/chat_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
  });

  testWidgets('''GrowERP Purchase test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);
    await CompanyTest.createCompany(tester);
    await CategoryTest.selectCategories(tester);
    await CategoryTest.addCategories(tester, [categories[0], categories[1]],
        check: false);
    await ProductTest.selectProducts(tester);
    await ProductTest.addProducts(tester, [products[0], products[1]],
        check: false);
    await UserTest.selectSuppliers(tester);
    await UserTest.addSuppliers(tester, [suppliers[0], suppliers[1]],
        check: false);
    await OrderTest.selectPurchaseOrders(tester);
    await OrderTest.createPurchaseOrder(tester, purchaseOrders);
    await OrderTest.checkPurchaseOrder(tester);
    await OrderTest.sendPurchaseOrder(tester, purchaseOrders);
    await WarehouseTest.selectIncomingShipments(tester);
    await WarehouseTest.checkIncomingShipments(tester);
    await WarehouseTest.acceptShipmentInWarehouse(tester);
    await WarehouseTest.selectWareHouseLocations(tester);
    await WarehouseTest.checkWarehouseQOH(tester);
    await InvoiceTest.selectPurchaseInvoices(tester);
    await InvoiceTest.checkInvoices(tester);
    await InvoiceTest.sendOrApproveInvoices(tester);
    await PaymentTest.selectPurchasePayments(tester);
    await PaymentTest.checkPayments(tester);
    await TransactionTest.selectTransactions(tester);
    await TransactionTest.checkTransactionComplete(tester);
    await OrderTest.selectPurchaseOrders(tester);
    await OrderTest.checkOrderCompleted(tester);
    await PaymentTest.selectPurchasePayments(tester);
    // confirm purchase payment paid
    await PaymentTest.sendReceivePayment(tester);
    // check purchase payment complete
    await PaymentTest.selectPurchasePayments(tester);
    await PaymentTest.checkPaymentComplete(tester);
    // check purchase invoice complete
    await InvoiceTest.selectPurchaseInvoices(tester);
    await InvoiceTest.checkInvoicesComplete(tester);
    // check purchase orders complete
    await OrderTest.selectPurchaseOrders(tester);
    await OrderTest.checkPurchaseOrdersComplete(tester);
  });

  testWidgets('''GrowERP sales test''', (tester) async {
    // no clear because dependend on purchase test
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()));
    await CommonTest.login(tester);
    await UserTest.selectCustomers(tester);
    await UserTest.addCustomers(tester, [customers[0]], check: false);
    await OrderTest.selectSalesOrders(tester);
    await OrderTest.createSalesOrder(tester, salesOrders);
    await OrderTest.checkSalesOrder(tester);
    await OrderTest.approveSalesOrder(tester);
    await WarehouseTest.selectOutgoingShipments(tester);
    await WarehouseTest.sendOutGoingShipments(tester);
    await InvoiceTest.selectSalesInvoices(tester);
    await InvoiceTest.checkInvoices(tester);
    await InvoiceTest.sendOrApproveInvoices(tester);
    await OrderTest.selectSalesOrders(tester);
    await OrderTest.checkOrderCompleted(tester);
    await PaymentTest.selectSalesPayments(tester);
    await PaymentTest.checkPayments(tester);
    await TransactionTest.selectTransactions(tester);
    await TransactionTest.checkTransactionComplete(tester);
    await PaymentTest.selectSalesPayments(tester);
    // confirm sales payment received
    await PaymentTest.sendReceivePayment(tester);
    // check sales payment complete
    await PaymentTest.checkPaymentComplete(tester);
    // check sales invoice complete
    await InvoiceTest.selectSalesInvoices(tester);
    await InvoiceTest.checkInvoicesComplete(tester);
    await CommonTest.logout(tester);
  });
}
