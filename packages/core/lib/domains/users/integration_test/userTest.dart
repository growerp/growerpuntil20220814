/*
 * This software is in the public domain under CC0 1.0 Universal plus a
 * Grant of Patent License.
 * 
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any
 * warranty.
 * 
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software (see the LICENSE.md file). If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

import 'package:core/domains/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/domains/domains.dart';

// this test is started by the top app after 'startApp'

class UserTest {
  static Future<void> createUsers(WidgetTester tester, List<User> users,
      String menu, String subMenu) async {
    await CommonTest.tapByKey(tester, menu, seconds: 5);
    String tap = "tapUsersForm${users[0].userGroup}";
    String formName = "UsersForm${users[0].userGroup}";
    if (CommonTest.isPhone()) {
      await tester.tap(find.byTooltip(subMenu));
      await tester.pumpAndSettle(Duration(seconds: 2));
    } else
      await CommonTest.tapByKey(tester, tap);
    await CommonTest.checkWidgetKey(tester, formName);
    for (final e in users) {
      if (e.lastName == 'login Name') continue;
      await CommonTest.tapByKey(tester, 'addNew');
      await CommonTest.enterText(tester, 'firstName', e.firstName!);
      await CommonTest.enterText(tester, 'lastName', e.lastName!);
      await CommonTest.enterText(tester, 'username', e.userId!);
      await CommonTest.drag(tester);
      await CommonTest.enterText(tester, 'email', e.email!);
      if (e.userGroup != UserGroup.Employee && e.userGroup != UserGroup.Admin)
        await CommonTest.enterText(tester, 'newCompanyName', e.companyName!);
      await CommonTest.tapByKey(tester, 'updateUser', seconds: 5);
    }
    await AuthTest.gotoMainMenu(tester); // back home
  }
}
