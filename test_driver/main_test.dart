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

import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  // Load environmental variables
  String imagePrefix = Platform.environment['imagePrefix'] ?? '?';
  print('=========Results  is $imagePrefix');

  Future<void> takeScreenshot(FlutterDriver driver, String name) async {
    if (imagePrefix != '?') {
      final List<int> pixels = await driver.screenshot();
      final File file = File('$imagePrefix$name.png');
      await file.writeAsBytes(pixels);
    }
  }

  group('Admin Home Page test', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });
    test('check flutter driver health', () async {
      Health health = await driver.checkHealth();
      print("====health status: ${health.status}");
    });

    test('Login button', () async {
      await driver.tap(find.byValueKey('loginButton'));
      await driver.tap(find.byValueKey('login'));
      await driver.waitFor(find.byValueKey('DashBoardForm'),
          timeout: Duration(seconds: 20));
      await takeScreenshot(driver, 'dashboard');
      await driver.tap(find.byValueKey('logoutButton'));
    });
  });
}
