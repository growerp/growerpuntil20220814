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
import '../../integration_test.dart';
import '../../domains.dart';

// this test is started by the top app after 'startApp'

class OpportunityTest {
  static Future<void> enterDetail(
      WidgetTester tester, Opportunity opportunity) async {
    await CommonTest.checkWidgetKey(tester, 'OpportunityDialog');
    await CommonTest.enterText(tester, 'name', opportunity.opportunityName!);
    await CommonTest.enterText(tester, 'description', opportunity.description!);
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
/* change employee nmber then not show
    if (listNumber == 1) // number 0 filled with loggedin user
      await CommonTest.enterDropDown(
          tester, "employee", "${administrators[listNumber].firstName}",
          seconds: 5);
*/
    await CommonTest.drag(tester, seconds: 5);
    await CommonTest.tapByKey(tester, 'update', seconds: 5);
  }

  static Future<void> checkList(
      WidgetTester tester, Opportunity opportunity) async {
    expect(
        CommonTest.getTextField('name0'), equals(opportunity.opportunityName));
    expect(
        CommonTest.getTextField('lead0'),
        contains("${opportunity.leadUser!.firstName!} "
            "${opportunity.leadUser!.lastName!}"));
    if (!CommonTest.isPhone()) {
      expect(CommonTest.getTextField('estAmount0'),
          equals(opportunity.estAmount.toString()));
      expect(CommonTest.getTextField('estProbability0'),
          equals(opportunity.estProbability.toString()));
      expect(CommonTest.getTextField('stageId0'), equals(opportunity.stageId));
    }
  }

  static Future<void> checkDetail(
      WidgetTester tester, Opportunity opportunity) async {
    expect(find.byKey(Key('OpportunityDialog')), findsOneWidget);
    expect(CommonTest.getTextFormField('name'),
        equals(opportunity.opportunityName!));
    expect(CommonTest.getTextFormField('description'),
        equals(opportunity.description!));
    expect(CommonTest.getTextFormField('estAmount'),
        equals(opportunity.estAmount.toString()));
    expect(CommonTest.getTextFormField('estProbability'),
        equals(opportunity.estProbability.toString()));
    expect(CommonTest.getDropdown('stageId'), equals(opportunity.stageId));
    expect(
        CommonTest.getDropdownSearch('lead'),
        contains("${opportunity.leadUser!.firstName!} "
            "${opportunity.leadUser!.lastName!}"));
/*    expect(
        CommonTest.getDropdownSearch('employee'),
        contains("${administrators[listNumber].firstName} "
            "${administrators[listNumber].lastName}"));
*/
  }

  static Future<void> showDetail(WidgetTester tester) async {
    await CommonTest.tapByKey(tester, 'name0');
    expect(find.byKey(Key('OpportunityDialog')), findsOneWidget);
  }

  static Future<void> closeDetail(WidgetTester tester) async {
    await CommonTest.refresh(tester);
    await CommonTest.tapByKey(tester, 'cancel');
  }

  static Future<void> delete(WidgetTester tester) async {
    await CommonTest.tapByKey(tester, 'delete0');
  }

  static Future<void> checkListCount(WidgetTester tester, int number) async {
    expect(find.byKey(Key('opportunityItem')), findsNWidgets(number));
  }

  static Future<void> showList(WidgetTester tester) async {
    await CommonTest.tapByKey(tester, 'dbCrm', seconds: 3);
    await CommonTest.checkWidgetKey(tester, 'OpportunityListForm');
  }

  static Future<void> showNewDetail(WidgetTester tester) async {
    await CommonTest.tapByKey(tester, 'addNew');
    expect(find.byKey(Key('OpportunityDialog')), findsOneWidget);
  }
}
