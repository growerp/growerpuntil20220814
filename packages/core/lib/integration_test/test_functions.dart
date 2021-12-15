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

import 'package:core/domains/domains.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../extensions.dart';

class Test {
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

  static Future<void> enterText(
      WidgetTester tester, String key, String value) async {
    var location = find.byKey(Key(key));
    await tester.tap(location);
    await tester.pump(Duration(milliseconds: 1000));
    await tester.enterText(location, value);
  }

  static Future<void> refresh(WidgetTester tester) async {
    await Test.drag(tester, down: false);
  }

  static Future<void> drag(WidgetTester tester, {bool down = true}) async {
    double offSet = -500.0;
    if (down == false) offSet = 500.0;
    await tester.drag(find.byKey(Key('listView'), skipOffstage: false).last,
        Offset(0.0, offSet));
    await tester.pumpAndSettle(Duration(seconds: 5));
  }

  static Future<void> tap(WidgetTester tester, String key,
      {int seconds = 5}) async {
    await tester.tap(find.byKey(Key(key), skipOffstage: false).last);
    await tester.pumpAndSettle(Duration(seconds: seconds));
  }

  static Future<void> login(WidgetTester tester, Widget topApp,
      {String? username, int days = 0}) async {
    CustomizableDateTime.customTime = DateTime.now().add(Duration(days: days));
    await tester.pumpWidget(topApp);
    await tester.pumpAndSettle(Duration(seconds: 10));
    // check if already logged with correct username
    String random = Test.getRandom();
    if (username == 'e$random@example.org') return;
    try {
      expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget);
    } catch (_) {
      // assumes still logged in, so logout
      print("Dashboard logged in , needs to logout");
      await Test.tap(tester, 'logoutButton');
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
          reason: '>>>logged out home screen not found');
    }
    await Test.tap(tester, 'loginButton');
    if (username != null) await Test.enterText(tester, 'username', username);
    await Test.enterText(tester, 'password', 'qqqqqq9!');
    await Test.tap(tester, 'login');
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byKey(Key('/')), findsOneWidget);
  }

  static Future<void> logout(WidgetTester tester) async {
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pump(Duration(seconds: 10));
    }
    await Test.tap(tester, 'tap/');
    await Test.tap(tester, 'logoutButton');
    await tester.pump(Duration(seconds: 5));
    expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget,
        reason: '>>>logged out home screen not found');
  }

  static Future<void> createCategoryFromMain(WidgetTester tester,
      {String? name}) async {
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pump(Duration(seconds: 10));
    }
    await Test.tap(tester, 'tap/catalog');
    if (Test.isPhone())
      await tester.tap(find.byTooltip('3'));
    else
      await Test.tap(tester, 'tapCategoriesForm');
    await tester.pump(Duration(seconds: 5));
    // enter categories
    for (int x = 1; x < 3; x++) {
      await Test.tap(tester, 'addNew');
      await Test.enterText(
          tester, 'name', name == null ? 'categoryName$x' : '$name$x');
      await Test.enterText(tester, 'description', 'categoryDesc$x');
      await Test.drag(tester);
      await Test.tap(tester, 'update');
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
    // back to main
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
    await Test.tap(tester, 'tap/');
  }

  static Future<void> createProductFromMain(WidgetTester tester,
      {String productType = 'Physical Good',
      classificationId = 'AppAdmin'}) async {
    if (classificationId != 'AppHotel') {
      await createCategoryFromMain(tester); // need a category to create test
    }
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pump(Duration(seconds: 10));
    }
    await Test.tap(tester, 'tap/catalog');
    if (Test.isPhone()) {
      if (classificationId == 'AppHotel') {
        await tester.tap(find.byTooltip('2'));
      } else {
        await tester.tap(find.byTooltip('1'));
      }
    } else
      await Test.tap(tester, 'tapProductsForm');
    // enter products
    for (int x = 1; x < 3; x++) {
      await Test.tap(tester, 'addNew');
      await tester.pump(Duration(seconds: 1));
      await Test.enterText(tester, 'name', 'productName$x');
      await Test.enterText(tester, 'description', 'productDesc$x');
      await Test.drag(tester);
      await Test.enterText(tester, 'price', '$x$x.$x$x');
      if (classificationId != 'AppHotel') {
        // uses single hotel category and standard type
        await Test.tap(tester, 'categoryDropDown');
        await tester.pumpAndSettle(Duration(seconds: 1));
        await tester.tap(find.text('categoryName$x').last);
        await tester.pumpAndSettle(Duration(seconds: 1));
        await Test.drag(tester);
        await Test.tap(tester, 'productTypeDropDown');
        await tester.pumpAndSettle(Duration(seconds: 1));
        await tester.tap(find.text(productType).last);
        await tester.pump(Duration(seconds: 1));
      }
      await Test.drag(tester);
      await Test.tap(tester, 'update');
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
    // back to main
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
    await Test.tap(tester, 'tap/');
    await tester.pumpAndSettle(Duration(seconds: 5));
  }

  static Future<void> createAssetFromMain(WidgetTester tester,
      {int quantity = 1, String classificationId = 'AppAdmin'}) async {
    await createProductFromMain(tester,
        productType: 'Rental', classificationId: classificationId);
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pump(Duration(seconds: 10));
    }
    await Test.tap(tester, 'tap/catalog');
    await tester.pumpAndSettle(Duration(seconds: 5));
    if (Test.isPhone())
      await tester
          .tap(find.byTooltip(classificationId == 'AppHotel' ? '1' : '2'));
    else
      await Test.tap(tester, 'tapAssetsForm');
    await tester.pumpAndSettle(Duration(seconds: 5));
    // enter assets
    for (int x in [1, 2, 3]) {
      await Test.tap(tester, 'addNew');
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('AssetDialog')), findsOneWidget);
      await Test.enterText(tester, 'name', 'assetName$x');
      if (classificationId != 'AppHotel')
        await Test.enterText(tester, 'quantityOnHand', '1');
      await Test.tap(tester, 'productDropDown');
      await tester.pump(Duration(seconds: 5));
      if (x == 3)
        await tester.tap(find.text('productName2').last);
      else
        await tester.tap(find.text('productName1').last);
      await tester.pump(Duration(seconds: 1));
      await Test.tap(tester, 'statusDropDown');
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.text('Available').last);
      await tester.pump(Duration(seconds: 1));
      await Test.drag(tester);
      await Test.tap(tester, 'update');
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
    // back to main
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
    await Test.tap(tester, 'tap/');
    await tester.pumpAndSettle(Duration(seconds: 5));
  }

  static Future<void> createCompanyAndAdmin(WidgetTester tester, Widget topApp,
      {bool demo = false}) async {
    String random = Random.secure().nextInt(1024).toString();
    await tester.pumpWidget(topApp);
    await tester.pumpAndSettle(Duration(seconds: 10));
    try {
      expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget);
    } catch (_) {
      // assumes still logged in, so logout
      print("Dashboard logged in , needs to logout");
      await Test.tap(tester, 'logoutButton');
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget);
    }
    // tap new company button, enter data
    await Test.tap(tester, 'newCompButton');
    await tester.pump(Duration(seconds: 3));
    await Test.enterText(tester, 'firstName', 'firstName');
    await Test.enterText(tester, 'lastName', 'lastName');
    await Test.enterText(tester, 'email', 'e$random@example.org');
    await Test.enterText(tester, 'companyName', 'companyName$random');
    await Test.drag(tester);

    await tester.pumpAndSettle();
    if (demo == false) await Test.tap(tester, 'demoData');
    await Test.tap(tester, 'newCompany');
    await tester.pumpAndSettle(Duration(seconds: 10)); // 5 not enough
    await Test.tap(tester, 'loginButton');
    await tester.pump(Duration(seconds: 1));
    await Test.enterText(tester, 'password', 'qqqqqq9!');
    await Test.tap(tester, 'login');
    await tester.pumpAndSettle(Duration(seconds: 5));
  }

  static Future<void> createUser(
      WidgetTester tester, String userType, String random) async {
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pump(Duration(seconds: 10));
    }
    switch (userType) {
      case 'employee':
        await Test.tap(tester, 'tap/company');
        if (isPhone())
          await tester.tap(find.byTooltip('3'));
        else
          await Test.tap(tester, 'tapUsersFormEmployee');
        await tester.pump(Duration(seconds: 5));
        expect(find.byKey(Key('UsersFormEmployee')), findsOneWidget);
        for (int x in [1, 2]) {
          await Test.tap(tester, 'addNew');
          await tester.pumpAndSettle(Duration(seconds: 5));
          await Test.enterText(tester, 'firstName', 'firstName$x');
          await Test.enterText(tester, 'lastName', 'employee$x');
          await Test.enterText(tester, 'username', '$random$x');
          await Test.drag(tester);
          await Test.enterText(tester, 'email', 'e$random$x@example.org');
          await Test.tap(tester, 'updateUser');
          await tester.pumpAndSettle(Duration(seconds: 5));
        }
        break;

      case 'lead':
        await Test.tap(tester, 'tap/crm');
        await tester.pump(Duration(seconds: 5));
        if (isPhone())
          await tester.tap(find.byTooltip('2'));
        else
          await Test.tap(tester, 'tapUsersFormLead');
        await tester.pump(Duration(seconds: 5));
        expect(find.byKey(Key('UsersFormLead')), findsOneWidget);
        for (int x in [3, 4]) {
          await Test.tap(tester, 'addNew');
          await tester.pumpAndSettle(Duration(seconds: 5));
          await Test.enterText(tester, 'firstName', 'firstName${x - 2}');
          await Test.enterText(tester, 'lastName', 'lead${x - 2}');
          await Test.enterText(tester, 'username', '$random$x');
          await Test.drag(tester);
          await Test.enterText(tester, 'email', 'e$random$x@example.org');
          await Test.enterText(
              tester, 'newCompanyName', 'newCompanyName$random${x - 2}');
          await Test.tap(tester, 'updateUser');
          await tester.pumpAndSettle(Duration(seconds: 5));
        }
        break;

      case 'customer':
        await Test.tap(tester, 'tap/sales');
        await tester.pump(Duration(seconds: 5));
        if (isPhone())
          await tester.tap(find.byTooltip('2'));
        else
          await Test.tap(tester, 'tapUsersFormCustomer');
        await tester.pump(Duration(seconds: 5));
        expect(find.byKey(Key('UsersFormCustomer')), findsOneWidget);
        for (int x in [5, 6]) {
          await Test.tap(tester, 'addNew');
          await tester.pumpAndSettle(Duration(seconds: 5));
          await Test.enterText(tester, 'firstName', 'firstName${x - 4}');
          await Test.enterText(tester, 'lastName', 'customer${x - 4}');
          await Test.enterText(tester, 'username', '$random$x');
          await Test.drag(tester);
          await Test.enterText(tester, 'email', 'e$random$x@example.org');
          await Test.enterText(
              tester, 'newCompanyName', 'newCompanyName$random${x - 4}');
          await Test.tap(tester, 'updateUser');
          await tester.pumpAndSettle(Duration(seconds: 5));
        }
        break;
    }
    // back to main
    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
    await Test.tap(tester, 'tap/');
    await tester.pumpAndSettle(Duration(seconds: 5));
  }

  static Future<void> createReservation(WidgetTester tester) async {
    var usFormat = new DateFormat('M/d/yyyy');
    DateTime today = DateTime.now();
    DateTime plus2 = today.add(Duration(days: 2));
    String plus2StringUs = usFormat.format(plus2);

    if (isPhone()) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pump(Duration(seconds: 10));
    }
    await Test.tap(tester, 'tap/sales');
    await tester.pumpAndSettle(Duration(seconds: 1));
    expect(find.byKey(Key('FinDocsFormSalesOrder')), findsOneWidget);
    for (int x in [1, 2]) {
      await Test.tap(tester, 'addNew');
      await tester.pump(Duration(seconds: 1));
      await Test.tap(tester, 'customer');
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.textContaining('customer$x').last);
      await tester.pump(Duration(seconds: 1));
      await Test.tap(tester, 'product');
      await tester.pump(Duration(seconds: 5));
      await tester.tap(find.textContaining('productName$x').last);
      await tester.pump(Duration(seconds: 1));
      await Test.tap(tester, 'setDate');
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.byTooltip('Switch to input'));
      await tester.pump(Duration(seconds: 1));
      if (x == 2) // x== 1 todays date filled in by default
        await tester.enterText(find.byType(TextField).last, plus2StringUs);
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump(Duration(seconds: 1));
      DateTime textField = DateTime.parse(Test.getTextField('date'));
      if (x == 1)
        expect(usFormat.format(textField), usFormat.format(today));
      else
        expect(usFormat.format(textField), usFormat.format(plus2));
      await tester.pump(Duration(seconds: 1));
      await Test.enterText(tester, 'quantity', x.toString());
      await tester.pump(Duration(seconds: 1));
      await Test.tap(tester, 'update');
      await tester.pumpAndSettle(Duration(seconds: 10));
    }
    await tester.drag(find.byKey(Key('listView')), Offset(0.0, 300.0));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byKey(Key('finDocItem')), findsNWidgets(2));
  }
}
