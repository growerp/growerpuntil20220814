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

class UserTest {
  static Future<void> selectAdministrators(WidgetTester tester) async {
    await selectUsers(tester, 'dbCompany', 'UserListFormAdmin', '2');
  }

  static Future<void> selectEmployees(WidgetTester tester) async {
    await selectUsers(tester, 'dbCompany', 'UserListFormEmployee', '3');
  }

  static Future<void> selectLeads(WidgetTester tester) async {
    await selectUsers(tester, 'dbCrm', 'UserListFormLead', '2');
  }

  static Future<void> selectCustomers(WidgetTester tester) async {
    await selectUsers(tester, 'dbCrm', 'UserListFormCustomer', '3');
  }

  static Future<void> selectSuppliers(WidgetTester tester) async {
    await selectUsers(tester, 'dbOrders', 'UserListFormSupplier', '4');
  }

  static Future<void> selectUsers(WidgetTester tester, String option,
      String formName, String tabNumber) async {
    if (find
        .byKey(Key('HomeFormAuth'))
        .toString()
        .startsWith('zero widgets with key')) {
      await CommonTest.gotoMainMenu(tester);
    }
    await CommonTest.selectOption(tester, option, formName, tabNumber);
  }

  static Future<void> addAdministrators(
      WidgetTester tester, List<User> administrators,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    seq = test.sequence!;
    if (test.administrators.isEmpty) {
      seq++;
      // not yet created
      test = test.copyWith(administrators: administrators);
      expect(find.byKey(Key('userItem')), findsNWidgets(1)); // initial admin
      test.copyWith(
          administrators: await enterUserData(tester, administrators));
      await PersistFunctions.persistTest(
          test.copyWith(administrators: administrators));
    }
    if (check) {
      await checkUserList(tester, administrators);
      await PersistFunctions.persistTest(test.copyWith(
        administrators: await checkUserDetail(tester, test.administrators),
        sequence: seq,
      ));
    }
  }

  static Future<void> addEmployees(WidgetTester tester, List<User> employees,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    seq = test.sequence!;
    if (test.employees.isEmpty) {
      // not yet created
      test = test.copyWith(employees: employees);
      expect(find.byKey(Key('userItem')), findsNWidgets(0)); // initial admin
      test.copyWith(employees: await enterUserData(tester, employees));
      await PersistFunctions.persistTest(test.copyWith(employees: employees));
    }
    if (check) {
      await checkUserList(tester, employees);
      await PersistFunctions.persistTest(test.copyWith(
        employees: await checkUserDetail(tester, test.employees),
        sequence: seq,
      ));
    }
  }

  static Future<void> addLeads(WidgetTester tester, List<User> leads,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    seq = test.sequence!;
    if (test.leads.isEmpty) {
      // not yet created
      test = test.copyWith(leads: leads);
      expect(find.byKey(Key('userItem')), findsNWidgets(0)); // initial admin
      test.copyWith(leads: await enterUserData(tester, leads));
      await PersistFunctions.persistTest(test.copyWith(leads: leads));
    }
    if (check) {
      await checkUserList(tester, leads);
      await PersistFunctions.persistTest(test.copyWith(
        leads: await checkUserDetail(tester, test.leads),
        sequence: seq,
      ));
    }
  }

  static Future<void> addCustomers(WidgetTester tester, List<User> customers,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    seq = test.sequence!;
    if (test.customers.isEmpty) {
      // not yet created
      test = test.copyWith(customers: customers);
      expect(find.byKey(Key('userItem')), findsNWidgets(0));
      test.copyWith(customers: await enterUserData(tester, customers));
      await PersistFunctions.persistTest(test.copyWith(customers: customers));
    }
    if (check) {
      await checkUserList(tester, customers);
      await PersistFunctions.persistTest(test.copyWith(
        customers: await checkUserDetail(tester, test.customers),
        sequence: seq,
      ));
    }
  }

