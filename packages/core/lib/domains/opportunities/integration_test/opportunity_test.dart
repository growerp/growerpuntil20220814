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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../common/functions/persist_functions.dart';
import '../../integration_test.dart';
import '../../domains.dart';

class OpportunityTest {
  static Future<void> selectOpportunities(WidgetTester tester) async {
    if (find
        .byKey(Key('HomeFormAuth'))
        .toString()
        .startsWith('zero widgets with key')) {
      await CommonTest.gotoMainMenu(tester);
    }
    await CommonTest.selectOption(tester, 'dbCrm', 'OpportunityListForm', '1');
  }

  static Future<void> addOpportunities(
      WidgetTester tester, List<Opportunity> opportunities,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest();
    // test = test.copyWith(opportunities: []); // delete just for test only-------
    if (test.opportunities.isEmpty) {
      // not yet created
      await enterOpportunityData(tester, opportunities);
      await PersistFunctions.persistTest(
          test.copyWith(opportunities: opportunities));
    }
    if (check) {
      await PersistFunctions.persistTest(test.copyWith(
          opportunities: await checkOpportunity(tester, opportunities)));
    }
  }

  static Future<void> updateOpportunities(
      WidgetTester tester, List<Opportunity> opportunities) async {
    SaveTest test = await PersistFunctions.getTest();
    // check if already modified then skip
    if (test.opportunities[0].opportunityName !=
        opportunities[0].opportunityName) {
      for (int x = 0; x < test.opportunities.length; x++) {
        test.opportunities[x] = opportunities[x]
            .copyWith(opportunityId: test.opportunities[x].opportunityId);
      }
      await enterOpportunityData(tester, test.opportunities);
      await PersistFunctions.persistTest(test);
    }
    await checkOpportunity(tester, test.opportunities);
  }

  static Future<void> deleteLastOpportunity(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    var count = CommonTest.getWidgetCountByKey(tester, 'opportunityItem');
    if (count == test.opportunities.length) {
      await CommonTest.refresh(tester);
      await CommonTest.tapByKey(tester, 'delete${count - 1}', seconds: 5);
      await CommonTest.gotoMainMenu(tester);
      await OpportunityTest.selectOpportunities(tester);
      expect(find.byKey(Key('opportunityItem')), findsNWidgets(count - 1));
      await PersistFunctions.persistTest(test.copyWith(
          opportunities:
              test.opportunities.sublist(0, test.opportunities.length - 1)));
    }
  }

  static Future<void> enterOpportunityData(
      WidgetTester tester, List<Opportunity> opportunities) async {
    for (Opportunity opportunity in opportunities) {
      if (opportunity.opportunityId.isEmpty) {
        await CommonTest.tapByKey(tester, 'addNew');
      } else {
        await CommonTest.doSearch(tester,
            searchString: opportunity.opportunityId);
        await CommonTest.tapByKey(tester, 'name0');
        expect(CommonTest.getTextField('header').split('#')[1],
            opportunity.opportunityId);
      }
      await CommonTest.checkWidgetKey(tester, 'OpportunityDialog');
      await CommonTest.enterText(tester, 'name', opportunity.opportunityName!);
      await CommonTest.enterText(
          tester, 'description', opportunity.description!);
      await CommonTest.enterText(
          tester, 'estAmount', opportunity.estAmount.toString());
      await CommonTest.enterText(
          tester, 'estProbability', opportunity.estProbability.toString());
      await CommonTest.enterText(tester, 'nextStep', opportunity.nextStep!);
      await CommonTest.drag(tester, seconds: 5);
      await CommonTest.enterDropDown(tester, 'stageId', opportunity.stageId!,
          seconds: 5);
      await CommonTest.drag(tester, seconds: 5);
      await CommonTest.enterDropDown(
          tester, 'lead', "${opportunity.leadUser!.firstName!}",
          seconds: 5);
      await CommonTest.enterDropDown(
          tester, 'employee', "${opportunity.employeeUser!.firstName!}",
          seconds: 5);
      await CommonTest.drag(tester, seconds: 5);
      await CommonTest.tapByKey(tester, 'update', seconds: 5);
      await CommonTest.waitForKey(tester, 'dismiss');
      await CommonTest.waitForSnackbarToGo(tester);
    }
  }

  static Future<List<Opportunity>> checkOpportunity(
      WidgetTester tester, List<Opportunity> opportunities) async {
    List<Opportunity> newOpportunities = [];
    for (Opportunity opportunity in opportunities) {
      await CommonTest.doSearch(tester,
          searchString: opportunity.opportunityName!);
      expect(CommonTest.getTextField('name0'),
          equals(opportunity.opportunityName));
      expect(
          CommonTest.getTextField('lead0'),
          contains("${opportunity.leadUser!.firstName!} "
              "${opportunity.leadUser!.lastName!}"));
      if (!CommonTest.isPhone()) {
        expect(CommonTest.getTextField('estAmount0'),
            equals(opportunity.estAmount.toString()));
        expect(CommonTest.getTextField('estProbability0'),
            equals(opportunity.estProbability.toString()));
        expect(
            CommonTest.getTextField('stageId0'), equals(opportunity.stageId));
      }
      await CommonTest.tapByKey(tester, 'name0');
      expect(find.byKey(Key('OpportunityDialog')), findsOneWidget);
      var id = CommonTest.getTextField('header').split('#')[1];
      expect(CommonTest.getTextFormField('name'),
          equals(opportunity.opportunityName!));
      expect(CommonTest.getTextFormField('description'),
          equals(opportunity.description!));
      expect(CommonTest.getTextFormField('estAmount'),
          equals(opportunity.estAmount.toString()));
      expect(CommonTest.getTextFormField('estProbability'),
          equals(opportunity.estProbability.toString()));
      expect(CommonTest.getDropdown('stageId'), contains(opportunity.stageId));
      expect(CommonTest.getDropdownSearch('lead'),
          contains("${opportunity.leadUser!.companyName!}"));
      expect(CommonTest.getDropdownSearch('employee'),
          contains("${opportunity.employeeUser!.companyName!}"));
      newOpportunities.add(opportunity.copyWith(opportunityId: id));
      await CommonTest.tapByKey(tester, 'cancel');
    }
    await CommonTest.closeSearch(tester);
    return newOpportunities;
  }
}
