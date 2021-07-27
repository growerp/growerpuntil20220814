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
import 'package:core/widgets/observer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/integration_test/test_functions.dart';
import 'package:backend/moqui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('Category tests>>>>>', () {
    testWidgets("test Catalog tabs>>>>>", (WidgetTester tester) async {
      await Test.createCompanyAndAdmin(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      expect(find.byKey(Key('dbCatalog')), findsOneWidget);
      // use the catalog tap dashboard
      await tester.tap(find.byKey(Key('dbCatalog')));
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('/catalog')), findsOneWidget);
      expect(find.byKey(Key('ProductsForm')), findsOneWidget);
      expect(find.byKey(Key('empty')), findsOneWidget);
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapAssetsForm')));
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('AssetsForm')), findsOneWidget);
      expect(find.byKey(Key('empty')), findsOneWidget);
      if (Test.isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('tapCategoriesForm')));
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('CategoriesForm')), findsOneWidget);
      expect(find.byKey(Key('empty')), findsOneWidget);
    }, skip: false);

    testWidgets("categories test >>>>>", (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      String random = Test.getRandom();
      expect(find.byKey(Key('dbCatalog')), findsOneWidget);
      // use the catalog tap dashboard
      await tester.tap(find.byKey(Key('dbCatalog')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('tapCategoriesForm')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('CategoryDialog')), findsOneWidget);
      // enter category 'a'
      await tester.enterText(find.byKey(Key('name')), 'categoryName${random}a');
      await tester.enterText(
          find.byKey(Key('description')), 'categoryDesc${random}a');
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // add another one 'b' to update later to 'd
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(find.byKey(Key('name')), 'categoryName${random}b');
      await tester.enterText(
          find.byKey(Key('description')), 'categoryDesc${random}b');
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // add another one 'c' to delete
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(find.byKey(Key('name')), 'categoryName${random}c');
      await tester.enterText(
          find.byKey(Key('description')), 'categoryDesc${random}c');
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // now have 3 records
      expect(find.byKey(Key('categoryItem')), findsNWidgets(3));
      // check list
      expect(Test.getTextField('name0'), equals('categoryName${random}a'));
      if (!Test.isPhone())
        expect(Test.getTextField('description0'),
            equals('categoryDesc${random}a'));
      expect(Test.getTextField('name1'), equals('categoryName${random}b'));
      if (!Test.isPhone())
        expect(Test.getTextField('description1'),
            equals('categoryDesc${random}b'));
      expect(Test.getTextField('name2'), equals('categoryName${random}c'));
      if (!Test.isPhone())
        expect(Test.getTextField('description2'),
            equals('categoryDesc${random}c'));
      // check detail screen 'a'
      await tester.tap(find.text('categoryName${random}a'));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(Test.getTextFormField('name'), 'categoryName${random}a');
      expect(Test.getTextFormField('description'), 'categoryDesc${random}a');
      await tester.tap(find.byKey(Key('cancel')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check detail 'b' and update category b -> d
      await tester.tap(find.text('categoryName${random}b'));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(Test.getTextFormField('name'), 'categoryName${random}b');
      expect(Test.getTextFormField('description'), 'categoryDesc${random}b');
      await tester.enterText(find.byKey(Key('name')), 'categoryName${random}d');
      await tester.enterText(
          find.byKey(Key('description')), 'categoryDesc${random}d');
      await tester.tap(find.byKey(Key('update')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check list for changed d
      expect(Test.getTextField('name1'), equals('categoryName${random}d'));
      if (!Test.isPhone())
        expect(Test.getTextField('description1'),
            equals('categoryDesc${random}d'));
      // delete c at 2
      await tester.tap(find.byKey(Key('delete2')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('categoryItem')), findsNWidgets(2));
    }, skip: false);

    testWidgets("categories  reload from database>>>>>",
        (WidgetTester tester) async {
      // 0: a   1: d 2: deleted
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      String random = Test.getRandom();
      expect(find.byKey(Key('dbCatalog')), findsOneWidget);
      // use the catalog tap dashboard
      await tester.tap(find.byKey(Key('dbCatalog')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('tapCategoriesForm')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check list
      expect(find.byKey(Key('categoryItem')), findsNWidgets(2));
      expect(Test.getTextField('name0'), equals('categoryName${random}a'));
      if (!Test.isPhone())
        expect(Test.getTextField('description0'),
            equals('categoryDesc${random}a'));
      expect(Test.getTextField('name1'), equals('categoryName${random}d'));
      if (!Test.isPhone())
        expect(Test.getTextField('description1'),
            equals('categoryDesc${random}d'));
      // check detail screen of d
      await tester.tap(find.text('categoryName${random}d'));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(Test.getTextFormField('name'), 'categoryName${random}d');
      expect(Test.getTextFormField('description'), 'categoryDesc${random}d');
    }, skip: false);
  });
}