  static Future<void> addSuppliers(WidgetTester tester, List<User> suppliers,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    seq = test.sequence!;
    if (test.suppliers.isEmpty) {
      // not yet created
      test = test.copyWith(suppliers: suppliers);
      expect(find.byKey(Key('userItem')), findsNWidgets(0));
      test.copyWith(suppliers: await enterUserData(tester, suppliers));
      await PersistFunctions.persistTest(test.copyWith(suppliers: suppliers));
    }
    if (check) {
      await checkUserList(tester, suppliers);
      await PersistFunctions.persistTest(test.copyWith(
        suppliers: await checkUserDetail(tester, test.suppliers),
        sequence: seq,
      ));
    }
  }

  static Future<List<User>> enterUserData(
      WidgetTester tester, List<User> users) async {
    int index = 0;
    int index1 = 0;
    if (users[0].userGroup == UserGroup.Admin) index++;
    List<User> newUsers = [];
    for (User user in users) {
      if (user.partyId == null)
        await CommonTest.tapByKey(tester, 'addNew');
      else {
        await CommonTest.tapByKey(tester, 'name$index');
        expect(CommonTest.getTextField('header').split('#')[1], user.partyId);
      }
      expect(find.byKey(Key('UserDialog${user.userGroup.toString()}')),
          findsOneWidget);
      await CommonTest.enterText(tester, 'firstName', user.firstName!);
      await CommonTest.enterText(tester, 'lastName', user.lastName!);
      var email = user.email!.replaceFirst('XXX', '${seq++}');
      await CommonTest.enterText(tester, 'loginName', email);
      await CommonTest.drag(tester);
      await CommonTest.enterText(tester, 'email', email);
      await CommonTest.drag(tester);
      if (user.userGroup != UserGroup.Admin &&
          user.userGroup != UserGroup.Employee) {
        await CommonTest.enterText(tester, 'newCompanyName', user.companyName!);
        if (user.companyAddress != null) {
          await CommonTest.updateAddress(tester, user.companyAddress!);
        }
        await CommonTest.drag(tester);
      }
      if (user.partyId != null) {
        await CommonTest.enterDropDown(
            tester, 'userGroup', user.userGroup.toString());
      }
      await CommonTest.drag(tester);
      await CommonTest.tapByKey(tester, 'updateUser', seconds: 5);
      newUsers.add(user.copyWith(email: email, loginName: email));
      index++;
      index1++;
    }
    return (newUsers);
  }

  static Future<void> checkUserList(
      WidgetTester tester, List<User> users) async {
    await CommonTest.refresh(tester);
    int corr = 0;
    if (users[0].userGroup == UserGroup.Admin) corr++;
    users.forEachIndexed((index, user) {
      expect(CommonTest.getTextField('name${index + corr}'),
          equals('${user.firstName} ${user.lastName}'));
    });
  }

  static Future<List<User>> checkUserDetail(
      WidgetTester tester, List<User> users) async {
    int index = 0, index1 = 0;
    if (users[0].userGroup == UserGroup.Admin) index++;
    List<User> newUsers = [];
    for (User user in users) {
      await CommonTest.tapByKey(tester, 'name${index}');
      var id = CommonTest.getTextField('header').split('#')[1];
      expect(find.byKey(Key('UserDialog${user.userGroup.toString()}')),
          findsOneWidget);
      expect(CommonTest.getTextFormField('firstName'), equals(user.firstName!));
      expect(CommonTest.getTextFormField('lastName'), equals(user.lastName!));
      expect(CommonTest.getTextFormField('loginName'), equals(user.email!));
      expect(CommonTest.getTextFormField('email'), equals(user.email!));
      await CommonTest.drag(tester);
      if (user.companyAddress != null) {
        await CommonTest.checkAddress(tester, user.companyAddress!);
      }
      expect(CommonTest.getDropdown('userGroup'),
          equals(user.userGroup.toString()));
      newUsers.add(user.copyWith(partyId: id));
      index++;
      index1++;
      await CommonTest.tapByKey(tester, 'cancel');
    }
    return newUsers;
  }

