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

  testWidgets('''GrowERP company test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);
    await CompanyTest.createCompany(tester);
    await CompanyTest.selectCompany(tester);
    await CompanyTest.updateCompany(tester);
    await CompanyTest.updateAddress(tester);
    await CompanyTest.updatePaymentMethod(tester);
  });

  testWidgets('''GrowERP category test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);
    await CompanyTest.createCompany(tester);
    await CategoryTest.selectCategory(tester);
    await CategoryTest.addCategories(tester, categories);
    await CategoryTest.updateCategories(tester);
    await CategoryTest.deleteCategories(tester);
    await CommonTest.logout(tester);
  });

  testWidgets('''GrowERP product test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);
    await CompanyTest.createCompany(tester);
    await CategoryTest.selectCategory(tester);
    await CategoryTest.addCategories(tester, [categories[0], categories[1]],
        check: false);
    await ProductTest.selectProduct(tester);
    await ProductTest.addProducts(tester, products);
    await ProductTest.updateProducts(tester);
    await ProductTest.deleteProducts(tester);
    await CommonTest.logout(tester);
  });

  testWidgets('''GrowERP asset test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);
    await CompanyTest.createCompany(tester);
    await CategoryTest.selectCategory(tester);
    await CategoryTest.addCategories(tester, [categories[0], categories[1]],
        check: false);
    await ProductTest.selectProduct(tester);
    await ProductTest.addProducts(
        tester, [products[0], products[1], products[2]],
        check: false);
    await AssetTest.selectAsset(tester);
    await AssetTest.addAssets(tester, assets);
    await AssetTest.updateAssets(tester);
    await AssetTest.deleteAssets(tester);
    await CommonTest.logout(tester);
  });

  testWidgets('''GrowERP user test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);
    await CompanyTest.createCompany(tester);
    await UserTest.selectAdministrators(tester);
    await UserTest.addAdministrators(tester, administrators);
    await UserTest.updateAdministrators(tester);
    await UserTest.deleteAdministrators(tester);
    await UserTest.selectEmployees(tester);
    await UserTest.addEmployees(tester, employees);
    await UserTest.updateEmployees(tester);
    await UserTest.deleteEmployees(tester);
    await UserTest.selectLeads(tester);
    await UserTest.addLeads(tester, leads);
    await UserTest.updateLeads(tester);
    await UserTest.deleteLeads(tester);
    await UserTest.selectCustomers(tester);
    await UserTest.addCustomers(tester, customers);
    await UserTest.updateCustomers(tester);
    await UserTest.deleteCustomers(tester);
    await UserTest.selectSuppliers(tester);
    await UserTest.addSuppliers(tester, suppliers);
    await UserTest.updateSuppliers(tester);
    await UserTest.deleteSuppliers(tester);
    await CompanyTest.updateAddress(tester);
    await CommonTest.logout(tester);
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
  });

  testWidgets('''GrowERP asset rental sales order test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);

    await CompanyTest.createCompany(tester);
    await CategoryTest.selectCategory(tester);
    await CategoryTest.addCategories(tester, [categories[0]], check: false);
    await ProductTest.selectProduct(tester);
    await ProductTest.addProducts(tester, [products[2]], check: false);
    await AssetTest.selectAsset(tester);
    await AssetTest.addAssets(tester, [assets[2]], check: false);
    await UserTest.selectCustomers(tester);
    await UserTest.addCustomers(tester, [customers[0]], check: false);
    await OrderTest.selectSalesOrders(tester);
    await OrderTest.createRentalSalesOrder(tester, rentalSalesOrders);
    await OrderTest.checkRentalSalesOrder(tester);
    await OrderTest.checkRentalSalesOrderBlocDates(tester);
    await OrderTest.approveSalesOrder(tester);
    await AccountingTest.selectSalesInvoices(tester);
    await AccountingTest.checkSalesInvoices(tester);
    await AccountingTest.sendSalesInvoices(tester);
    await OrderTest.selectSalesOrders(tester);
    await OrderTest.checkOrderCompleted(tester);
  });

  // not implemented yet, use integration_test/chat_test.dart and lib/chatEcho_main.dart
  testWidgets('''GrowERP chat test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);
    await CommonTest.login(tester);
    await UserTest.selectAdministrators(tester);
    await UserTest.addAdministrators(tester, [administrators[0]]);
    await ChatTest.selectChatRoom(tester);
    await ChatTest.addRooms(tester, chatRooms);
    await ChatTest.updateRooms(tester);
    await ChatTest.deleteRooms(tester);
    await ChatTest.sendDirectMessage(tester);
    await ChatTest.sendRoomMessage(tester);
  }, skip: true);
}
