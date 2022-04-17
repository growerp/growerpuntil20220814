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

import 'dart:io';
import 'package:core/domains/common/functions/functions.dart';
import 'package:core/widgets/observer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:core/domains/domains.dart';
import 'package:integration_test/integration_test.dart';

class CommonTest {
  String classificationId = GlobalConfiguration().get("classificationId");

  static Future<void> startApp(WidgetTester tester, Widget TopApp,
      {bool clear = false}) async {
    SaveTest test = await PersistFunctions.getTest();
    int seq = test.sequence + 100;
    if (clear == true) {
      await PersistFunctions.persistTest(SaveTest(sequence: seq));
    } else {
      await PersistFunctions.persistTest(test.copyWith(sequence: seq));
    }
    await BlocOverrides.runZoned(
        () async => await tester.pumpWidget(Phoenix(child: TopApp)),
        blocObserver: AppBlocObserver());
    await tester.pumpAndSettle(Duration(seconds: 5));
  }

  static takeScreenshot(WidgetTester tester,
      IntegrationTestWidgetsFlutterBinding binding, String name) async {
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
    }
    await binding.takeScreenshot(name);
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

  static Future<void> login(WidgetTester tester,
      {String? username, String? password}) async {
    SaveTest test = await PersistFunctions.getTest();
    if ((test.company == null || test.admin == null) &&
        (username == null || password == null)) {
      print("Need company test to be run first");
      return;
    }
    if (find
        .byKey(Key('HomeFormAuth'))
        .toString()
        .startsWith('zero widgets with key')) {
      await pressLoginWithExistingId(tester);
      await enterText(
          tester, 'username', username == null ? test.admin!.email! : username);
      await enterText(
          tester, 'password', password == null ? 'qqqqqq9!' : password);
      await pressLogin(tester);
      await checkText(tester, 'Main'); // dashboard
    }
  }

  static Future<void> gotoMainMenu(WidgetTester tester) async {
    await selectMainMenu(tester, "tap/");
  }

  static Future<void> doSearch(WidgetTester tester,
      {required String searchString, int seconds = 5}) async {
    if (find
        .byKey(Key('searchButton'))
        .toString()
        .startsWith('zero widgets with key')) {
      await tapByKey(tester, 'search');
    }
    await enterText(tester, 'searchField', searchString);
    await tapByKey(tester, 'searchButton', seconds: seconds);
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

  // low level ------------------------------------------------------------

  static Future<void> checkWidgetKey(WidgetTester tester, String widgetKey,
      [int count = 1]) async {
    expect(find.byKey(Key(widgetKey)), findsNWidgets(count));
  }

  static Future<bool> doesExistKey(WidgetTester tester, String widgetKey,
      [int count = 1]) async {
    if (find
        .byKey(Key(widgetKey))
        .toString()
        .startsWith('zero widgets with key')) return false;
    return true;
  }

  static Future<void> checkText(WidgetTester tester, String text) async {
    expect(find.textContaining(RegExp(text, caseSensitive: false)).last,
        findsOneWidget);
  }

  /// [lowLevel]
  static Future<void> drag(WidgetTester tester,
      {int seconds = 1,
      String listViewName = 'listView',
      offset = -200.0}) async {
    await tester.drag(find.byKey(Key(listViewName)).last, Offset(0.0, offset));
    await tester.pumpAndSettle(Duration(seconds: seconds));
  }

  /// [lowLevel]
  static Future<void> refresh(WidgetTester tester,
      {int seconds = 5, String listViewName = 'listView'}) async {
    await drag(tester,
        offset: 200.0, seconds: seconds, listViewName: listViewName);
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
    if (tff.selectedItem is User) return tff.selectedItem.companyName;
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

  static bool getCheckbox(String key) {
    Checkbox tff = find.byKey(Key(key)).evaluate().single.widget as Checkbox;
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

  static Future<void> tapByTooltip(WidgetTester tester, String text,
      {int seconds = 1}) async {
    await tester.tap(find.byTooltip(text));
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

  static int getWidgetCountByKey(WidgetTester tester, String key) {
    var finder = find.byKey(Key(key));
    return tester.widgetList(finder).length;
  }

  static Future<void> updateAddress(
      WidgetTester tester, Address address) async {
    await drag(tester);
    await tapByKey(tester, 'address');
    await enterText(tester, 'address1', address.address1!);
    await enterText(tester, 'address2', address.address2!);
    await enterText(tester, 'postalCode', address.postalCode!);
    await enterText(tester, 'city', address.city!);
    await enterText(tester, 'province', address.province!);
    await drag(tester);
    await enterDropDownSearch(tester, 'country', address.country!);
    await drag(tester);
    await tapByKey(tester, 'updateAddress', seconds: 5);
  }

  static Future<void> checkAddress(WidgetTester tester, Address address) async {
    await drag(tester);
    await tapByKey(tester, 'address');
    expect(getTextFormField('address1'), contains(address.address1!));
    expect(getTextFormField('address2'), contains(address.address2!));
    expect(getTextFormField('postalCode'), contains(address.postalCode));
    expect(getTextFormField('city'), contains(address.city!));
    expect(getTextFormField('province'), equals(address.province!));
    expect(getDropdownSearch('country'), equals(address.country));
    await tapByKey(tester, 'cancel');
  }

  static Future<void> updatePaymentMethod(
      WidgetTester tester, PaymentMethod paymentMethod) async {
    await drag(tester);
    await tapByKey(tester, 'paymentMethod');
    await enterDropDown(
        tester, 'cardTypeDropDown', paymentMethod.creditCardType.toString());
    await enterText(
        tester, 'creditCardNumber', paymentMethod.creditCardNumber!);
    await enterText(tester, 'expireMonth', paymentMethod.expireMonth!);
    await enterText(tester, 'expireYear', paymentMethod.expireYear!);
    await tapByKey(tester, 'updatePaymentMethod', seconds: 5);
    await tester.pumpAndSettle(Duration(seconds: 5));
  }

  static Future<void> checkPaymentMethod(
      WidgetTester tester, PaymentMethod paymentMethod) async {
    int length = paymentMethod.creditCardNumber!.length;
    await drag(tester);
    expect(
        getTextField('paymentMethodLabel'),
        contains(
            paymentMethod.creditCardNumber!.substring(length - 4, length)));
    expect(getTextField('paymentMethodLabel'),
        contains(paymentMethod.expireMonth! + '/'));
    expect(getTextField('paymentMethodLabel'),
        contains(paymentMethod.expireYear!));
  }
}
