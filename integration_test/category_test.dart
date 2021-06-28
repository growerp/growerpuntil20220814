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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  String getTextFormField(String key) {
    TextFormField tff =
        find.byKey(Key(key)).evaluate().single.widget as TextFormField;
    return tff.controller!.text;
  }

  String getTextField(String key) {
    Text tf = find.byKey(Key(key)).evaluate().single.widget as Text;
    return tf.data!;
  }

  String getRandom() {
    Text tff =
        find.byKey(Key('appBarCompanyName')).evaluate().single.widget as Text;
    return tff.data!.replaceAll(new RegExp(r'[^0-9]'), '');
  }

  bool isPhone() {
    try {
      expect(find.byTooltip('Open navigation menu'), findsOneWidget);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> login(WidgetTester tester) async {
    await tester.pumpWidget(
        RestartWidget(child: AdminApp(repos: Moqui(client: Dio()))));
    await tester.pumpAndSettle(Duration(seconds: 5));
    try {
      expect(find.byKey(Key('DashBoardForm')), findsOneWidget);
    } catch (_) {
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(find.byKey(Key('password')), 'qqqqqq9!');
      await tester.tap(find.byKey(Key('login')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('/')), findsOneWidget);
    }
  }

  Future<void> logout(WidgetTester tester) async {
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle(Duration(seconds: 10));
    }
    await tester.tap(find.byKey(Key('tap/')));
    await tester.tap(find.byKey(Key('logoutButton')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
        reason: '>>>logged out home screen not found');
  }

  group('Category tests>>>>>', () {
    testWidgets("Create Company and Admin", (WidgetTester tester) async {
      String random = Random.secure().nextInt(1024).toString();
      await tester.pumpWidget(
          RestartWidget(child: AdminApp(repos: Moqui(client: Dio()))));
      await tester.pumpAndSettle(Duration(seconds: 30));
      try {
        expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget);
      } catch (_) {
        // assumes still logged in, so logout
        print("Dashboard logged in , needs to logout");
        await tester.tap(find.byKey(Key('logoutButton')));
        await tester.pumpAndSettle(Duration(seconds: 5));
        expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
            reason: '>>>logged out home screen not found');
      }
      // tap new company button, enter data
      await tester.tap(find.byKey(Key('newCompButton')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(find.byKey(Key('firstName')), 'firstName');
      await tester.enterText(find.byKey(Key('lastName')), 'lastName');
      await tester.enterText(find.byKey(Key('email')), 'e$random@example.org');
      await tester.enterText(
          find.byKey(Key('companyName')), 'companyName$random');
      await tester.tap(find.byKey(Key('demoData')));
      await tester.tap(find.byKey(Key('newCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }, skip: false);

    testWidgets("test CRM tabs>>>>>", (WidgetTester tester) async {
      await login(tester);
      String random = getRandom();
      expect(find.byKey(Key('tap/catalog')), findsOneWidget);
      // use the catalog tap dashboard
      await tester.tap(find.byKey(Key('tap/catalog')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('/catalog')), findsOneWidget,
          reason: '>>>After tap product check screen');
      expect(find.byKey(Key('ProductsForm')), findsOneWidget,
          reason: '>>>After tap product check screen');
      expect(find.byKey(Key('empty')), findsOneWidget,
          reason: '>>>After tap no categories');
      if (isPhone())
        expect(find.byTooltip('2'), findsOneWidget);
      else
        await tester.tap(find.byKey(Key('AssetsForm')));
      await tester.tap(find.byTooltip('2'));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('AssetsForm')), findsOneWidget,
          reason: '>>>After tap assets check screen');
      expect(find.byKey(Key('empty')), findsOneWidget,
          reason: '>>>After tap no assets');
      if (isPhone())
        expect(find.byTooltip('3'), findsOneWidget);
      else
        await tester.tap(find.byKey(Key('CategoriesForm')));
      await tester.tap(find.byTooltip('3'));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('CategoriesForm')), findsOneWidget,
          reason: '>>>After tap categories check screen');
      expect(find.byKey(Key('empty')), findsOneWidget,
          reason: '>>>After tap no categories');
    }, skip: false);

    testWidgets("categories test >>>>>", (WidgetTester tester) async {
      await login(tester);
      String random = getRandom();
      expect(find.byKey(Key('tap/catalog')), findsOneWidget);
      // use the catalog tap dashboard
      await tester.tap(find.byKey(Key('tap/catalog')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      if (isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('CategoriesForm')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('CategoryDialog')), findsOneWidget);
      await tester.enterText(find.byKey(Key('name')), 'categoryName${random}a');
      await tester.enterText(
          find.byKey(Key('description')), 'categoryDesc${random}a');
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(find.byKey(Key('name')), 'categoryName${random}b');
      await tester.enterText(
          find.byKey(Key('description')), 'categoryDesc${random}b');
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('categoryItem')), findsNWidgets(2));
      expect(find.text('categoryName${random}a'), findsOneWidget);
      expect(find.text('categoryName${random}b'), findsOneWidget);
      await tester.tap(find.text('categoryName${random}a'));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(getTextFormField('name'), 'categoryName${random}a');
      expect(getTextFormField('description'), 'categoryDesc${random}a');
      await tester.enterText(find.byKey(Key('name')), 'categoryName${random}c');
      await tester.enterText(
          find.byKey(Key('description')), 'categoryDesc${random}c');
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.text('categoryName${random}c'), findsOneWidget);
    }, skip: false);

    testWidgets("categories  reload from database>>>>>",
        (WidgetTester tester) async {
      await login(tester);
      String random = getRandom();
      expect(find.byKey(Key('tap/catalog')), findsOneWidget);
      // use the catalog tap dashboard
      await tester.tap(find.byKey(Key('tap/catalog')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      if (isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('CategoriesForm')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('categoryItem')), findsNWidgets(2));
      await tester.tap(find.text('categoryName${random}c'));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(getTextFormField('name'), 'categoryName${random}c');
      expect(getTextFormField('description'), 'categoryDesc${random}c');
    }, skip: false);
  });
}
