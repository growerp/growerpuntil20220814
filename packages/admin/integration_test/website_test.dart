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

  testWidgets('''GrowERP asset test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);
    await CompanyTest.createCompany(tester);
    await WebsiteTest.selectWebsite(tester);
    await WebsiteTest.updateWebsite(tester);
    await CommonTest.logout(tester);
  });
}
