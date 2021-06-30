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
import 'package:core/forms/@forms.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backend/moqui.dart';
import 'package:models/@models.dart';

class Test {
  static String getDropdownSearch(String key) {
    DropdownSearch tff =
        find.byKey(Key(key)).evaluate().single.widget as DropdownSearch;
    if (tff.selectedItem is ProductCategory)
      return tff.selectedItem.categoryName;
    if (tff.selectedItem is Product) return tff.selectedItem.productName;
    return tff.selectedItem.toString();
  }

  static String getTextFormField(String key) {
    TextFormField tff =
        find.byKey(Key(key)).evaluate().single.widget as TextFormField;
    return tff.controller!.text;
  }

  static String getTextField(String key) {
    Text tf = find.byKey(Key(key)).evaluate().single.widget as Text;
    return tf.data!;
  }

  static String getRandom() {
    Text tff =
        find.byKey(Key('appBarCompanyName')).evaluate().single.widget as Text;
    return tff.data!.replaceAll(new RegExp(r'[^0-9]'), '');
  }

  static bool isPhone() {
    try {
      expect(find.byTooltip('Open navigation menu'), findsOneWidget);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> login(WidgetTester tester) async {
    await tester.pumpWidget(
        RestartWidget(child: AdminApp(repos: Moqui(client: Dio()))));
    await tester.pumpAndSettle(Duration(seconds: 5));
    try {
      expect(find.byKey(Key('DashBoardForm')), findsOneWidget);
    } catch (_) {
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(find.byKey(Key('password')), 'qqqqqq9!');
      await tester.tap(find.byKey(Key('login')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('/')), findsOneWidget);
    }
  }

  static Future<void> logout(WidgetTester tester) async {
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle(Duration(seconds: 10));
    }
    await tester.tap(find.byKey(Key('tap/')));
    await tester.tap(find.byKey(Key('logoutButton')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
        reason: '>>>logged out home screen not found');
  }

  static Future<void> createCategoryFromMain(WidgetTester tester) async {
    await tester.tap(find.byKey(Key('dbCatalog')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    if (Test.isPhone())
      await tester.tap(find.byTooltip('3'));
    else
      await tester.tap(find.byKey(Key('CategoriesForm')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    // enter new category
    await tester.tap(find.byKey(Key('addNew')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    await tester.enterText(find.byKey(Key('name')), 'categoryName1');
    await tester.enterText(find.byKey(Key('description')), 'categoryDesc1');
    await tester.tap(find.byKey(Key('update')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('addNew')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    await tester.enterText(find.byKey(Key('name')), 'categoryName2');
    await tester.enterText(find.byKey(Key('description')), 'categoryDesc2');
    await tester.tap(find.byKey(Key('update')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    // back to main
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
    await tester.tap(find.byKey(Key('tap/')));
    await tester.pumpAndSettle(Duration(seconds: 5));
  }

  static Future<void> createProductFromMain(WidgetTester tester) async {
    await createCategoryFromMain(tester); // need a category to create test
    await tester.tap(find.byKey(Key('dbCatalog')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    if (Test.isPhone())
      await tester.tap(find.byTooltip('1'));
    else
      await tester.tap(find.byKey(Key('ProductsForm')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('addNew')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byKey(Key('ProductDialog')), findsOneWidget);
    // enter category
    await tester.enterText(find.byKey(Key('name')), 'productName1');
    await tester.enterText(find.byKey(Key('description')), 'productDesc1');
    await tester.enterText(find.byKey(Key('price')), '11.11');
    await tester.tap(find.byKey(Key('categoryDropDown')));
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.text('categoryName1').last);
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('update')));
    await tester.pumpAndSettle(Duration(seconds: 5));
    // back to main
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
    await tester.tap(find.byKey(Key('tap/')));
    await tester.pumpAndSettle(Duration(seconds: 5));
  }
}
