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

  group('Asset tests>>>>>', () {
    testWidgets("asset add/mod/del >>>>>", (WidgetTester tester) async {
      await Test.createCompanyAndAdmin(
          tester,
          TopApp(
              dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()));
      await Test.createProductFromMain(tester);
      String random = Test.getRandom();
      await Test.tap(tester, 'dbCatalog');
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await Test.tap(tester, 'tapAssetsForm');
      await tester.pump(Duration(seconds: 1));
      // enter 3 records
      List<String> char = ['a', 'b', 'x'];
      List<String> quantity = ['11', '22', '33'];
      for (int x in [0, 1, 2]) {
        // create
        await Test.tap(tester, 'addNew');
        await tester.pump(Duration(seconds: 1));
        expect(find.byKey(Key('AssetDialog')), findsOneWidget);
        await Test.enterText(tester, 'name', 'assetName$random${char[x]}');
        await Test.enterText(tester, 'quantityOnHand', quantity[x]);
        await Test.tap(tester, 'productDropDown');
        await tester.pump(Duration(seconds: 1));
        await tester.tap(find.text('productName1').last);
        await tester.pump(Duration(seconds: 1));
        await Test.tap(tester, 'statusDropDown');
        await tester.pump(Duration(seconds: 1));
        await tester.tap(find.text('Available').last);
        await tester.pump(Duration(seconds: 1));
        await Test.tap(tester, 'update');
        await tester.pumpAndSettle(Duration(seconds: 3));
        // check list
        expect(
            Test.getTextField('name$x'), equals('assetName$random${char[x]}'));
        if (!Test.isPhone()) {
          expect(Test.getTextField('statusId$x'), equals('Available'));
        }
        expect(Test.getTextField('product$x'), equals('productName1'));
        // check detail screen
        await Test.tap(tester, 'name$x');
        expect(Test.getTextFormField('name'),
            equals('assetName$random${char[x]}'));
        expect(
            Test.getTextFormField('quantityOnHand'), equals('${quantity[x]}'));
        expect(Test.getDropdown('statusDropDown'), equals('Available'));
        expect(
            Test.getDropdownSearch('productDropDown'), equals('productName1'));
        if (x == 1) {
          // update second record x=1 from b -> c
          await Test.enterText(tester, 'name', 'assetName${random}c');
          await Test.enterText(tester, 'quantityOnHand', '44');
          await Test.tap(tester, 'productDropDown');
          await tester.pump(Duration(seconds: 1));
          await tester.tap(find.text('productName2').last);
          await tester.pump(Duration(seconds: 1));
          await Test.tap(tester, 'statusDropDown');
          await tester.pump(Duration(seconds: 1));
          await tester.tap(find.text('In Use').last);
          await tester.pump(Duration(seconds: 1));
          await Test.drag(tester);
          await Test.tap(tester, 'update');
          await tester.pumpAndSettle(Duration(seconds: 5));
          // check list
          expect(Test.getTextField('name1'), equals('assetName${random}c'));
          if (!Test.isPhone()) {
            expect(Test.getTextField('statusId1'), equals('In Use'));
          }
          expect(Test.getTextField('product1'), equals('productName2'));
          // check detail screen
          await Test.tap(tester, 'name1');
          expect(Test.getTextFormField('name'), 'assetName${random}c');
          expect(Test.getTextFormField('quantityOnHand'), '44');
          expect(Test.getDropdown('statusDropDown'), equals('In Use'));
          expect(Test.getDropdownSearch('productDropDown'),
              equals('productName2'));
        }
        await Test.tap(tester, 'cancel');
        await tester.pump(Duration(seconds: 1));
      }
      expect(find.byKey(Key('assetItem')), findsNWidgets(3));
      // delete record 'c' x=2
      await Test.tap(tester, 'delete2');
      await tester.pumpAndSettle(Duration(seconds: 1));
    }, skip: false);

    testWidgets("assets  reload from database>>>>>",
        (WidgetTester tester) async {
      // 0:a   1:c  2:deleted
      await Test.login(
          tester,
          TopApp(
              dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()));
      String random = Test.getRandom();
      // use the catalog tap dashboard
      await Test.tap(tester, 'dbCatalog');
      // get to asset list
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await Test.tap(tester, 'tapAssetsForm');
      await tester.pump(Duration(seconds: 1));
      // check list (one record deleted)
      expect(find.byKey(Key('assetItem')), findsNWidgets(2));
      expect(Test.getTextField('name0'), equals('assetName${random}a'));
      expect(Test.getTextField('name1'), equals('assetName${random}c'));
      if (!Test.isPhone()) {
        expect(Test.getTextField('statusId0'), equals('Available'));
        expect(Test.getTextField('statusId1'), equals('In Use'));
      }
      expect(Test.getTextField('product0'), equals('productName1'));
      expect(Test.getTextField('product1'), equals('productName2'));
      // detail screen 0
      await Test.tap(tester, 'name0');
      expect(Test.getTextFormField('name'), equals('assetName${random}a'));
      expect(Test.getTextFormField('quantityOnHand'), '11');
      expect(Test.getDropdown('statusDropDown'), equals('Available'));
      expect(Test.getDropdownSearch('productDropDown'), equals('productName1'));
      await Test.tap(tester, 'cancel');
      // detail screen 1
      await Test.tap(tester, 'name1');
      expect(Test.getTextFormField('name'), 'assetName${random}c');
      expect(Test.getTextFormField('quantityOnHand'), '44');
      expect(Test.getDropdown('statusDropDown'), equals('In Use'));
      expect(Test.getDropdownSearch('productDropDown'), equals('productName2'));
      await Test.tap(tester, 'cancel');
    }, skip: false);
  });
}
