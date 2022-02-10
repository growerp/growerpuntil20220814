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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/domains/domains.dart';
import 'package:collection/collection.dart';

class CategoryTest {
  static Future<void> selectCategory(WidgetTester tester) async {
    if (find
        .byKey(Key('HomeFormAuth'))
        .toString()
        .startsWith('zero widgets with key')) {
      await CommonTest.gotoMainMenu(tester);
    }
    await CommonTest.selectOption(tester, 'dbCatalog', 'CategoryListForm', '3');
  }

  static Future<void> addCategories(
      WidgetTester tester, List<Category> categories,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    if (test.categories.isEmpty) {
      // not yet created
      test = test.copyWith(categories: categories);
      await enterCategoryData(tester, categories);
      await PersistFunctions.persistTest(
          test.copyWith(categories: categories, sequence: seq));
    }
    if (check) {
      await checkCategoryList(tester, categories);
      await PersistFunctions.persistTest(test.copyWith(
        categories: await checkCategoryDetail(tester, test.categories),
        sequence: seq,
      ));
    }
  }

  static Future<void> enterCategoryData(
      WidgetTester tester, List<Category> categories) async {
    int index = 0;
    for (Category category in categories) {
      if (category.categoryId.isEmpty)
        await CommonTest.tapByKey(tester, 'addNew');
      else {
        await CommonTest.tapByKey(tester, 'name$index');
        expect(CommonTest.getTextField('header').split('#')[1],
            category.categoryId);
      }
      await CommonTest.checkWidgetKey(tester, 'CategoryDialog');
      await CommonTest.tapByKey(
          tester, 'name'); // required because keyboard come up
      await CommonTest.enterText(tester, 'name', category.categoryName!);
      await CommonTest.enterText(tester, 'description', category.description!);
      await CommonTest.drag(tester);
      await CommonTest.tapByKey(tester, 'update', seconds: 5);
      await tester.pumpAndSettle(); // for the message to disappear
      index++;
    }
  }

  static Future<void> checkCategoryList(
      WidgetTester tester, List<Category> categories) async {
    await CommonTest.refresh(tester);
    categories.forEachIndexed((index, category) {
      expect(CommonTest.getTextField('name${index}'),
          equals('${category.categoryName!}'));
    });
  }

  static Future<List<Category>> checkCategoryDetail(
      WidgetTester tester, List<Category> categories) async {
    int index = 0;
    for (Category category in categories) {
      await CommonTest.tapByKey(tester, 'name${index}');
      var id = CommonTest.getTextField('header').split('#')[1];
      expect(find.byKey(Key('CategoryDialog')), findsOneWidget);
      expect(
          CommonTest.getTextFormField('name'), equals(category.categoryName!));
      expect(CommonTest.getTextFormField('description'),
          equals(category.description!));
      categories[index] = categories[index].copyWith(categoryId: id);
      index++;
      await CommonTest.tapByKey(tester, 'cancel');
    }
    return categories;
  }

  static Future<void> deleteCategories(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    int count = test.categories.length;
    if (count != categories.length) return;
    expect(
        find.byKey(Key('categoryItem')), findsNWidgets(count)); // initial admin
    await CommonTest.tapByKey(tester, 'delete${count - 1}', seconds: 5);
    expect(find.byKey(Key('categoryItem')), findsNWidgets(count - 1));
    test.categories.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> updateCategories(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    // check if already modified then skip
    if (test.categories[0].categoryName != categories[0].categoryName) return;
    List<Category> updCategories = [];
    for (Category category in test.categories) {
      updCategories.add(category.copyWith(
        categoryName: category.categoryName! + 'u',
        description: category.description! + 'u',
      ));
    }
    test = test.copyWith(categories: updCategories);
    await enterCategoryData(tester, test.categories);
    await checkCategoryDetail(tester, test.categories);
    await PersistFunctions.persistTest(test);
  }
}
