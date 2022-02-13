import 'package:admin/main.dart';
import 'package:core/api_repository.dart';
import 'package:core/domains/catalog/integration_test/category_test.dart';
import 'package:core/domains/catalog/integration_test/product_test.dart';
import 'package:core/services/chat_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/domains/integration_test.dart';

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
    await CategoryTest.selectCategory(tester);
    await CategoryTest.addCategories(tester, [categories[0], categories[1]],
        check: false);
    await ProductTest.selectProduct(tester);
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
