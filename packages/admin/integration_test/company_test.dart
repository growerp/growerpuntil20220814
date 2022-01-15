import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/domains/integration_test.dart';
import 'package:admin/startApp.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('''GrowERP company test''', (tester) async {
    await startApp(tester, clear: true); //restart complete test
    await CompanyTest.createCompany(tester);
    await CommonTest.login(tester);
    await CompanyTest.selectCompany(tester);
    await CompanyTest.updateCompany(tester);
    await CompanyTest.updateAddress(tester);
    await CommonTest.logout(tester);
  }, skip: false);
}
