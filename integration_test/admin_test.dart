import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'startApp.dart';
import 'package:core/domains/common/integration_test/@commonTest.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Start App with new company''', () {
    testWidgets('''if loggedin log out and create new company''',
        (tester) async {
      await startApp(tester);
      await CommonTest.createNewCompany(tester);
      await CommonTest.pressLogout(tester);
    });
  });
}
