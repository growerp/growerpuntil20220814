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

import 'package:core/domains/common/functions/functions.dart';
import 'package:core/widgets/observer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:core/domains/domains.dart';

import '../../integration_test.dart';

class CommonTest {
  String classificationId = GlobalConfiguration().get("classificationId");

  static Future<void> startApp(WidgetTester tester, Widget TopApp,
      {bool clear = false}) async {
    SaveTest test = await PersistFunctions.getTest();
    seq = test.sequence == null ? 0 : test.sequence! + 10;
    if (clear) {
      await PersistFunctions.persistTest(SaveTest(sequence: seq));
    } else {
      await PersistFunctions.persistTest(test.copyWith(sequence: seq));
    }
    await BlocOverrides.runZoned(
        () async => await tester.pumpWidget(Phoenix(child: TopApp)),
        blocObserver: AppBlocObserver());
    await tester.pumpAndSettle(Duration(seconds: 10));
  }

  static Future<void> selectOption(
      WidgetTester tester, String option, String formName,
      [String? tapNumber]) async {
    if (!option.startsWith('accnt')) await gotoMainMenu(tester);
    await tapByKey(tester, option, seconds: 3);
    if (tapNumber != null) {
      if (isPhone())
        await tester.tap(find.byTooltip(tapNumber));
      else
        await tester.tap(find.byKey(Key("tap$formName")));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
    await checkWidgetKey(tester, formName);
  }

  static Future<void> login(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    if (test.company == null || test.admin == null) {
      print("Need company test to be run first");
      return;
    }
    await tester.pumpAndSettle(Duration(seconds: 5));
    if (find
        .byKey(Key('HomeFormAuth'))
        .toString()
        .startsWith('zero widgets with key')) {
      await pressLoginWithExistingId(tester);
      await enterText(tester, 'username', test.admin!.email!);
      await enterText(tester, 'password', 'qqqqqq9!');
      await pressLogin(tester);
      await checkText(tester, 'Main'); // dashboard
    }
  }

  static Future<void> gotoMainMenu(WidgetTester tester) async {
    await selectMainMenu(tester, "tap/");
  }

  static Future<void> refresh(WidgetTester tester) async {
    await drag(tester, downPage: false);
  }

  static Future<void> doSearch(WidgetTester tester,
      {required String searchString}) async {
    if (find
        .byKey(Key('searchButton'))
        .toString()
        .startsWith('zero widgets with key')) {
      await refresh(tester);
      await tapByKey(tester, 'search');
    }
    await enterText(tester, 'searchField', searchString);
    await tapByKey(tester, 'searchButton', seconds: 5);
  }

  static Future<void> closeSearch(WidgetTester tester) async {
    if (!find
        .byKey(Key('searchButton'))
        .toString()
        .startsWith('zero widgets with key')) {
      await tapByKey(tester, 'search'); // cancel search
    }
  }

  static Future<void> pressLoginWithExistingId(WidgetTester tester) async {
    await tapByKey(tester, 'loginButton', seconds: 1);
  }

  static Future<void> pressLogin(WidgetTester tester) async {
    await tapByKey(tester, 'login', seconds: 5);
  }

  static Future<void> logout(WidgetTester tester) async {
    if (hasKey('HomeFormUnAuth')) return; // already logged out
    await gotoMainMenu(tester);
    if (hasKey('HomeFormAuth')) {
      print("Dashboard logged in , needs to logout");
      await tapByKey(tester, 'logoutButton');
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget);
    }
  }

  // lowlevel ------------------------------------------------------------

  static Future<void> checkWidgetKey(WidgetTester tester, String widgetKey,
      [int count = 1]) async {
    expect(find.byKey(Key(widgetKey)), findsNWidgets(count));
  }

  static Future<void> checkText(WidgetTester tester, String text) async {
    expect(find.textContaining(RegExp(text, caseSensitive: false)).last,
        findsOneWidget);
  }

  static Future<void> drag(WidgetTester tester,
      {bool downPage = true,
      int seconds = 2,
      String listViewName = 'listView'}) async {
    double offSet = -200.0;
    if (downPage == false) offSet = 200.0;
    await tester.drag(find.byKey(Key(listViewName)).last, Offset(0.0, offSet));
    await tester.pumpAndSettle(Duration(seconds: seconds));
  }

