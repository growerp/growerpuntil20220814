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

  testWidgets('''GrowERP Stripe receive payment test''', (tester) async {
    // no clear because dependend on purchase test
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);
    await CompanyTest.createCompany(tester);
    await CommonTest.login(tester);
    await CompanyTest.selectCompany(tester);
    await UserTest.selectCustomers(tester);
    await UserTest.addCustomers(tester, [customers[0]], check: false);
    await AccountingTest.selectSalesPayments(tester);
    await AccountingTest.addPayments(tester, salesPayments, check: false);
    await AccountingTest.sendReceivePayment(tester);
    await AccountingTest.checkPaymentComplete(tester);
    await AccountingTest.selectTransactions(tester);
    await AccountingTest.checkTransactions(tester);
    await CommonTest.logout(tester);
  });
}
