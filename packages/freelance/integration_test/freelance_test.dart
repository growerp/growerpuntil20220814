import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'startApp.dart';
import 'package:core/domains/common/integration_test/commonTest.dart';
import 'package:core/domains/tasks/integration_test/@taskTest.dart';
import 'package:core/domains/auth/integration_test/auth_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('''Do task tests in new company''', (tester) async {
    await startApp(tester);
    await AuthTest.createNewCompany(tester);
    await TaskTest.taskTest(tester);
    await AuthTest.logout(tester);
  });
}
