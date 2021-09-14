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
  List<String> char = ['a', 'b', 'x'];
  List<String> quantity = ['11', '22', '33'];

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('Opportunity tests>>>>>', () {
    testWidgets("opportunity add/mod/del >>>>>", (WidgetTester tester) async {
      await Test.createCompanyAndAdmin(
          tester,
          AdminApp(
              dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()));
      String random = Test.getRandom();
      await Test.createUser(tester, 'lead', random);
      await Test.createUser(tester, 'employee', random);
      await Test.tap(tester, 'dbCrm');
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byKey(Key('OpportunitiesForm')), findsOneWidget);
      // enter 3 records
      for (int x in [0, 1, 2]) {
        await Test.tap(tester, 'addNew');
        expect(find.byKey(Key('OpportunityDialog')), findsOneWidget);
        await Test.enterText(
            tester, 'name', 'opportunityName$random${char[x]}');
        await Test.enterText(
            tester, 'description', 'description$random${char[x]}');
        await Test.enterText(tester, 'estAmount', '${quantity[x]}');
        await Test.enterText(tester, 'estProbability', '${quantity[x]}');
        await Test.enterText(tester, 'nextStep', 'nextStep1');
        await Test.drag(tester);
        await Test.tap(tester, 'stageId');
        await tester.tap(find.text('Prospecting').last);
        await tester.pumpAndSettle(Duration(seconds: 3));
        await Test.drag(tester);
        await Test.tap(tester, 'lead');
        await tester.pumpAndSettle(Duration(seconds: 3));
        await tester.tap(find.textContaining('lead1').last);
        await tester.pumpAndSettle(Duration(seconds: 3));
        await Test.tap(tester, 'update');
        await tester.pump(Duration(seconds: 3));
      }
      await tester.pump(Duration(seconds: 5));
      expect(find.byKey(Key('opportunityItem')), findsNWidgets(3));
      // check list
      for (int x in [0, 1, 2]) {
        expect(find.byKey(Key('OpportunitiesForm')), findsOneWidget);
        expect(Test.getTextField('name$x'),
            equals('opportunityName$random${char[x]}'));
        expect(Test.getTextField('lead$x'), contains('firstName1 lead1'));
        if (!Test.isPhone()) {
          expect(Test.getTextField('leadEmail$x'),
              equals('e${random}3@example.org'));
          expect(Test.getTextField('estAmount$x'), equals('${quantity[x]}'));
          expect(
              Test.getTextField('estProbability$x'), equals('${quantity[x]}'));
          expect(Test.getTextField('stageId$x'), equals('Prospecting'));
        }
      }
      //check detail and update record 1
      for (int x in [0, 1, 2]) {
        expect(find.byKey(Key('OpportunitiesForm')), findsOneWidget);
        await Test.tap(tester, 'name$x');
        expect(find.byKey(Key('OpportunityDialog')), findsOneWidget);
        expect(Test.getTextFormField('name'),
            equals('opportunityName$random${char[x]}'));
        expect(Test.getTextFormField('description'),
            equals('description$random${char[x]}'));
        expect(Test.getTextFormField('estAmount'), equals('${quantity[x]}'));
        expect(
            Test.getTextFormField('estProbability'), equals('${quantity[x]}'));
        expect(Test.getDropdown('stageId'), equals('Prospecting'));
        expect(
            Test.getDropdownSearch('account'), contains('firstName lastName'));
        expect(Test.getDropdownSearch('lead'), contains('firstName1 lead1'));

        if (x == 1) {
          // update record 1 = b -> d
          await Test.enterText(tester, 'name', 'opportunityName${random}d');
          await Test.enterText(tester, 'description', 'description${random}d');
          await Test.enterText(tester, 'estAmount', '23');
          await Test.enterText(tester, 'estProbability', '29');
          await Test.enterText(tester, 'nextStep', 'nextStep2');
          await Test.drag(tester);
          await Test.tap(tester, 'stageId');
          await tester.tap(find.text('Qualification').last);
          await tester.pumpAndSettle(Duration(seconds: 3));
          await Test.drag(tester);
          await Test.tap(tester, 'lead');
          await tester.tap(find.textContaining('lead2').last);
          await Test.drag(tester);
          await Test.tap(tester, 'update');
          await tester.pumpAndSettle(Duration(seconds: 3));
          // check list
          expect(
              Test.getTextField('name$x'), equals('opportunityName${random}d'));
          expect(Test.getTextField('lead$x'), contains('firstName2 lead2'));
          if (!Test.isPhone()) {
            expect(Test.getTextField('estAmount$x'), equals('23'));
            expect(Test.getTextField('estProbability$x'), equals('29'));
            expect(Test.getTextField('stageId$x'), equals('Qualification'));
          }
          // check detail screen
          await Test.tap(tester, 'name1');
          expect(Test.getTextFormField('name'), 'opportunityName${random}d');
          expect(Test.getTextFormField('description'),
              equals('description${random}d'));
          expect(Test.getTextFormField('estAmount'), equals('23'));
          expect(Test.getTextFormField('estProbability'), equals('29'));
          expect(Test.getDropdown('stageId'), equals('Qualification'));
          expect(Test.getDropdownSearch('account'),
              contains('firstName lastName'));
          expect(Test.getDropdownSearch('lead'), contains('firstName2 lead2'));
        }
        await Test.drag(tester);
        await tester.pumpAndSettle(Duration(seconds: 5));
        await Test.tap(tester, 'cancel');
      }
      // delete record 'x' x=2
      await Test.tap(tester, 'delete2');
      expect(find.byKey(Key('opportunityItem')), findsNWidgets(2));
    }, skip: false);

    testWidgets("opportunities  reload from database>>>>>",
        (WidgetTester tester) async {
      // 0: a   1: d 2: deleted
      await Test.login(
          tester,
          AdminApp(
              dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()));
      String random = Test.getRandom();
      // use the CRM tap dashboard
      await Test.tap(tester, 'dbCrm');
      // get to opportunity list
      if (Test.isPhone())
        await tester.tap(find.byTooltip('1'));
      else
        await Test.tap(tester, 'tapOpportunitiesForm');
      // check list
      char = ['a', 'd'];
      List<String> estAmount = ['11', '23'];
      List<String> estProbability = ['11', '29'];
      List<String> stageId = ['Prospecting', 'Qualification'];
      for (int x in [0, 1]) {
        expect(Test.getTextField('name$x'),
            equals('opportunityName$random${char[x]}'));
        expect(Test.getTextField('lead$x'),
            contains('firstName${x + 1} lead${x + 1}'));
        if (!Test.isPhone()) {
          expect(Test.getTextField('estAmount$x'), equals('${estAmount[x]}'));
          expect(Test.getTextField('estProbability$x'),
              equals('${estProbability[x]}'));
          expect(Test.getTextField('stageId$x'), equals('${stageId[x]}'));
        }
      }
      // detail screens
      for (int x in [0, 1]) {
        await Test.tap(tester, 'name$x');
        expect(Test.getTextFormField('name'),
            equals('opportunityName$random${char[x]}'));
        expect(Test.getTextFormField('description'),
            equals('description$random${char[x]}'));
        expect(Test.getTextFormField('estAmount'), equals('${estAmount[x]}'));
        expect(Test.getTextFormField('estProbability'),
            equals('${estProbability[x]}'));
        expect(Test.getDropdown('stageId'), equals('${stageId[x]}'));
        expect(
            Test.getDropdownSearch('account'), contains('firstName lastName'));
        expect(Test.getDropdownSearch('lead'),
            contains('firstName${x + 1} lead${x + 1}'));
        await Test.drag(tester);
        await Test.tap(tester, 'cancel');
      }
    }, skip: false);
  });
}
