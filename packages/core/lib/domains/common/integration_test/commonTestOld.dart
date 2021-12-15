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

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../domains.dart';

class CommonTest {
  String classificationId = GlobalConfiguration().get("classificationId");

  static Future<void> checkWidgetKey(
      WidgetTester tester, String widgetKey) async {
    expect(find.byKey(Key(widgetKey)), findsOneWidget);
  }

  static Future<void> checkText(WidgetTester tester, String text) async {
    expect(find.text(text), findsOneWidget);
  }

  static Future<void> drag(WidgetTester tester,
      {bool downPage = true, int seconds = 2}) async {
    double offSet = -500.0;
    if (downPage == false) offSet = 500.0;
    await tester.drag(find.byKey(Key('listView')).last, Offset(0.0, offSet));
    await tester.pumpAndSettle(Duration(seconds: seconds));
  }

  static Future<void> enterText(
      WidgetTester tester, String key, String value) async {
    var location = find.byKey(Key(key));
    await tester.tap(location);
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(location, value);
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

  static bool isPhone() {
    try {
      expect(find.byTooltip('Open navigation menu'), findsOneWidget);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> selectMainMenu(
      WidgetTester tester, String menuItem) async {
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pump(Duration(seconds: 10));
    }
    await tap(tester, menuItem);
  }

  static Future<void> tap(WidgetTester tester, String key,
      {int seconds = 1}) async {
    await tester.tap(find.byKey(Key(key)).last);
    await tester.pumpAndSettle(Duration(seconds: seconds));
  }

  static Future<void> selectDropDown(
      WidgetTester tester, String key, String value) async {
    var location = find.byKey(Key(key));
    await tester.tap(location.last);
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.text(value).last);
    await tester.pump(Duration(seconds: 1));
  }

  static String getRandom() {
    Text tff =
        find.byKey(Key('appBarCompanyName')).evaluate().single.widget as Text;
    return tff.data!.replaceAll(new RegExp(r'[^0-9]'), '');
  }
}
