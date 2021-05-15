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

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:screenshots/screenshots.dart';

void main() {
  final config = Config();
  group('Admin Home Page test', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('Login button', () async {
      print("====starting!!!!======");
      final login = find.byValueKey('loginButton');
      await driver.tap(login);
      final login1 = find.byValueKey('login');
      await driver.tap(login1);
      await screenshot(driver, config, 'dashboard');
      final logout = find.byValueKey('logoutButton');
      await driver.tap(logout);
    });
  });
}
