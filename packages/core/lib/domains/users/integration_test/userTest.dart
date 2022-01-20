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

// this test is started by the top app after 'startApp'

class UserTest {
  static Future<void> selectAdministrators(WidgetTester tester) async {
    await CommonTest.selectOption(
        tester, 'dbCompany', 'UserListFormAdmin', '2');
  }

  static Future<void> selectEmployees(WidgetTester tester) async {
    await CommonTest.selectOption(
        tester, 'dbCompany', 'UserListFormEmployee', '3');
  }

  static Future<void> selectLeads(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbCrm', 'UserListFormLead', '2');
  }

  static Future<void> selectCustomers(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbCrm', 'UserListFormCustomer', '3');
  }

  static Future<void> selectSuppliers(WidgetTester tester) async {
    await CommonTest.selectOption(
        tester, 'dbOrders', 'UserListFormSupplier', '4');
  }

  static Future<void> addAdministrators(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    if (test.administrators.isNotEmpty) return; // already created
    test = test.copyWith(administrators: administrators);
    expect(find.byKey(Key('userItem')), findsNWidgets(1)); // initial admin
    await PersistFunctions.persistTest(test.copyWith(
      administrators: await addUsers(tester, test.administrators),
      sequence: seq,
    ));
  }

  static Future<void> addEmployees(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    if (test.employees.isNotEmpty) return; // already created
    test = test.copyWith(employees: employees);
    expect(find.byKey(Key('userItem')), findsNWidgets(0)); // initial admin
    await PersistFunctions.persistTest(test.copyWith(
      employees: await addUsers(tester, test.employees),
      sequence: seq,
    ));
  }

  static Future<void> addLeads(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    if (test.leads.isNotEmpty) return; // already created
    test = test.copyWith(leads: leads);
    expect(find.byKey(Key('userItem')), findsNWidgets(0)); // initial admin
    await PersistFunctions.persistTest(test.copyWith(
      leads: await addUsers(tester, test.leads),
      sequence: seq,
    ));
  }

  static Future<void> addCustomers(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    if (test.customers.isNotEmpty) return; // already created
    test = test.copyWith(customers: customers);
    expect(find.byKey(Key('userItem')), findsNWidgets(0)); // initial admin
    await PersistFunctions.persistTest(test.copyWith(
      customers: await addUsers(tester, test.customers),
      sequence: seq,
    ));
  }

  static Future<void> addSuppliers(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest(backup: false);
    if (test.suppliers.isNotEmpty) return; // already created
    test = test.copyWith(suppliers: suppliers);
    expect(find.byKey(Key('userItem')), findsNWidgets(0)); // initial admin
    await PersistFunctions.persistTest(test.copyWith(
      suppliers: await addUsers(tester, test.suppliers),
      sequence: seq,
    ));
  }

  static Future<List<User>> addUsers(
      WidgetTester tester, List<User> users) async {
    await enterUserData(tester, users);
    await checkUserList(tester, users);
    return await checkUserDetail(tester, users);
  }

  static Future<void> enterUserData(
      WidgetTester tester, List<User> users) async {
    int index = 0;
    if (users[0].userGroup == UserGroup.Admin) index++;
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
      await CommonTest.enterText(tester, 'loginName', user.email!);
      await CommonTest.drag(tester, listViewName: 'listView1');
      await CommonTest.enterText(tester, 'email', user.email!);
      await CommonTest.drag(tester, listViewName: 'listView1');
      if (user.userGroup != UserGroup.Admin &&
          user.userGroup != UserGroup.Employee) {
        await CommonTest.enterText(tester, 'newCompanyName', user.companyName!);
        await CommonTest.drag(tester, listViewName: 'listView1');
      }
      if (user.partyId != null) {
        await CommonTest.enterDropDown(
            tester, 'userGroup', user.userGroup.toString());
      }
      await CommonTest.drag(tester, listViewName: 'listView1');
      await CommonTest.tapByKey(tester, 'updateUser', seconds: 5);
      index++;
    }
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
    for (User user in users) {
      await CommonTest.tapByKey(tester, 'name${index}');
      expect(find.byKey(Key('UserDialog${user.userGroup.toString()}')),
          findsOneWidget);
      expect(CommonTest.getTextFormField('firstName'), equals(user.firstName!));
      expect(CommonTest.getTextFormField('lastName'), equals(user.lastName!));
      expect(CommonTest.getTextFormField('loginName'), equals(user.email!));
      expect(CommonTest.getTextFormField('email'), equals(user.email!));
      await CommonTest.drag(tester);
      expect(CommonTest.getDropdown('userGroup'),
          equals(user.userGroup.toString()));
      var id = CommonTest.getTextField('header').split('#')[1];
      users[index1] = users[index1].copyWith(partyId: id);
      index++;
      index1++;
      await CommonTest.tapByKey(tester, 'cancel');
    }
    return users;
  }

  static Future<void> deleteAdministrators(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    int count = test.administrators.length;
    if (count != administrators.length) return;
    await deleteUser(tester, count + 1);
    test.administrators.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> deleteEmployees(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    int count = test.employees.length;
    if (count != employees.length) return;
    await deleteUser(tester, count);
    test.employees.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> deleteLeads(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    int count = test.leads.length;
    if (count != leads.length) return;
    await deleteUser(tester, count);
    test.leads.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> deleteCustomers(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
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
    await CommonTest.tapByKey(tester, 'delete${count - 1}');
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
      ));
    }
    return updUsers;
  }
}
