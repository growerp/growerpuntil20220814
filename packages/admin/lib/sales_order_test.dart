import 'package:admin/main.dart';
import 'package:core/api_repository.dart';
import 'package:core/services/chat_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/domains/integration_test.dart';

// uses data from create purchase order, run that one first

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
  });

  testWidgets('''GrowERP sales test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()));
    await CommonTest.login(tester);
    await UserTest.selectCustomers(tester);
    await UserTest.addCustomers(tester, [customers[0]], check: false);
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
