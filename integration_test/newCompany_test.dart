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

import 'package:admin/main.dart';
import 'package:dio/dio.dart';
import 'package:core/integration_test/test_functions.dart';
import 'package:backend/@backend.dart';
import 'package:core/widgets/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('Basic tests >>>>>', () {
    testWidgets("prepare >>>>>", (WidgetTester tester) async {
      await Test.createCompanyAndAdmin(
          tester, AdminApp(dbServer: MoquiServer(client: Dio())));
    }, skip: false);

    testWidgets("Test company from appbar update local",
        (WidgetTester tester) async {
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('tapCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('CompanyInfoForm')), findsOneWidget);
      // check fields as result from initial create
      expect(
          Test.getTextFormField('companyName'), equals('companyName$random'));
      expect(Test.getTextFormField('email'), equals('e$random@example.org'));
      expect(Test.getDropdown('currency'), equals('European Euro'));
      expect(Test.getTextFormField('vatPerc'), equals(''));
      expect(Test.getTextFormField('salesPerc'), equals(''));
      expect(Test.getTextField('addressLabel'), equals('No address yet'));
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
      expect(Test.getTextFormField('companyName'),
          equals('companyName${random}u'));
      expect(Test.getTextFormField('email'), equals('e${random}u@example.org'));
      expect(Test.getTextFormField('vatPerc'), equals('1'));
      expect(Test.getTextFormField('salesPerc'), equals('2'));
      expect(Test.getTextField('addressLabel'), equals('No address yet'));
      // enter new address entry
      await tester.tap(find.byKey(Key('address')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(find.byKey(Key('address1')), 'address1');
      await tester.enterText(find.byKey(Key('address2')), 'address2');
      await tester.enterText(find.byKey(Key('postal')), 'postal');
      await tester.enterText(find.byKey(Key('city')), 'city');
      await tester.enterText(find.byKey(Key('province')), 'province');
      await tester.tap(find.byKey(Key('country')));
      await tester.pump(Duration(seconds: 5));
      await tester.tap(find.text('Anguilla').last);
      await tester.pump(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('updateAddress')));
      await tester.pump(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('updateCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check address
      await tester.tap(find.byKey(Key('address')));
      await tester.pump(Duration(seconds: 5));
      expect(Test.getTextFormField('address1'), equals('address1'));
      expect(Test.getTextFormField('address2'), equals('address2'));
      expect(Test.getTextFormField('postal'), equals('postal'));
      expect(Test.getTextFormField('city'), equals('city'));
      expect(Test.getTextFormField('province'), equals('province'));
      expect(Test.getDropdownSearch('country'), equals('Anguilla'));
      await tester.enterText(find.byKey(Key('address1')), 'address1u');
      await tester.enterText(find.byKey(Key('address2')), 'address2u');
      await tester.enterText(find.byKey(Key('postal')), 'postalu');
      await tester.enterText(find.byKey(Key('city')), 'cityu');
      await tester.enterText(find.byKey(Key('province')), 'provinceu');
      await tester.tap(find.byKey(Key('country')));
      await tester.pump(Duration(seconds: 5));
      await tester.tap(find.text('Angola').last);
      await tester.pump(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('updateAddress')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('updateCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(Test.getTextField('addressLabel'), equals('cityu Angola'));
      await tester.tap(find.byKey(Key('address')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(Test.getTextFormField('address1'), equals('address1u'));
      expect(Test.getTextFormField('address2'), equals('address2u'));
      expect(Test.getTextFormField('postal'), equals('postalu'));
      expect(Test.getTextFormField('city'), equals('cityu'));
      expect(Test.getTextFormField('province'), equals('provinceu'));
      expect(Test.getDropdownSearch('country'), equals('Angola'));
    }, skip: false);

    testWidgets("Test company from appbar check db update",
        (WidgetTester tester) async {
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('tapCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(
          Test.getTextFormField('companyName'), equals('companyName${random}u'),
          reason: '>>>company name wrong}');
      expect(Test.getTextFormField('email'), equals('e${random}u@example.org'),
          reason: '>>>company email wrong');
      expect(Test.getTextFormField('vatPerc'), equals('1'),
          reason: '>>>company vatPerc wrong');
      expect(Test.getTextFormField('salesPerc'), equals('2'),
          reason: '>>>company salesperc wrong');
      expect(Test.getTextField('addressLabel'), equals('cityu Angola'),
          reason: '>>>company address wrong');
      await tester.tap(find.byKey(Key('address')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(Test.getTextFormField('address1'), equals('address1u'));
      expect(Test.getTextFormField('address2'), equals('address2u'));
      expect(Test.getTextFormField('postal'), equals('postalu'));
      expect(Test.getTextFormField('city'), equals('cityu'));
      expect(Test.getTextFormField('province'), equals('provinceu'));
      expect(Test.getDropdownSearch('country'), equals('Angola'));
    }, skip: false);

    testWidgets("Test user dialog local values", (WidgetTester tester) async {
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
      String random = Test.getRandom();
      if (Test.isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pumpAndSettle(Duration(seconds: 5));
      }
      await tester.tap(find.byKey(Key('tapUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check user data from registration
      expect(find.byKey(Key('UserDialogAdmin')), findsOneWidget);
      expect(Test.getTextFormField('firstName'), equals('firstName'));
      expect(Test.getTextFormField('lastName'), equals('lastName'));
      expect(Test.getTextFormField('username'), equals('e$random@example.org'));
      expect(Test.getTextFormField('email'), equals('e$random@example.org'));
      // update fields
      await tester.enterText(find.byKey(Key('firstName')), 'firstNameu');
      await tester.enterText(find.byKey(Key('lastName')), 'lastNameu');
      await tester.enterText(find.byKey(Key('username')), '${random}u');
      await tester.enterText(
          find.byKey(Key('email')), 'e${random}u@example.org');
      await tester.tap(find.byKey(Key('updateUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check updated fields
      expect(Test.getTextFormField('firstName'), equals('firstNameu'));
      expect(Test.getTextFormField('lastName'), equals('lastNameu'));
      expect(Test.getTextFormField('username'), equals('${random}u'));
      expect(Test.getTextFormField('email'), equals('e${random}u@example.org'));
    }, skip: false);
    testWidgets("Test user dialog check data base",
        (WidgetTester tester) async {
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
      String random = Test.getRandom();
      // force user to refresh scrren
      if (Test.isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pumpAndSettle(Duration(seconds: 5));
      }
      await tester.tap(find.byKey(Key('tapUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('UserDialogAdmin')), findsOneWidget);
      expect(Test.getTextFormField('firstName'), equals('firstNameu'));
      expect(Test.getTextFormField('lastName'), equals('lastNameu'));
      expect(Test.getTextFormField('username'), equals('${random}u'));
      expect(Test.getTextFormField('email'), equals('e${random}u@example.org'));
    }, skip: false);
  });
}
