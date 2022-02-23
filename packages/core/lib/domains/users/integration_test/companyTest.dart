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

import 'package:core/domains/common/functions/functions.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../domains.dart';
import '../../integration_test.dart';

class CompanyTest {
  static Future<void> createCompany(WidgetTester tester,
      {bool demoData = false}) async {
    SaveTest test = await PersistFunctions.getTest();
    int seq = test.sequence ?? 0;
    seq++;
    await PersistFunctions.persistTest(test.copyWith(sequence: seq));
    if (test.company != null) return; // company already created
    await CommonTest.logout(tester);
    // tap new company button, enter data
    await CommonTest.tapByKey(tester, 'newCompButton');
    await tester.pump(Duration(seconds: 3));
    await CommonTest.enterText(tester, 'firstName', admin.firstName!);
    await CommonTest.enterText(tester, 'lastName', admin.lastName!);
    var email = admin.email!.replaceFirst('XXX', '${seq++}');
    await CommonTest.enterText(tester, 'email', email);
    await CommonTest.enterText(tester, 'companyName', company.name!);
    await CommonTest.drag(tester);
    if (demoData == false)
      await CommonTest.tapByKey(tester, 'demoData'); // no demo data
    await CommonTest.tapByKey(tester, 'newCompany', seconds: 10);
    // start with clean saveTest
    await PersistFunctions.persistTest(SaveTest(
        sequence: seq,
        nowDate: DateTime.now(), // used in rental
        admin: admin.copyWith(email: email, loginName: email),
        company: company.copyWith(email: email)));
    await CommonTest.login(tester);
  }

  static Future<void> selectCompany(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'tapCompany', 'CompanyInfoForm');
  }

  static Future<void> updateCompany(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    if (company.name != test.company!.name!) return;
    checkCompanyFields(test.company!, perc: false);
    await CommonTest.tapByKey(tester, 'updateCompany');
    checkCompanyFields(test.company!, perc: false);
    // add a '1' to all fields
    Company newCompany = Company(
        name: company.name! + '1',
        email: "${test.company!.email!.split('@')[0]}"
            "1@${test.company!.email!.split('@')[1]}",
        currency: currencies[1],
        vatPerc: company.vatPerc! + Decimal.parse('1'),
        salesPerc: company.salesPerc! + Decimal.parse('1'));
    await CommonTest.enterText(tester, 'companyName', newCompany.name!);
    await CommonTest.enterText(tester, 'email', newCompany.email!);
    await CommonTest.enterDropDown(
        tester, 'currency', currencies[1].description!);
    await CommonTest.enterText(
        tester, 'vatPerc', newCompany.vatPerc.toString());
    await CommonTest.enterText(
        tester, 'salesPerc', newCompany.salesPerc.toString());
    await CommonTest.drag(tester);
    await CommonTest.tapByKey(tester, 'updateCompany', seconds: 5);
    // and check them
    checkCompanyFields(newCompany);
    var id = CommonTest.getTextField('header').split('#')[1];
    await PersistFunctions.persistTest(
        test.copyWith(company: newCompany.copyWith(partyId: id)));
  }

  static void checkCompanyFields(Company company,
      {bool perc = true, String address = 'No address yet'}) {
    expect(CommonTest.getTextFormField('companyName'), equals(company.name!));
    expect(CommonTest.getTextFormField('email'), equals(company.email));
    expect(CommonTest.getDropdown('currency'),
        equals(company.currency?.description));
    expect(CommonTest.getTextFormField('vatPerc'),
        equals(perc ? company.vatPerc.toString() : ''));
    expect(CommonTest.getTextFormField('salesPerc'),
        equals(perc ? company.salesPerc.toString() : ''));
    expect(CommonTest.getTextField('addressLabel'), equals(address));
  }

  static Future<void> updateAddress(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    if (test.company!.address != null) return;
    await CommonTest.updateAddress(tester, company.address!);
    await CommonTest.checkAddress(tester, company.address!);
    Company newCompany = company.copyWith(
        address: Address(
            address1: company.address!.address1! + 'u',
            address2: company.address!.address2! + 'u',
            postalCode: company.address!.postalCode! + 'u',
            city: company.address!.city! + 'u',
            province: company.address!.province! + 'u',
            country: countries[1].name));
    await CommonTest.drag(tester);
    await CommonTest.tapByKey(tester, 'updateCompany', seconds: 5);
    await CommonTest.updateAddress(tester, newCompany.address!);
    await CommonTest.checkAddress(tester, newCompany.address!);
    await PersistFunctions.persistTest(test.copyWith(company: newCompany),
        backup: true); // last test for company ready for user test
  }
}
