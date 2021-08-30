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
  List<String> char = ['a', 'b', 'x'];
  List<String> quantity = ['11', '22', '33'];

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('Order Product tests>>>>>', () {
    testWidgets("prepare >>>>>", (WidgetTester tester) async {
      await Test.createCompanyAndAdmin(
          tester, AdminApp(dbServer: MoquiServer(client: Dio())));
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
      String random = Test.getRandom();
      await Test.createUser(tester, 'customer', random);
      await Test.createProductFromMain(tester);
    }, skip: false);

    testWidgets("order add/mod/del with physical product >>>>>",
        (WidgetTester tester) async {
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('dbSales')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byKey(Key('FinDocsFormSalesOrder')), findsOneWidget);
      // enter 3 records
      for (int x in [0, 1, 2]) {
        await tester.tap(find.byKey(Key('addNew')));
        await tester.pump();
        expect(find.byKey(Key('FinDocDialogSalesorder')), findsOneWidget);
        await tester.tap(find.byKey(Key('customer')));
        await tester.pump(Duration(seconds: 5));
        await tester.tap(find.textContaining('customer1').last);
        await tester.pump(Duration(seconds: 1));
        await tester.enterText(
            find.byKey(Key('description')), 'orderName$random${char[x]}');
        await tester.tap(find.byKey(Key('addProduct')));
        await tester.pump(Duration(seconds: 1));
        await tester.tap(find.byKey(Key('product')));
        await tester.pump(Duration(seconds: 3));
        await tester.tap(find.textContaining('productName1').last);
        await tester.pump(Duration(seconds: 1));
        await tester.enterText(find.byKey(Key('quantity')), '${quantity[x]}');
        await tester.pump();
        await tester.tap(find.byKey(Key('ok')));
        await tester.pump(Duration(seconds: 3));
        expect(Test.getTextField('itemDescription1'), equals('productName1'));
        expect(Test.getTextField('itemPrice1'),
            equals('${quantity[0]}.${quantity[0]}'));
        expect(Test.getTextField('itemQuantity1'), equals('${quantity[x]}'));
        await tester.drag(find.byKey(Key('listView1')), Offset(0.0, -500.0));
        await tester.pump(Duration(seconds: 1));
        await tester.tap(find.byKey(Key('update')));
        await tester.pumpAndSettle(Duration(seconds: 10));
      }
      expect(find.byKey(Key('finDocItem')), findsNWidgets(3));
      expect(find.byKey(Key('FinDocsFormSalesOrder')), findsOneWidget);
      // check list
      for (int x in [0, 1, 2]) {
        expect(Test.getTextField('statusId$x'), equals('in Preparation'));
        expect(Test.getTextField('otherUser$x'), contains('customer1'));
        expect(Test.getTextField('otherUser$x'),
            contains('newCompanyName${random}1'));
        if (!Test.isPhone()) {
          expect(
              Test.getTextField('email$x'), equals('e${random}5@example.org'));
          expect(Test.getTextField('description$x'),
              equals('orderName$random${char[x]}'));
        }
      }
      //check detail and update second record, delete last one (not phone)
      expect(find.byKey(Key('FinDocsFormSalesOrder')), findsOneWidget);
      for (int x in [0, 1, 2]) {
        await tester.tap(find.byKey(Key('edit$x')));
        await tester.pump(Duration(seconds: 10));
        expect(find.byKey(Key('FinDocDialogSalesorder')), findsOneWidget);
        expect(Test.getTextFormField('description'),
            equals('orderName$random${char[x]}'));
        expect(Test.getDropdownSearch('customer'), contains('customer1'));
        expect(Test.getDropdownSearch('customer'),
            contains('newCompanyName${random}1'));
        expect(Test.getTextField('itemDescription1'), equals('productName1'));
        expect(Test.getTextField('itemQuantity1'), equals('${quantity[x]}'));
        expect(Test.getTextField('itemPrice1'),
            equals('${quantity[0]}.${quantity[0]}'));
        if (!Test.isPhone()) {
          expect(Test.getTextField('itemType1'), equals('Product'));
        }

        if (x == 1) {
          // update record 1 = b -> d, add product
          await tester.enterText(
              find.byKey(Key('description')), 'orderName${random}d');
          await tester.tap(find.byKey(Key('customer')));
          await tester.pump(Duration(seconds: 5));
          await tester.tap(find.textContaining('customer2').last);
          await tester.pump(Duration(seconds: 1));
          await tester.enterText(
              find.byKey(Key('description')), 'orderName${random}d');
          await tester.tap(find.byKey(Key('addProduct')));
          await tester.pump(Duration(seconds: 1));
          await tester.tap(find.byKey(Key('product')));
          await tester.pump(Duration(seconds: 3));
          await tester.tap(find.textContaining('productName2').last);
          await tester.pump(Duration(seconds: 1));
          await tester.enterText(find.byKey(Key('quantity')), '44');
          await tester.tap(find.byKey(Key('ok')));
          await tester.pump(Duration(seconds: 3));
          expect(Test.getDropdownSearch('customer'), contains('customer2'));
          expect(Test.getDropdownSearch('customer'),
              contains('newCompanyName${random}2'));
          expect(Test.getTextField('itemDescription2'), equals('productName2'));
          expect(Test.getTextField('itemPrice2'), equals('22.22'));
          expect(Test.getTextField('itemQuantity2'), equals('44'));
          expect(find.byKey(Key('productItem')), findsNWidgets(2));
          await tester.drag(find.byKey(Key('listView1')), Offset(0.0, -500.0));
          await tester.pump(Duration(seconds: 1));
          await tester.tap(find.byKey(Key('update')));
          await tester.pumpAndSettle(Duration(seconds: 10));
        } else {
          await tester.tap(find.byKey(Key('cancel')));
          await tester.pump(Duration(seconds: 5));
        }
      }
      expect(find.byKey(Key('finDocItem')), findsNWidgets(3));
      if (!Test.isPhone()) {
        // delete record 'x' x=2
        await tester.tap(find.byKey(Key('delete2')));
        await tester.pumpAndSettle(Duration(seconds: 1));
      }
    }, skip: false);

    testWidgets("orders  with physical products reload from database>>>>>",
        (WidgetTester tester) async {
      // 0: a   1: d 2: deleted
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('dbSales')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byKey(Key('FinDocsFormSalesOrder')), findsOneWidget);
      expect(
          find.byKey(Key('finDocItem')), findsNWidgets(Test.isPhone() ? 3 : 2));
      // check list
      char = ['a', 'd'];
      for (int x in [0, 1]) {
        expect(Test.getTextField('statusId$x'), equals('in Preparation'));
        expect(Test.getTextField('otherUser$x'),
            contains('newCompanyName$random${x + 1}'));
        expect(Test.getTextField('otherUser$x'), contains('customer${x + 1}'));
        if (!Test.isPhone()) {
          expect(Test.getTextField('email$x'),
              equals('e$random${x + 5}@example.org'));
          expect(Test.getTextField('description$x'),
              equals('orderName$random${char[x]}'));
        }
      }

      // detail screens
      for (int x in [0, 1]) {
        await tester.tap(find.byKey(Key('edit$x')));
        await tester.pump(Duration(seconds: 10));
        expect(find.byKey(Key('FinDocDialogSalesorder')), findsOneWidget);
        expect(Test.getTextFormField('description'),
            equals('orderName$random${char[x]}'));
        expect(Test.getDropdownSearch('customer'),
            contains('newCompanyName$random${x + 1}'));
        expect(
            Test.getDropdownSearch('customer'), contains('customer${x + 1}'));
        expect(find.byKey(Key('productItem')), findsNWidgets(x + 1));
        expect(Test.getTextField('itemDescription${x + 1}'),
            equals('productName${x + 1}'));
        quantity = ['11', '44'];
        List price = [11.11, 22.22];
        expect(Test.getTextField('itemQuantity${x + 1}'),
            equals('${quantity[x]}'));
        expect(Test.getTextField('itemPrice${x + 1}'), equals('${price[x]}'));
        if (!Test.isPhone()) {
          expect(Test.getTextField('itemType${x + 1}'), equals('Product'));
        }
        await tester.tap(find.byKey(Key('cancel')));
        await tester.pump(Duration(seconds: 5));
      }
    }, skip: false);
  });
}