  static Future<void> enterText(
      WidgetTester tester, String key, String value) async {
    await tester.tap(find.byKey(Key(key)));
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(find.byKey(Key(key)), value);
    await tester.pump();
  }

  static Future<void> pump(WidgetTester tester, [int times = 3]) async {
    while (--times > 0) await tester.pump();
  }

  static Future<void> enterDropDownSearch(
      WidgetTester tester, String key, String value,
      {int seconds = 1}) async {
    await tapByKey(tester, key);
    await tester.enterText(find.byType(TextField).first, value);
    await tester.pumpAndSettle(Duration(seconds: 5)); // wait for search result
    await tester
        .tap(find.textContaining(RegExp(value, caseSensitive: false)).last);
    await tester.pumpAndSettle(Duration(seconds: seconds));
  }

  static Future<void> enterDropDown(
      WidgetTester tester, String key, String value,
      {int seconds = 1}) async {
    var location = find.byKey(Key(key));
    await tester.tap(location);
    await tester.pumpAndSettle(Duration(seconds: seconds));
    await tester.tap(find.textContaining(value).last);
    await tester.pump(Duration(seconds: 1));
  }

  static String getDropdown(String key) {
    DropdownButtonFormField tff = find.byKey(Key(key)).evaluate().single.widget
        as DropdownButtonFormField;
    if (tff.initialValue is Currency) return tff.initialValue.description;
    if (tff.initialValue is UserGroup) return tff.initialValue.toString();
    return tff.initialValue;
  }

  static String getDropdownSearch(String key) {
    DropdownSearch tff =
        find.byKey(Key(key)).evaluate().single.widget as DropdownSearch;
    if (tff.selectedItem is Country) return tff.selectedItem.name;
    if (tff.selectedItem is Category) return tff.selectedItem.categoryName;
    if (tff.selectedItem is Product) return tff.selectedItem.productName;
    return tff.selectedItem.toString();
  }

  static String getTextField(String key) {
    Text tf = find.byKey(Key(key)).evaluate().single.widget as Text;
    return tf.data!;
  }

  static String getTextFormField(String key) {
    TextFormField tff =
        find.byKey(Key(key)).evaluate().single.widget as TextFormField;
    return tff.controller!.text;
  }

  static bool getCheckBox(String key) {
    CheckboxListTile tff =
        find.byKey(Key(key)).evaluate().single.widget as CheckboxListTile;
    return tff.value ?? false;
  }

  static bool isPhone() {
    try {
      expect(find.byTooltip('Open navigation menu'), findsOneWidget);
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool hasKey(String key) {
    if (find.byKey(Key(key)).toString().startsWith('zero widgets with key'))
      return false;
    return true;
  }

  static Future<void> selectMainMenu(
      WidgetTester tester, String menuItem) async {
    if (!hasKey('HomeFormAuth')) {
      if (isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pump();
        await tester.pumpAndSettle(Duration(seconds: 5));
      }
      await tapByKey(tester, menuItem);
    }
  }

  static Future<void> tapByKey(WidgetTester tester, String key,
      {int seconds = 1}) async {
    await tester.tap(find.byKey(Key(key)).last);
    await tester.pumpAndSettle(Duration(seconds: seconds));
  }

  static Future<void> tapByText(WidgetTester tester, String text,
      {int seconds = 1}) async {
    await tester
        .tap(find.textContaining(RegExp(text, caseSensitive: false)).last);
    await tester.pumpAndSettle(Duration(seconds: seconds));
  }

  static Future<void> selectDropDown(
      WidgetTester tester, String key, String value,
      {seconds: 1}) async {
    await tapByKey(tester, key, seconds: seconds);
    await tapByText(tester, value);
  }

  static String getRandom() {
    Text tff =
        find.byKey(Key('appBarCompanyName')).evaluate().single.widget as Text;
    return tff.data!.replaceAll(new RegExp(r'[^0-9]'), '');
  }
}
