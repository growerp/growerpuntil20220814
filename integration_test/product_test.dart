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
import 'package:backend/moqui.dart';
import 'package:core/widgets/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';
import 'package:models/@models.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('Product tests>>>>>', () {
    testWidgets("product test >>>>>", (WidgetTester tester) async {
      await Test.createCompanyAndAdmin(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      // create a categories
      await Test.createCategoryFromMain(tester);
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('dbCatalog')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // create three product records
      List<String> char = ['a', 'b', 'x'];
      List<String> price = ['1.1', '2.2', '3.3'];
      for (int x in [0, 1, 2]) {
        await tester.tap(find.byKey(Key('addNew')));
        await tester.pump();
        expect(find.byKey(Key('ProductDialog')), findsOneWidget);
        await tester.enterText(
            find.byKey(Key('name')), 'productName$random${char[x]}');
        await tester.enterText(
            find.byKey(Key('description')), 'productDesc$random${char[x]}');
        await tester.enterText(find.byKey(Key('price')), price[x]);
        await tester.tap(find.byKey(Key('categoryDropDown')));
        await tester.pump(Duration(seconds: 5));
        await tester.tap(find.text('categoryName1').last); // sometimes fail...
        await tester.pump(Duration(seconds: 1));
        await tester.tap(find.byKey(Key('productTypeDropDown')));
        await tester.pumpAndSettle(Duration(seconds: 1));
        await tester.tap(find.text(productTypes[0]).last);
        await tester.pump(Duration(seconds: 1));
        await tester.drag(find.byKey(Key('listView')), Offset(0.0, -500.0));
        await tester.pump(Duration(seconds: 3));
        await tester.tap(find.byKey(Key('update')));
        await tester.pumpAndSettle(Duration(seconds: 5));
      }
      // now have three records
      expect(find.byKey(Key('productItem')), findsNWidgets(3));
      // check list
      for (int x in [0, 1, 2]) {
        expect(Test.getTextField('name$x'),
            equals('productName$random${char[x]}'));
        expect(Test.getTextField('price$x'), equals(price[x]));
        expect(Test.getTextField('categoryName$x'), equals('categoryName1'));
        if (!Test.isPhone()) {
          expect(Test.getTextField('description$x'),
              equals('productDesc$random${char[x]}'));
        }
      }
      // check detail screens
      for (int x in [0, 1, 2]) {
        await tester.tap(find.byKey(Key('name$x')));
        await tester.pump(Duration(seconds: 1));
        expect(Test.getTextFormField('name'), 'productName$random${char[x]}');
        expect(Test.getTextFormField('description'),
            'productDesc$random${char[x]}');
        expect(Test.getTextFormField('price'), price[x]);
        expect(Test.getDropdownSearch('categoryDropDown'), 'categoryName1');
        expect(Test.getDropdown('productTypeDropDown'), productTypes[0]);
        await tester.drag(find.byKey(Key('listView')), Offset(0.0, -500.0));
        await tester.pump(Duration(seconds: 3));
        await tester.tap(find.byKey(Key('cancel')));
        await tester.pumpAndSettle(Duration(seconds: 1));
      }
      // update detail screen b to record 'd'
      await tester.tap(find.byKey(Key('name1')));
      await tester.pump(Duration(seconds: 1));
      await tester.enterText(find.byKey(Key('name')), 'productName${random}d');
      await tester.enterText(
          find.byKey(Key('description')), 'productDesc${random}d');
      await tester.enterText(find.byKey(Key('price')), '4.4');
      await tester.tap(find.byKey(Key('categoryDropDown')));
      await tester.pump(Duration(seconds: 5));
      await tester.tap(find.text('categoryName2').last); // sometimes fail...
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.byKey(Key('productTypeDropDown')));
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.text(productTypes[2]).last);
      await tester.pump(Duration(seconds: 1));
      await tester.drag(find.byKey(Key('listView')), Offset(0.0, -500.0));
      await tester.pump(Duration(seconds: 3));
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
      expect(Test.getDropdown('productTypeDropDown'), productTypes[2]);
      await tester.drag(find.byKey(Key('listView')), Offset(0.0, -500.0));
      await tester.pump(Duration(seconds: 3));
      await tester.tap(find.byKey(Key('cancel')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // delete record 'x'
      await tester.tap(find.byKey(Key('delete2')));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }, skip: false);

    testWidgets("products  reload from database>>>>>",
        (WidgetTester tester) async {
      // 0: a   1: d 2: deleted
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
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
      expect(Test.getDropdown('productTypeDropDown'), productTypes[2]);
    }, skip: false);
  });
}
