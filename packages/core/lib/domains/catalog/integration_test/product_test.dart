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

import 'package:core/domains/common/functions/persist_functions.dart';
import 'package:core/domains/integration_test.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/domains/domains.dart';
import 'package:collection/collection.dart';

class ProductTest {
  static Future<void> selectProduct(WidgetTester tester) async {
    if (find
        .byKey(Key('HomeFormAuth'))
        .toString()
        .startsWith('zero widgets with key')) {
      await CommonTest.gotoMainMenu(tester);
    }
    await CommonTest.selectOption(tester, 'dbCatalog', 'ProductListForm', '1');
  }

  static Future<void> addProducts(WidgetTester tester, List<Product> products,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    if (test.products.isEmpty) {
      // not yet created
      test = test.copyWith(products: products);
      expect(find.byKey(Key('userItem')), findsNWidgets(0)); // initial admin
      await enterProductData(tester, products);
      await PersistFunctions.persistTest(
          test.copyWith(products: products, sequence: seq));
    }
    if (check && test.products[0].productId.isEmpty) {
      await checkProductList(tester, products);
      List<Product> withProductId =
          await checkProductDetail(tester, test.products);
      await PersistFunctions.persistTest(test.copyWith(
        products: withProductId,
        sequence: seq,
      ));
    }
  }

  static Future<void> enterProductData(
      WidgetTester tester, List<Product> products) async {
    int index = 0;
    for (Product product in products) {
      if (product.productId.isEmpty)
        await CommonTest.tapByKey(tester, 'addNew');
      else {
        await CommonTest.tapByKey(tester, 'name$index');
        expect(
            CommonTest.getTextField('header').split('#')[1], product.productId);
      }
      await CommonTest.checkWidgetKey(tester, 'ProductDialog');
      await CommonTest.enterText(tester, 'name', product.productName!);
      await CommonTest.enterText(tester, 'description', product.description!);
      await CommonTest.drag(tester);
      await CommonTest.enterText(tester, 'price', product.price.toString());
      await CommonTest.enterDropDownSearch(
          tester, 'categoryDropDown', product.category!.categoryName!);
      await CommonTest.drag(tester);
      await CommonTest.enterDropDown(
          tester, 'productTypeDropDown', product.productTypeId!);
      await CommonTest.drag(tester);
      await CommonTest.tapByKey(tester, 'update', seconds: 5);
      await tester
          .pumpAndSettle(Duration(seconds: 2)); // for the message to disappear
      index++;
    }
  }

  static Future<void> checkProductList(
      WidgetTester tester, List<Product> products) async {
    await CommonTest.refresh(tester);
    expect(find.byKey(Key('productItem')), findsNWidgets(products.length));
    products.forEachIndexed((index, product) {
      expect(
          CommonTest.getTextField('name$index'), equals(product.productName));
      if (!CommonTest.isPhone())
        expect(CommonTest.getTextField('description$index'),
            equals(product.description));
    });
  }

  static Future<List<Product>> checkProductDetail(
      WidgetTester tester, List<Product> products) async {
    int index = 0;
    List<Product> newProducts = [];
    for (Product product in products) {
      await CommonTest.tapByKey(tester, 'name${index}');
      var id = CommonTest.getTextField('header').split('#')[1];
      expect(find.byKey(Key('ProductDialog')), findsOneWidget);
      expect(CommonTest.getTextFormField('name'), product.productName);
      expect(CommonTest.getTextFormField('description'), product.description);
      expect(CommonTest.getTextFormField('price'), product.price.toString());
      expect(CommonTest.getDropdownSearch('categoryDropDown'),
          contains(product.category!.categoryName!));
      expect(
          CommonTest.getDropdown('productTypeDropDown'), product.productTypeId);
      newProducts.add(product.copyWith(productId: id));
      index++;
      await CommonTest.tapByKey(tester, 'cancel');
    }
    return newProducts;
  }

  static Future<void> deleteProducts(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    int count = test.products.length;
    if (count != products.length) return;
    expect(
        find.byKey(Key('productItem')), findsNWidgets(count)); // initial admin
    await CommonTest.tapByKey(tester, 'delete${count - 1}', seconds: 5);
    expect(find.byKey(Key('productItem')), findsNWidgets(count - 1));
    test.products.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> updateProducts(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    // check if already modified then skip
    if (test.products[0].productName != products[0].productName) return;
    List<Product> updProducts = [];
    for (Product product in test.products) {
      updProducts.add(product.copyWith(
        productName: product.productName! + 'u',
        description: product.description! + 'u',
        category: categories[0],
        productTypeId: productTypes[0],
        price: product.price! + Decimal.parse('0.10'),
      ));
    }
    test = test.copyWith(products: updProducts);
    await enterProductData(tester, test.products);
    await checkProductDetail(tester, test.products);
    await PersistFunctions.persistTest(test);
  }
}
