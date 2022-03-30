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

  testWidgets('''GrowERP Stripe test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: false);
/*    await CompanyTest.createCompany(tester);
    if (company.address != null) {
      await CompanyTest.selectCompany(tester);
      await CommonTest.updateAddress(tester, company.address!);
      await CommonTest.updatePaymentMethod(tester, company.paymentMethod!);
    }
    await UserTest.selectSuppliers(tester);
    await UserTest.addSuppliers(tester, [suppliers[0]], check: false);
*/
    await AccountingTest.selectPurchasePayments(tester);
    await AccountingTest.addPayments(tester, purchasePayments, check: false);
    await AccountingTest.sendReceivePayment(tester);
    await AccountingTest.checkPaymentComplete(tester);
    await AccountingTest.selectTransactions(tester);
    await AccountingTest.checkTransactions(tester);
  });
}
