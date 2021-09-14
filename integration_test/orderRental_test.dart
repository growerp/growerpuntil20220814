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
import 'package:intl/intl.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  DateTime today = DateTime.now();
  DateTime plus2 = today.add(Duration(days: 2));
  DateTime plus4 = today.add(Duration(days: 4));
  var usFormat = new DateFormat('M/d/yyyy');
  var intlFormat = new DateFormat('yyyy-MM-dd');
  String plus2StringUs = usFormat.format(plus2);
  String plus4StringUs = usFormat.format(plus4);
  String todayStringIntl = intlFormat.format(today);
  String plus2StringIntl = intlFormat.format(plus2);
  String plus4StringIntl = intlFormat.format(plus4);

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('Order Rental tests>>>>>', () {
    testWidgets("Prepare>>>>>>", (WidgetTester tester) async {
      await Test.createCompanyAndAdmin(
          tester,
          AdminApp(
              dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()));
      await Test.createAssetFromMain(tester);
      String random = Test.getRandom();
      await Test.createUser(tester, 'customer', random);
    }, skip: false);

    testWidgets("prepare &&  create 3 rental orders >>>>>",
        (WidgetTester tester) async {
      await Test.login(
        tester,
        AdminApp(
            dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()),
        //    username: 'e194@example.org'
      );
      await Test.tap(tester, 'dbSales');
      expect(find.byKey(Key('FinDocsFormSalesOrder')), findsOneWidget);
      for (int x in [1, 2, 3]) {
        await Test.tap(tester, 'addNew');
        await Test.tap(tester, 'customer');
        await tester.pumpAndSettle(Duration(seconds: 5));
        await tester.tap(find.textContaining('customer1').last);
        await tester.pumpAndSettle();
        await Test.tap(tester, 'itemRental');
        await tester.pumpAndSettle();
        await Test.tap(tester, 'product');
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('productName2').last);
        await tester.pump(Duration(seconds: 1));
        await Test.tap(tester, 'setDate');
        await tester.tap(find.byTooltip('Switch to input'));
        if (x == 2) // x== 1 todays date filled in by default
          await tester.enterText(find.byType(TextField).last, plus2StringUs);
        if (x == 3)
          await tester.enterText(find.byType(TextField).last, plus4StringUs);
        await tester.pump();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        DateTime textField = DateTime.parse(Test.getTextField('date'));
        if (x == 1) expect(usFormat.format(textField), usFormat.format(today));
        if (x == 2) expect(usFormat.format(textField), usFormat.format(plus2));
        if (x == 3) expect(usFormat.format(textField), usFormat.format(plus4));
        await tester.pump(Duration(seconds: 1));
        await Test.enterText(tester, 'quantity', x.toString());
        await Test.tap(tester, 'okRental');
        await Test.drag(tester);
        await Test.tap(tester, 'update');
        await tester.pumpAndSettle(Duration(seconds: 10));
      }
      expect(find.byKey(Key('finDocItem')), findsNWidgets(3));
    }, skip: false);

    testWidgets("check orders for rental data >>>>>",
        (WidgetTester tester) async {
      await Test.login(
          tester,
          AdminApp(
              dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()));
      //    username: 'e953@example.org');
      await Test.tap(tester, 'dbSales');
      expect(find.byKey(Key('FinDocsFormSalesOrder')), findsOneWidget);
      // check list
      for (int x in [0, 1, 2]) {
        expect(Test.getTextField('statusId$x'), equals('in Preparation'));
        await Test.tap(tester, 'ID$x');
        await tester.pump(Duration(seconds: 10));
        expect(
            Test.getTextField('itemLine$x'),
            contains(x == 0
                ? '$todayStringIntl'
                : x == 1
                    ? '$plus2StringIntl'
                    : '$plus4StringIntl'));
      }
    }, skip: false);
    testWidgets("check blocked dates for new reservation>>>>>",
        (WidgetTester tester) async {
      await Test.login(
          tester,
          AdminApp(
              dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()));
      //    username: 'e841@example.org');
      await Test.tap(tester, 'dbSales');
      expect(find.byKey(Key('FinDocsFormSalesOrder')), findsOneWidget);
      await Test.tap(tester, 'addNew');
      await Test.tap(tester, 'itemRental');
      await tester.pumpAndSettle();
      await Test.tap(tester, 'product');
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('productName2').last);
      await tester.pumpAndSettle();
      await Test.tap(tester, 'setDate');
      await tester.tap(find.byTooltip('Switch to input'));
      await tester.enterText(find.byType(TextField).last, plus2StringUs);
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text('Out of range.'), findsOneWidget);
      await tester.tap(find.text('CANCEL'));
      await tester.pump(Duration(seconds: 1));
      await Test.tap(tester, 'cancelRental');
      await Test.tap(tester, 'cancel');
    }, skip: false);
  });
}
