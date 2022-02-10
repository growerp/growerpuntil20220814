import 'package:admin/main.dart';
import 'package:core/api_repository.dart';
import 'package:core/services/chat_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/domains/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

// this test requires company test to run first

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
  });

  testWidgets('''GrowERP user test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()));
    await CommonTest.login(tester);
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
}
