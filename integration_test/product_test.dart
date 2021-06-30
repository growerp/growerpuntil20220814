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
import 'test_functions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('Product tests>>>>>', () {
    testWidgets("Create Company and Admin", (WidgetTester tester) async {
      String random = Random.secure().nextInt(1024).toString();
      await tester.pumpWidget(
          RestartWidget(child: AdminApp(repos: Moqui(client: Dio()))));
      await tester.pumpAndSettle(Duration(seconds: 10));
      try {
        expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget);
      } catch (_) {
        // assumes still logged in, so logout
        print("Dashboard logged in , needs to logout");
        await tester.tap(find.byKey(Key('logoutButton')));
        await tester.pumpAndSettle(Duration(seconds: 1));
        expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
            reason: '>>>logged out home screen not found');
      }
      // tap new company button, enter data
      await tester.tap(find.byKey(Key('newCompButton')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(find.byKey(Key('firstName')), 'firstName');
      await tester.enterText(find.byKey(Key('lastName')), 'lastName');
      await tester.enterText(find.byKey(Key('email')), 'e$random@example.org');
      await tester.enterText(
          find.byKey(Key('companyName')), 'companyName$random');
      await tester.tap(find.byKey(Key('demoData')));
      await tester.tap(find.byKey(Key('newCompany')));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }, skip: false);

    testWidgets("product test >>>>>", (WidgetTester tester) async {
      await Test.login(tester);
      // create a single category
      await Test.createCategoryFromMain(tester);
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('dbCatalog')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('1'));
      else
        await tester.tap(find.byKey(Key('ProductsForm')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // enter 'a' to check
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byKey(Key('ProductDialog')), findsOneWidget);
      await tester.enterText(find.byKey(Key('name')), 'productName${random}a');
      await tester.enterText(
          find.byKey(Key('description')), 'productDesc${random}a');
      await tester.enterText(find.byKey(Key('price')), '1.1');
      await tester.tap(find.byKey(Key('categoryDropDown')));
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.text('categoryName1').last); // sometimes fail...
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // enter 'b' to check and(later)update to 'd'
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(find.byKey(Key('name')), 'productName${random}b');
      await tester.enterText(
          find.byKey(Key('description')), 'productDesc${random}b');
      await tester.enterText(find.byKey(Key('price')), '2.2');
      await tester.tap(find.byKey(Key('categoryDropDown')));
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.text('categoryName1').last);
      await tester.pump(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // enter 'c' to later delete
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(find.byKey(Key('name')), 'productName${random}c');
      await tester.enterText(
          find.byKey(Key('description')), 'productDesc${random}c');
      await tester.enterText(find.byKey(Key('price')), '3.3');
      await tester.tap(find.byKey(Key('categoryDropDown')));
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.text('categoryName1').last);
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // now have three records
      expect(find.byKey(Key('productItem')), findsNWidgets(3));
      // check list
      expect(Test.getTextField('name0'), equals('productName${random}a'));
      expect(Test.getTextField('price0'), equals('1.1'));
      expect(Test.getTextField('categoryName0'), equals('categoryName1'));
      expect(Test.getTextField('name1'), equals('productName${random}b'));
      expect(Test.getTextField('price1'), equals('2.2'));
      expect(Test.getTextField('categoryName1'), equals('categoryName1'));
      expect(Test.getTextField('name2'), equals('productName${random}c'));
      expect(Test.getTextField('price2'), equals('3.3'));
      expect(Test.getTextField('categoryName2'), equals('categoryName1'));
      // check detail screen 'a'
      await tester.tap(find.byKey(Key('name0')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(Test.getTextFormField('name'), 'productName${random}a');
      expect(Test.getTextFormField('description'), 'productDesc${random}a');
      expect(Test.getTextFormField('price'), '1.1');
      expect(Test.getDropdownSearch('categoryDropDown'), 'categoryName1');
      await tester.tap(find.byKey(Key('cancel')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // check detail screen 'b' and update to 'd'
      await tester.tap(find.byKey(Key('name1')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(Test.getTextFormField('name'), 'productName${random}b');
      expect(Test.getTextFormField('description'), 'productDesc${random}b');
      expect(Test.getTextFormField('price'), '2.2');
      expect(Test.getDropdownSearch('categoryDropDown'), 'categoryName1');
      // update detail screen b to record 'd'
      await tester.enterText(find.byKey(Key('name')), 'productName${random}d');
      await tester.enterText(
          find.byKey(Key('description')), 'productDesc${random}d');
      await tester.enterText(find.byKey(Key('price')), '4.4');
      await tester.tap(find.byKey(Key('categoryDropDown')));
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.text('categoryName2').last); // sometimes fail...
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check update from b -> d in list
      expect(Test.getTextField('name1'), equals('productName${random}d'));
      expect(Test.getTextField('price1'), equals('4.4'));
      expect(Test.getTextField('categoryName1'), equals('categoryName2'));
      // check update from b -> d in detail screen
      await tester.tap(find.byKey(Key('name1')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(Test.getTextFormField('name'), 'productName${random}d');
      expect(Test.getTextFormField('description'), 'productDesc${random}d');
      expect(Test.getTextFormField('price'), '4.4');
      expect(Test.getDropdownSearch('categoryDropDown'), 'categoryName2');
      await tester.tap(find.byKey(Key('cancel')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // delete record 'c'
      await tester.tap(find.byKey(Key('delete2')));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }, skip: false);

    testWidgets("products  reload from database>>>>>",
        (WidgetTester tester) async {
      // 0: a   1: d 2: deleted
      await Test.login(tester);
      String random = Test.getRandom();
      // use the catalog tap dashboard
      await tester.tap(find.byKey(Key('dbCatalog')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // check list
      expect(find.byKey(Key('productItem')), findsNWidgets(2));
      expect(Test.getTextField('name0'), equals('productName${random}a'));
      if (!Test.isPhone())
        expect(
            Test.getTextField('description0'), equals('productDesc${random}a'));
      expect(Test.getTextField('name1'), equals('productName${random}d'));
      if (!Test.isPhone())
        expect(
            Test.getTextField('description1'), equals('productDesc${random}d'));
      // check detail screen of d , second line
      await tester.tap(find.byKey(Key('name1')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(Test.getTextFormField('name'), 'productName${random}d');
      expect(Test.getTextFormField('description'), 'productDesc${random}d');
      expect(Test.getTextFormField('price'), '4.4');
      expect(Test.getDropdownSearch('categoryDropDown'), 'categoryName2');
    }, skip: false);
  });
}
