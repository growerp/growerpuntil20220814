import 'package:core/domains/domains.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'startApp.dart';
import 'package:core/domains/integration_test.dart';
import 'data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('''Opportunity test''', (tester) async {
    bool newRandom = true; // run test with new random number or not
    await startApp(tester, newRandom: newRandom);
    if (newRandom == true) {
      await AuthTest.createNewAdminAndCompany(
          tester, administrators[0], companies[0]);
      await AuthTest.login(tester, loginName, password);
      await UserTest.createUsers(tester, leads, 'dbCrm', '2');
      await UserTest.createUsers(tester, administrators, 'dbCompany', '2');
    } else
      await AuthTest.login(tester, loginName, password);
  }, skip: false);

  testWidgets('''Task test''', (tester) async {
    await startApp(tester, clear: true);
    await CommonTest.checkText(tester, 'Main');
    await TaskTest.showTaskList(tester);
    await TaskTest.createNewTask(tester, tasks[0]);
    await TaskTest.checkDataInListForDemoData(tester, tasks[0]);
    await AuthTest.gotoMainMenu(tester);
  }, skip: false);

  testWidgets('''Opportunity test''', (tester) async {
    await startApp(tester, clear: true);
    print("========== Opportunity test: create");
    await OpportunityTest.showList(tester);
    await OpportunityTest.checkListCount(tester, 0);
    await OpportunityTest.showNewDetail(tester);
    await OpportunityTest.enterDetail(tester, opportunities[0]);
    await OpportunityTest.checkList(tester, opportunities[0]);
    await OpportunityTest.showDetail(tester);
    await OpportunityTest.checkDetail(tester, opportunities[0]);
    await OpportunityTest.closeDetail(tester);
    await OpportunityTest.checkListCount(tester, 1);
    await AuthTest.logout(tester);
    print("========== Opportunity test: modify");
    await AuthTest.login(tester, loginName, password);
    await OpportunityTest.showList(tester);
    await OpportunityTest.showDetail(tester);
    await OpportunityTest.checkDetail(tester, opportunities[0]);
    await OpportunityTest.enterDetail(tester, opportunities[1]);
    await OpportunityTest.checkList(tester, opportunities[1]);
    await OpportunityTest.showDetail(tester);
    await OpportunityTest.checkDetail(tester, opportunities[1]);
    await OpportunityTest.closeDetail(tester);
    await AuthTest.logout(tester);
    print("========== Opportunity test: delete");
    await AuthTest.login(tester, loginName, password);
    await OpportunityTest.showList(tester);
    await OpportunityTest.checkList(tester, opportunities[1]);
    await OpportunityTest.showDetail(tester);
    await OpportunityTest.checkDetail(tester, opportunities[1]);
    await OpportunityTest.closeDetail(tester);
    await OpportunityTest.delete(tester);
    await OpportunityTest.checkListCount(tester, 0);
    await AuthTest.logout(tester);
    print("========== Opportunity test: completed");
  }, skip: false);

  testWidgets('''Business Purchase test''', (tester) async {
    await startApp(tester, clear: true); //clear test data = recreate data
    await CommonTest.login(tester, loginName, password);
    await OrderTest.selectPurchaseOrder(tester);
    await OrderTest.createPurchaseOrder(tester, purchaseOrders);
    await OrderTest.checkPurchaseOrder(tester);
    await OrderTest.sendPurchaseOrder(tester, purchaseOrders);
    await WarehouseTest.selectIncomingShipments(tester);
    await WarehouseTest.checkIncomingShipments(tester);
    await WarehouseTest.acceptInWarehouse(tester);
    await AccountingTest.selectPurchaseInvoices(tester);
    await AccountingTest.checkPurchaseInvoices(tester);
    await AccountingTest.approvePurchaseInvoices(tester);
    await AccountingTest.selectPurchasePayments(tester);
    await AccountingTest.checkPurchasePayments(tester);
    await AccountingTest.selectTransactions(tester);
    await AccountingTest.checkTransactions(tester);
/*
    await WarehouseTest.checkWarehouseQOH(tester, purchaseOrders);
    await OrderTest.checkOrderCompleted(tester, purchaseOrders);
    await AccountingTest.checkAccountingComplete(tester, purchaseOrders);
    await CommonTest.logout(tester);
*/
  }, skip: false);
}

String loginName = 'admin';
String password = '!kdQ9QT5sjA4';

List<FinDoc> purchaseOrders = [
  FinDoc(
      sales: false,
      docType: 'order',
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
      docType: 'order',
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
      docType: 'order',
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
      docType: 'order',
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
  Location(locationName: "For purchase order 0"),
  Location(locationName: "For purchase order 1"),
  Location(locationName: "For purchase order 2"),
  Location(locationName: "For purchase order 3"),
];
