import 'package:admin/main.dart';
import 'package:core/api_repository.dart';
import 'package:core/services/chat_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/domains/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('''GrowERP sales test''', (tester) async {
    setUp(() async {
      await GlobalConfiguration().loadFromAsset("app_settings");
    });

    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()));
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
