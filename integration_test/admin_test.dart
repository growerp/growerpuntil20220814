import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/domains/auth/integration_test/auth_test.dart';
import 'package:core/domains/users/integration_test/user_test.dart';
import 'package:core/domains/common/integration_test/data.dart';

import 'startApp.dart';
import 'package:core/domains/opportunities/integration_test/opportunity_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('''Admin Opportunity test''', (tester) async {
    print("========== Admin test: Opportunity preparation");
    bool newRandom = true; // run test with new random number or not
    await startApp(tester, newRandom: newRandom);
    if (newRandom == true) {
      await AuthTest.createNewCompany(tester);
      await AuthTest.login(tester);
      await UserTest.createUsers(tester, leads, 'dbCrm', '2');
      await UserTest.createUsers(tester, administrators, 'dbCompany', '2');
    } else
      AuthTest.loginIfRequired(tester);
    print("========== Admin test: Opportunity test start");
    await OpportunityTest.opportunityTest(tester);
  }, skip: false);
}
