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
import 'package:backend/moqui.dart';
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

  group('User Test >>>>>', () {
    testWidgets("Prepare new company with admin>>>>>>",
        (WidgetTester tester) async {
      await Test.createCompanyAndAdmin(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
    }, skip: false);

    testWidgets("create/delete employee >>>>>>", (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //  username: 'e771@example.org');
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('dbCompany')));
      await tester.pump(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormEmployee')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsNothing);
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pump();
      expect(find.byKey(Key('UserDialogEmployee')), findsOneWidget);
      await tester.enterText(find.byKey(Key('firstName')), 'firstName');
      await tester.enterText(find.byKey(Key('lastName')), 'lastName');
      await tester.enterText(find.byKey(Key('username')), '${random}1');
      await tester.enterText(
          find.byKey(Key('email')), 'e${random}1@example.org');
      await tester.tap(find.byKey(Key('updateUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check userlist
      expect(find.byKey(Key('userItem')), findsOneWidget);
      expect(Test.getTextField('name0'), contains('firstName'));
      expect(Test.getTextField('name0'), contains('lastName'));
      expect(Test.getTextField('email0'), equals('e${random}1@example.org'));
      if (!Test.isPhone()) {
        expect(Test.getTextField('username0'), equals('${random}1'));
      }
      await tester.tap(find.byKey(Key('delete0')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('userItem')), findsNothing);
    }, skip: false);
    testWidgets("check delete employee>>>>>>", (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //  username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbCompany')));
      await tester.pump(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormEmployee')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsNothing);
    }, skip: false);

    testWidgets("create/delete admin >>>>>>", (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //  username: 'e771@example.org');
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('dbCompany')));
      await tester.pump(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormAdmin')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsOneWidget);
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pump();
      expect(find.byKey(Key('UserDialogAdmin')), findsOneWidget);
      await tester.enterText(find.byKey(Key('firstName')), 'firstName');
      await tester.enterText(find.byKey(Key('lastName')), 'lastName');
      await tester.enterText(find.byKey(Key('username')), '${random}2');
      await tester.enterText(
          find.byKey(Key('email')), 'e${random}2@example.org');
      await tester.tap(find.byKey(Key('updateUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check userlist
      expect(find.byKey(Key('userItem')), findsNWidgets(2));
      expect(Test.getTextField('name1'), contains('firstName'));
      expect(Test.getTextField('name1'), contains('lastName'));
      expect(Test.getTextField('email1'), equals('e${random}2@example.org'));
      if (!Test.isPhone()) {
        expect(Test.getTextField('username1'), equals('${random}2'));
      }
      await tester.tap(find.byKey(Key('delete1')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('userItem')), findsOneWidget);
    }, skip: false);

    testWidgets("check delete admin>>>>>>", (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //  username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbCompany')));
      await tester.pump(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormAdmin')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsOneWidget);
    }, skip: false);

    testWidgets("create/delete lead >>>>>>", (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //          username: 'e771@example.org');
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('dbCrm')));
      await tester.pump(Duration(seconds: 1));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormLead')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsNothing);
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pump();
      expect(find.byKey(Key('UserDialogLead')), findsOneWidget);
      await tester.enterText(find.byKey(Key('firstName')), 'firstName');
      await tester.enterText(find.byKey(Key('lastName')), 'lastName');
      await tester.enterText(find.byKey(Key('username')), '${random}3');
      await tester.enterText(
          find.byKey(Key('email')), 'e${random}3@example.org');
      await tester.enterText(
          find.byKey(Key('newCompanyName')), 'leadCompany$random');
      await tester.drag(find.byKey(Key('listView')), Offset(0.0, -500.0));
      await tester.pump(Duration(seconds: 3));
      await tester.tap(find.byKey(Key('updateUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check userlist
      expect(find.byKey(Key('userItem')), findsOneWidget);
      expect(Test.getTextField('name0'), contains('firstName'));
      expect(Test.getTextField('name0'), contains('lastName'));
      expect(Test.getTextField('email0'), equals('e${random}3@example.org'));
      expect(Test.getTextField('companyName0'), equals('leadCompany$random'));
      if (!Test.isPhone()) {
        expect(Test.getTextField('username0'), equals('${random}3'));
      }
      await tester.tap(find.byKey(Key('delete0')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('userItem')), findsNothing);
    }, skip: false);
    testWidgets("check delete lead>>>>>>", (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //          username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbCrm')));
      await tester.pump(Duration(seconds: 1));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormLead')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsNothing);
    }, skip: false);

    testWidgets("create/delete CRM customer >>>>>>",
        (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //    username: 'e852@example.org');
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('dbCrm')));
      await tester.pump(Duration(seconds: 1));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormCustomer')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsNothing);
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pump();
      expect(find.byKey(Key('UserDialogCustomer')), findsOneWidget);
      await tester.enterText(find.byKey(Key('firstName')), 'firstName');
      await tester.enterText(find.byKey(Key('lastName')), 'lastName');
      await tester.enterText(find.byKey(Key('username')), '${random}4');
      await tester.enterText(
          find.byKey(Key('email')), 'e${random}4@example.org');
      await tester.enterText(
          find.byKey(Key('newCompanyName')), 'customerCompany$random');
      await tester.drag(find.byKey(Key('listView')), Offset(0.0, -500.0));
      await tester.pump(Duration(seconds: 3));
      await tester.tap(find.byKey(Key('updateUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check userlist
      expect(find.byKey(Key('userItem')), findsOneWidget);
      expect(Test.getTextField('name0'), contains('firstName'));
      expect(Test.getTextField('name0'), contains('lastName'));
      expect(Test.getTextField('email0'), equals('e${random}4@example.org'));
      expect(
          Test.getTextField('companyName0'), equals('customerCompany$random'));
      if (!Test.isPhone()) {
        expect(Test.getTextField('username0'), equals('${random}4'));
      }
      await tester.tap(find.byKey(Key('delete0')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('userItem')), findsNothing);
    }, skip: false);
    testWidgets("check delete CRM customer >>>>>>",
        (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //          username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbCrm')));
      await tester.pump(Duration(seconds: 1));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('3'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormCustomer')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsNothing);
    }, skip: false);

    testWidgets("create/delete sales customer >>>>>>",
        (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //          username: 'e771@example.org');
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('dbSales')));
      await tester.pump(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormCustomer')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsNothing);
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pump();
      expect(find.byKey(Key('UserDialogCustomer')), findsOneWidget);
      await tester.enterText(find.byKey(Key('firstName')), 'firstName');
      await tester.enterText(find.byKey(Key('lastName')), 'lastName');
      await tester.enterText(find.byKey(Key('username')), '${random}5');
      await tester.enterText(
          find.byKey(Key('email')), 'e${random}5@example.org');
      await tester.enterText(
          find.byKey(Key('newCompanyName')), 'customerCompany$random');
      await tester.drag(find.byKey(Key('listView')), Offset(0.0, -500.0));
      await tester.pump(Duration(seconds: 3));
      await tester.tap(find.byKey(Key('updateUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check userlist
      expect(find.byKey(Key('userItem')), findsOneWidget);
      expect(Test.getTextField('name0'), contains('firstName'));
      expect(Test.getTextField('name0'), contains('lastName'));
      expect(Test.getTextField('email0'), equals('e${random}5@example.org'));
      expect(
          Test.getTextField('companyName0'), equals('customerCompany$random'));
      if (!Test.isPhone()) {
        expect(Test.getTextField('username0'), equals('${random}5'));
      }
      await tester.tap(find.byKey(Key('delete0')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('userItem')), findsNothing);
    }, skip: false);
    testWidgets("check delete sales customer>>>>>>",
        (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //          username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbSales')));
      await tester.pump(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormCustomer')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsNothing);
    }, skip: false);

    testWidgets("create/delete purchase supplier >>>>>>",
        (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //          username: 'e771@example.org');
      String random = Test.getRandom();
      await tester.tap(find.byKey(Key('dbPurchase')));
      await tester.pump(Duration(seconds: 1));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormSupplier')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsNothing);
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pump();
      expect(find.byKey(Key('UserDialogSupplier')), findsOneWidget);
      await tester.enterText(find.byKey(Key('firstName')), 'firstName');
      await tester.enterText(find.byKey(Key('lastName')), 'lastName');
      await tester.enterText(find.byKey(Key('username')), '${random}6');
      await tester.enterText(
          find.byKey(Key('email')), 'e${random}6@example.org');
      await tester.enterText(
          find.byKey(Key('newCompanyName')), 'supplierCompany$random');
      await tester.drag(find.byKey(Key('listView')), Offset(0.0, -500.0));
      await tester.pump(Duration(seconds: 3));
      await tester.tap(find.byKey(Key('updateUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      // check userlist
      expect(find.byKey(Key('userItem')), findsOneWidget);
      expect(Test.getTextField('name0'), contains('firstName'));
      expect(Test.getTextField('name0'), contains('lastName'));
      expect(Test.getTextField('email0'), equals('e${random}6@example.org'));
      expect(
          Test.getTextField('companyName0'), equals('supplierCompany$random'));
      if (!Test.isPhone()) {
        expect(Test.getTextField('username0'), equals('${random}6'));
      }
      await tester.tap(find.byKey(Key('delete0')));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('userItem')), findsNothing);
    }, skip: false);
    testWidgets("check delete purchase supplier>>>>>>",
        (WidgetTester tester) async {
      await Test.login(tester,
          AdminApp(repos: Moqui(client: Dio(), classificationId: 'AppAdmin')));
      //          username: 'e771@example.org');
      await tester.tap(find.byKey(Key('dbPurchase')));
      await tester.pump(Duration(seconds: 1));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormSupplier')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('userItem')), findsNothing);
    }, skip: false);
  });
}
