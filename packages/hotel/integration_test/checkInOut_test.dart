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

import 'package:hotel/main.dart';
import 'package:dio/dio.dart';
import 'package:core/integration_test/test_functions.dart';
import 'package:backend/moqui.dart';
import 'package:core/widgets/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';
import 'package:core/extensions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  DateTime today = CustomizableDateTime.current;
  DateTime plus2 = today.add(Duration(days: 2));
  var usFormat = new DateFormat('M/d/yyyy');
  var intlFormat = new DateFormat('yyyy-MM-dd');
  String plus2StringUs = usFormat.format(plus2);
  String todayStringUs = usFormat.format(today);
  String todayStringIntl = intlFormat.format(today);
  String plus2StringIntl = intlFormat.format(plus2);

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('Check in/out Hotel tests>>>>>', () {
    testWidgets("Prepare>>>>>>", (WidgetTester tester) async {
      await Test.createCompanyAndAdmin(
          tester, HotelApp(repos: Moqui(client: Dio())));
      await Test.login(tester, HotelApp(repos: Moqui(client: Dio())));
      await Test.createAssetFromMain(tester);
      await Test.createUser(tester, 'customer', Test.getRandom());
      await Test.createReservation(tester);
    }, skip: false);

    testWidgets("Test checkin >>>>>", (WidgetTester tester) async {
      await Test.login(tester, HotelApp(repos: Moqui(client: Dio())));
      if (Test.isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pump(Duration(seconds: 10));
      }
      await tester.tap(find.byKey(Key('tap/checkInOut')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byKey(Key('FinDocsFormCheckIn')), findsOneWidget);
      expect(find.byKey(Key('finDocItem')), findsNWidgets(1));
      expect(Test.getTextField('statusId0'), equals('Created'));
      await tester.tap(find.byKey(Key('ID0')));
      await tester.pump(Duration(seconds: 10));
      expect(Test.getTextField('itemLine0'), contains('$todayStringIntl'));
      await tester.tap(find.byKey(Key('nextStatus')));
      await tester.pump(Duration(seconds: 10));
    }, skip: false);

    testWidgets("Test checkout >>>>>", (WidgetTester tester) async {
      await Test.login(tester, HotelApp(repos: Moqui(client: Dio())), days: 1);
      if (Test.isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pump(Duration(seconds: 10));
      }
      await tester.tap(find.byKey(Key('tap/checkInOut')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('FinDocsFormCheckIn')), findsOneWidget);
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapFinDocsFormCheckOut')));
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('FinDocsFormCheckOut')), findsOneWidget);
      // refresh screen
      await tester.drag(find.byKey(Key('listView')), Offset(0.0, 500.0));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('finDocItem')), findsNWidgets(1));
      expect(Test.getTextField('statusId0'), equals('Checked In'));
      await tester.tap(find.byKey(Key('ID0')));
      await tester.pump(Duration(seconds: 10));
      expect(Test.getTextField('itemLine0'), contains('$todayStringIntl'));
      await tester.tap(find.byKey(Key('nextStatus')));
      await tester.pump(Duration(seconds: 10));
    }, skip: false);

    testWidgets("Test empty checkin and checkout >>>>>",
        (WidgetTester tester) async {
      await Test.login(tester, HotelApp(repos: Moqui(client: Dio())));
      //  username: 'e87@example.org');
      if (Test.isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pump(Duration(seconds: 10));
      }
      await tester.tap(find.byKey(Key('tap/checkInOut')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('finDocItem')), findsNothing);
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapFinDocsFormCheckOut')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('finDocItem')), findsNothing);
    }, skip: false);
  });
}
