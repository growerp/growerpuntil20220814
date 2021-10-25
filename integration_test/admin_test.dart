import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/domains/auth/integration_test/auth_test.dart';
import 'package:core/domains/users/integration_test/user_test.dart';
import 'package:core/domains/common/integration_test/data.dart';

import 'startApp.dart';
import 'package:core/domains/opportunities/integration_test/opportunity_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Start App with new company''', () {
    testWidgets('''if loggedin log out and create new company''',
        (tester) async {
      await startApp(tester);
      await AuthTest.createNewCompany(tester);
      await AuthTest.login(tester);
      await UserTest.createUsers(tester, leads, 'dbCrm', '2');
      await OpportunityTest.opportunityTest(tester);
    });
  });
}
