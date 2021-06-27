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
      expect(find.byKey(Key('DashBoardForm')), findsOneWidget);
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

  group('Basic tests >>>>>', () {
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
      expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
          reason: '>>>Not logged in after registration');
      // login with new username
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(getTextFormField('username'), equals('e$random@example.org'),
          reason: '>>>username not remembered (or wrong) after register');
      await tester.enterText(find.byKey(Key('password')), 'qqqqqq9!');
      await tester.tap(find.byKey(Key('login')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('DashBoardForm')), findsOneWidget,
          reason: '>>>After logged in should show dasboard');
      // logout
      await tester.tap(find.byKey(Key('logoutButton')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
          reason: '>>>logged out home screen not found');
    }, skip: false);

    testWidgets("Test company from appbar update local",
        (WidgetTester tester) async {
      await login(tester);
      String random = getRandom();
      await tester.tap(find.byKey(Key('tapCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('CompanyInfoForm')), findsOneWidget,
          reason: '>>>After tap company check screen');
      // check fields as result from initial create
      expect(getTextFormField('companyName'), equals('companyName$random'),
          reason: '>>>company name wrong}');
      expect(getTextFormField('email'), equals('e$random@example.org'),
          reason: '>>>company email wrong');
//      expect(getTextField('currency'), equals('European Euro'),
//          reason: '>>>company currency should be: European Euro '
//              'is: ${getTextField('currency')} ');
      expect(getTextFormField('vatPerc'), equals(''),
          reason: '>>>company vatPerc wrong');
      expect(getTextFormField('salesPerc'), equals(''),
          reason: '>>>company salesperc wrong');
      expect(getTextField('addressLabel'), equals('No address yet'),
          reason: '>>>company address wrong');
      await tester.tap(find.byKey(Key('updateCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // enter updated values in fields
      await tester.enterText(
          find.byKey(Key('companyName')), 'companyName${random}u');
      await tester.enterText(
          find.byKey(Key('email')), 'e${random}u@example.org');
      await tester.enterText(find.byKey(Key('vatPerc')), '1');
      await tester.enterText(find.byKey(Key('salesPerc')), '2');
      await tester.tap(find.byKey(Key('updateCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // and check them
      expect(getTextFormField('companyName'), equals('companyName${random}u'),
          reason: '>>>company name wrong}');
      expect(getTextFormField('email'), equals('e${random}u@example.org'),
          reason: '>>>company email wrong');
//      expect(getTextField('currency'), equals('European Euro'),
//          reason: '>>>company currency should be: European Euro '
//              'is: ${getTextField('currency')} ');
      expect(getTextFormField('vatPerc'), equals('1'),
          reason: '>>>company vatPerc wrong');
      expect(getTextFormField('salesPerc'), equals('2'),
          reason: '>>>company salesperc wrong');
      expect(getTextField('addressLabel'), equals('No address yet'),
          reason: '>>>company address wrong');
      // enter new address entry
      await tester.tap(find.byKey(Key('address')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(find.byKey(Key('address1')), 'address1');
      await tester.enterText(find.byKey(Key('address2')), 'address2');
      await tester.enterText(find.byKey(Key('postal')), 'postal');
      await tester.enterText(find.byKey(Key('city')), 'city');
      await tester.enterText(find.byKey(Key('province')), 'province');
      await tester.tap(find.byKey(Key('updateAddress')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('updateCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('address')));
      expect(getTextFormField('address1'), equals('address1'),
          reason: '>>>after create address1 wrong');
      expect(getTextFormField('address2'), equals('address2'),
          reason: '>>>after create address2 wrong');
      expect(getTextFormField('postal'), equals('postal'),
          reason: '>>>after create postal wrong');
      expect(getTextFormField('city'), equals('city'),
          reason: '>>>after create city wrong');
      expect(getTextFormField('province'), equals('province'),
          reason: '>>>after create province wrong');
      // update address
      await tester.enterText(find.byKey(Key('address1')), 'address1u');
      await tester.enterText(find.byKey(Key('address2')), 'address2u');
      await tester.enterText(find.byKey(Key('postal')), 'postalu');
      await tester.enterText(find.byKey(Key('city')), 'cityu');
      await tester.enterText(find.byKey(Key('province')), 'provinceu');
      await tester.tap(find.byKey(Key('updateAddress')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('updateCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(getTextField('addressLabel'), equals('cityu Anguilla'),
          reason: '>>>company address wrong');
      await tester.tap(find.byKey(Key('address')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(getTextFormField('address1'), equals('address1u'),
          reason: '>>>after update address1 wrong');
      expect(getTextFormField('address2'), equals('address2u'),
          reason: '>>> after update address2 wrong');
      expect(getTextFormField('postal'), equals('postalu'),
          reason: '>>> after update postal wrong');
      expect(getTextFormField('city'), equals('cityu'),
          reason: '>>> after update city wrong');
      expect(getTextFormField('province'), equals('provinceu'),
          reason: '>>> after update province wrong');
    }, skip: false);

    testWidgets("Test company from appbar check db update",
        (WidgetTester tester) async {
      await login(tester);
      String random = getRandom();
      await tester.tap(find.byKey(Key('tapCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(getTextFormField('companyName'), equals('companyName${random}u'),
          reason: '>>>company name wrong}');
      expect(getTextFormField('email'), equals('e${random}u@example.org'),
          reason: '>>>company email wrong');
//      expect(getTextField('currency'), equals('European Euro'),
//          reason: '>>>company currency should be: European Euro '
//              'is: ${getTextField('currency')} ');
      expect(getTextFormField('vatPerc'), equals('1'),
          reason: '>>>company vatPerc wrong');
      expect(getTextFormField('salesPerc'), equals('2'),
          reason: '>>>company salesperc wrong');
      expect(getTextField('addressLabel'), equals('cityu Anguilla'),
          reason: '>>>company address wrong');
      await tester.tap(find.byKey(Key('address')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(getTextFormField('address1'), equals('address1u'),
          reason: '>>>after update address1 wrong');
      expect(getTextFormField('address2'), equals('address2u'),
          reason: '>>> after update address2 wrong');
      expect(getTextFormField('postal'), equals('postalu'),
          reason: '>>> after update postal wrong');
      expect(getTextFormField('city'), equals('cityu'),
          reason: '>>> after update city wrong');
      expect(getTextFormField('province'), equals('provinceu'),
          reason: '>>> after update province wrong');
    }, skip: false);

    testWidgets("Test user dialog local values", (WidgetTester tester) async {
      await login(tester);
      String random = getRandom();
      if (isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pumpAndSettle(Duration(seconds: 5));
      }
      await tester.tap(find.byKey(Key('tapUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check user data from registration
      expect(find.byKey(Key('AdminUserDialog')), findsOneWidget,
          reason: '>>>After tap user at menu/drawer show user dialog');
      expect(getTextFormField('firstName'), equals('firstName'),
          reason: '>>>firstName wrong after register');
      expect(getTextFormField('lastName'), equals('lastName'),
          reason: '>>>lastName wrong after register');
      expect(getTextFormField('username'), equals('e$random@example.org'),
          reason: '>>>username wrong after register');
      expect(getTextFormField('email'), equals('e$random@example.org'),
          reason: '>>>email wrong after register');
      // update fields
      await tester.enterText(find.byKey(Key('firstName')), 'firstNameu');
      await tester.enterText(find.byKey(Key('lastName')), 'lastNameu');
      await tester.enterText(find.byKey(Key('username')), '${random}u');
      await tester.enterText(
          find.byKey(Key('email')), 'e${random}u@example.org');
      await tester.tap(find.byKey(Key('updateUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check updated fields
      expect(getTextFormField('firstName'), equals('firstNameu'),
          reason: '>>>firstName wrong after update');
      expect(getTextFormField('lastName'), equals('lastNameu'),
          reason: '>>>lastName wrong after update');
      expect(getTextFormField('username'), equals('${random}u'),
          reason: '>>>username wrong after update');
      expect(getTextFormField('email'), equals('e${random}u@example.org'),
          reason: '>>>email wrong after update');
    }, skip: false);
    testWidgets("Test user dialog check data base",
        (WidgetTester tester) async {
      await login(tester);
      String random = getRandom();
      // force user to refresh scrren
      if (isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pumpAndSettle(Duration(seconds: 5));
      }
      await tester.tap(find.byKey(Key('tapUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('AdminUserDialog')), findsOneWidget,
          reason: '>>>After tap user at menu/drawer show user dialog');
      expect(getTextFormField('firstName'), equals('firstNameu'),
          reason: '>>>firstName wrong db check');
      expect(getTextFormField('lastName'), equals('lastNameu'),
          reason: '>>>lastName wrong db check');
      expect(getTextFormField('username'), equals('${random}u'),
          reason: '>>>username wrong db check');
      expect(getTextFormField('email'), equals('e${random}u@example.org'),
          reason: '>>>email wrong db check');
    }, skip: false);
  });
}