  static Future<void> deleteAdministrators(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    await CommonTest.refresh(tester);
    int count = test.administrators.length;
    if (count != administrators.length) return;
    await deleteUser(tester, count + 1);
    test.administrators.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> deleteEmployees(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    await CommonTest.refresh(tester);
    int count = test.employees.length;
    if (count != employees.length) return;
    await deleteUser(tester, count);
    test.employees.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> deleteLeads(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    await CommonTest.refresh(tester);
    int count = test.leads.length;
    if (count != leads.length) return;
    await deleteUser(tester, count);
    test.leads.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> deleteCustomers(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    await CommonTest.refresh(tester);
    int count = test.customers.length;
    if (count != customers.length) return;
    await deleteUser(tester, count);
    test.customers.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> deleteSuppliers(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    int count = test.suppliers.length;
    if (count != suppliers.length) return;
    await deleteUser(tester, count);
    test.suppliers.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> deleteUser(WidgetTester tester, int count) async {
    expect(find.byKey(Key('userItem')), findsNWidgets(count)); // initial admin
    await CommonTest.tapByKey(tester, 'delete${count - 1}', seconds: 5);
    expect(find.byKey(Key('userItem')), findsNWidgets(count - 1));
  }

  static Future<void> updateAdministrators(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    // check if already modified then skip
    if (test.administrators[0].firstName != administrators[0].firstName) return;
    test = test.copyWith(administrators: updateUsers(test.administrators));
    await enterUserData(tester, test.administrators);
    await checkUserDetail(tester, test.administrators);
    await PersistFunctions.persistTest(test);
  }

  static Future<void> updateEmployees(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    // check if already modified then skip
    if (test.employees[0].firstName != employees[0].firstName) return;
    test = test.copyWith(employees: updateUsers(test.employees));
    await enterUserData(tester, test.employees);
    await checkUserDetail(tester, test.employees);
    await PersistFunctions.persistTest(test);
  }

  static Future<void> updateLeads(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    // check if already modified then skip
    if (test.leads[0].firstName != leads[0].firstName) return;
    test = test.copyWith(leads: updateUsers(test.leads));
    await enterUserData(tester, test.leads);
    await checkUserDetail(tester, test.leads);
    await PersistFunctions.persistTest(test);
  }

  static Future<void> updateCustomers(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    // check if already modified then skip
    if (test.customers[0].firstName != customers[0].firstName) return;
    test = test.copyWith(customers: updateUsers(test.customers));
    await enterUserData(tester, test.customers);
    await checkUserDetail(tester, test.customers);
    await PersistFunctions.persistTest(test);
  }

  static Future<void> updateSuppliers(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    // check if already modified then skip
    if (test.suppliers[0].firstName != suppliers[0].firstName) return;
    test = test.copyWith(suppliers: updateUsers(test.suppliers));
    await enterUserData(tester, test.suppliers);
    await checkUserDetail(tester, test.suppliers);
    await PersistFunctions.persistTest(test);
  }

  static List<User> updateUsers(List<User> users) {
    List<User> updUsers = [];
    for (User user in users) {
      updUsers.add(user.copyWith(
        firstName: user.firstName! + 'u',
        lastName: user.lastName! + 'u',
        email: "${user.email!.split('@')[0]}"
            "u@${user.email!.split('@')[1]}",
        loginName: "${user.email!.split('@')[0]}"
            "u@${user.email!.split('@')[1]}",
        companyName: user.companyName! + 'u',
        companyAddress: user.companyAddress != null
            ? Address(
                address1: user.companyAddress!.address1! + 'u',
                address2: user.companyAddress!.address2! + 'u',
                postalCode: user.companyAddress!.postalCode! + 'u',
                city: user.companyAddress!.city! + 'u',
                province: user.companyAddress!.province! + 'u',
                country: countries[10].name)
            : null,
      ));
    }
    return updUsers;
  }
}
