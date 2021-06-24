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

import 'dart:math';

import 'package:admin/main.dart';
import 'package:core/forms/@forms.dart';
import 'package:core/widgets/observer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';
import 'package:backend/moqui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:models/@models.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
/*  Bloc.observer = SimpleBlocObserver();
  int random = Random.secure().nextInt(1024);
  String email = 'e${random.toString()}@example.com';
  String companyName = 'companyName' + random.toString();
  bool isPhone = false;
*/

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('Basic tests >>>>>', () {
    testWidgets("Create Company and Admin", (WidgetTester tester) async {
      int random = Random.secure().nextInt(1024);
      String email = 'e${random.toString()}@example.com';
      String companyName = 'companyName' + random.toString();
      bool isPhone = false;
      await tester.pumpWidget(
          RestartWidget(child: AdminApp(repos: Moqui(client: Dio()))));
      print("==== starting up ");
      await tester.pumpAndSettle(Duration(seconds: 30));
      try {
        expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget);
      } catch (_) {
        // assumes still logged in, so logout
        await tester.tap(find.byKey(Key('logoutButton')));
        await tester.pumpAndSettle();
        expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
            reason: 'logged out home screen not found');
      }
      print("Home, not loggedin screen");
      await tester.tap(find.byKey(Key('newCompButton')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('firstName')), 'firstName');
      await tester.enterText(find.byKey(Key('lastName')), 'lastName');
      await tester.enterText(find.byKey(Key('email')), email);
      await tester.enterText(find.byKey(Key('companyName')), companyName);
      await tester.tap(find.byKey(Key('demoData')));
      await tester.tap(find.byKey(Key('newCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
          reason: 'Not logged in after registration');
      print("logging in with new login");
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle();
      expect(find.text(email), findsOneWidget,
          reason: 'username should be shown');
      await tester.enterText(find.byKey(Key('password')), 'qqqqqq9!');
      await tester.tap(find.byKey(Key('login')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('DashBoardForm')), findsOneWidget,
          reason: 'After logged in should show dasboard');
      await tester.tap(find.byKey(Key('logoutButton')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
          reason: 'logged out home screen not found');
      print("logging in again");
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('password')), 'qqqqqq9!');
      await tester.tap(find.byKey(Key('login')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('DashBoardForm')), findsOneWidget,
          reason: 'After logged in should show dasboard');
    }, skip: false);

    testWidgets("check company", (WidgetTester tester) async {
      await tester.pumpWidget(
          RestartWidget(child: AdminApp(repos: Moqui(client: Dio()))));
      await tester.pumpAndSettle(Duration(seconds: 5));
      try {
        expect(find.byKey(Key('DashBoardForm')), findsOneWidget);
        print("=== already logged in");
      } catch (_) {
        print("=== need to login again");
        await tester.tap(find.byKey(Key('loginButton')));
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(Key('password')), 'qqqqqq9!');
        await tester.tap(find.byKey(Key('login')));
        await tester.pumpAndSettle(Duration(seconds: 5));
        expect(find.byKey(Key('DashBoardForm')), findsOneWidget);
      }
      await tester.tap(find.byKey(Key('tapCompany')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('CompanyInfoForm')), findsOneWidget,
          reason: 'After tap company check screen');
    }, skip: false);
  });
}
