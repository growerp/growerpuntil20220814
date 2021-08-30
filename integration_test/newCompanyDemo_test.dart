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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('New Company demo data test repare>>>>>', () {
    testWidgets("Prepare>>>>>>", (WidgetTester tester) async {
      await Test.createCompanyAndAdmin(
          tester, AdminApp(dbServer: MoquiServer(client: Dio())),
          demo: true);
    }, skip: false);

    testWidgets("check categories >>>>>>", (WidgetTester tester) async {
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
//          username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbCatalog')));
      await tester.pump(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('tapCategoriesForm')));
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('categoryItem')), findsWidgets);
    }, skip: false);

    testWidgets("check assets >>>>>>", (WidgetTester tester) async {
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
//          username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbCatalog')));
      await tester.pump(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapAssetsForm')));
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('assetItem')), findsWidgets);
    }, skip: false);

    testWidgets("check products >>>>>>", (WidgetTester tester) async {
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
//          username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbCatalog')));
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('productItem')), findsWidgets);
    }, skip: false);

    testWidgets("check opportunities >>>>>>", (WidgetTester tester) async {
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
//          username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbCrm')));
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('opportunityItem')), findsWidgets);
    }, skip: false);

    testWidgets("check users >>>>>>", (WidgetTester tester) async {
      await Test.login(tester, AdminApp(dbServer: MoquiServer(client: Dio())));
//          username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbCompany')));
      await tester.pump(Duration(seconds: 5));
      // employees
      if (Test.isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormEmployee')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsWidgets);
      // admins
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormEmployee')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsWidgets);
      // main menu
      if (Test.isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pump(Duration(seconds: 1));
      }
      await tester.tap(find.byKey(Key('tap/')));
      await tester.pump(Duration(seconds: 1));
      // crm
      await tester.tap(find.byKey(Key('dbCrm')));
      await tester.pump(Duration(seconds: 1));
      // leads
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormLead')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsWidgets);
      // customers
      if (Test.isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormCustomer')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsWidgets);
      // main menu
      if (Test.isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pump(Duration(seconds: 1));
      }
      await tester.tap(find.byKey(Key('tap/')));
      await tester.pump(Duration(seconds: 1));
      // sales
      await tester.tap(find.byKey(Key('dbSales')));
      await tester.pump(Duration(seconds: 5));
      // sales customers
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormCustomer')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsWidgets);
      // main menu
      if (Test.isPhone()) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pump(Duration(seconds: 1));
      }
      await tester.tap(find.byKey(Key('tap/')));
      await tester.pump(Duration(seconds: 1));
      // purchase
      await tester.tap(find.byKey(Key('dbPurchase')));
      await tester.pump(Duration(seconds: 1));
      // purchase suppliers
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormSupplier')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsWidgets);
    }, skip: false);
  });
}
