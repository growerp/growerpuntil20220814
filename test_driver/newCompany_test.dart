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
import 'dart:math';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  // Load environmental variables

  bool isPhone = false;
  late FlutterDriver driver;
  int random = Random.secure().nextInt(1024);
  String imagePrefix = "test_driver/screenshots";
  int seq = 0;

  Future<void> takeScreenshot() async {
    final List<int> pixels = await driver.screenshot();
    final File file = File('$imagePrefix/${random.toString()}-${seq++}.png');
    await file.writeAsBytes(pixels);
  }

  // find by valueKey or SerializableFinder
  // take a screen shot if 'expected' is provided AND not the same as result
  Future<bool> waitFor(SerializableFinder itemToFind,
      {bool? expected, Duration timeout = const Duration(seconds: 10)}) async {
    try {
      await driver.waitFor(itemToFind, timeout: timeout);
      if (expected != null && expected != true) {
        takeScreenshot();
        expect(true, false, reason: "=== should not find but did: $itemToFind");
      }
      return Future.value(true);
    } catch (e) {
      if (expected != null && expected != false) {
        takeScreenshot();
        expect(true, false,
            reason: "=== could not find: ${itemToFind.serialize()}");
      }
      return Future.value(false);
    }
  }

  Future<void> tapMenuButton(button) async {
    if (isPhone) {
      // open drawer when phone
      final drawerFinder = find.byTooltip('Open navigation menu');
      await driver.waitFor(drawerFinder, timeout: Duration(seconds: 20));
      await driver.tap(drawerFinder);
    }
    final buttonKey = find.byValueKey(button);
    await driver.scrollIntoView(buttonKey);
    await driver.tap(buttonKey);
  }

  Future<void> enterTextInField(String fieldKey, {String value = ''}) async {
    if (value.isEmpty) value = fieldKey;
    await driver.tap(find.byValueKey(fieldKey));
    await driver.enterText(value);
  }

  group('Admin Home Page test', () {
    setUpAll(() async {
      print('=== setup driver === with a random string: $random');
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('check flutter driver health', () async {
      Health health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });

    test('Register, login, logout', () async {
      if (await waitFor(find.byValueKey('DashBoardForm')) == true) {
        await driver.tap(find.byValueKey('logoutButton'));
      }
      await waitFor(find.byValueKey('HomeFormUnAuth'), expected: true);
      await driver.tap(find.byValueKey('newCompButton'));
      enterTextInField('firstName');
      enterTextInField('lastName');
      enterTextInField('email', value: 'e${random.toString()}@example.com');
      enterTextInField('companyName', value: 'companyName' + random.toString());
      await driver.tap(find.byValueKey('demoData'));
      takeScreenshot();
      await driver.tap(find.byValueKey('newCompany'));

      // login
      await waitFor(find.byValueKey('HomeFormUnAuth'), expected: true);
      await driver.tap(find.byValueKey('loginButton'));
      await waitFor(find.byValueKey('username'), expected: true);
      enterTextInField('username', value: 'e${random.toString()}@example.com');
      enterTextInField('password', value: 'qqqqqq9!');
      await driver.tap(find.byValueKey('login'));

      //dashboard and check if phone
      await waitFor(find.byValueKey('DashBoardForm'), expected: true);
      isPhone = await waitFor(find.byTooltip('Open navigation menu'));

      // logout
      await driver.tap(find.byValueKey('logoutButton'));
      await waitFor(find.byValueKey('HomeFormUnAuth'), expected: true);

      // remain logged in for next tests
      await driver.tap(find.byValueKey('loginButton'));
      await waitFor(find.byValueKey('username'), expected: true);
      enterTextInField('username', value: 'e${random.toString()}@example.com');
      enterTextInField('password', value: 'qqqqqq9!');
      await driver.tap(find.byValueKey('login'));
    }, timeout: Timeout(Duration(seconds: 60)));

    test('User Update test', () async {
      await tapMenuButton('tap/company');
    }, timeout: Timeout(Duration(seconds: 60)));
  });
}
