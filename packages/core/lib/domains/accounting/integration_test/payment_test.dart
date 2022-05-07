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
import 'package:core/domains/domains.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../common/integration_test/commonTest.dart';

class PaymentTest {
  static Future<void> selectPurchasePayments(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbAccounting', 'AcctDashBoard');
    await CommonTest.selectOption(
        tester, 'accntPurchase', 'FinDocListFormPurchasePayment', '2');
  }

  static Future<void> selectSalesPayments(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbAccounting', 'AcctDashBoard');
    await CommonTest.selectOption(
        tester, 'accntSales', 'FinDocListFormSalesPayment', '2');
  }

  static Future<void> addPayments(WidgetTester tester, List<FinDoc> payments,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest();
    // test = test.copyWith(payments: []); //======= remove
    // await PersistFunctions.persistTest(test); //=====remove
    if (test.payments.isEmpty) {
      // not yet created
      await PersistFunctions.persistTest(
          test.copyWith(payments: await enterPaymentData(tester, payments)));
    }
    if (check) {
      await checkPayment(tester, test.payments);
    }
  }

  static Future<void> updatePayments(
      WidgetTester tester, List<FinDoc> payments) async {
    SaveTest test = await PersistFunctions.getTest();
    if (test.payments[0].grandTotal != payments[0].grandTotal) {
      // copy new payment data with paymentId
      for (int x = 0; x < test.payments.length; x++) {
        test.payments[x] =
            payments[x].copyWith(paymentId: test.payments[x].paymentId);
      }
      // update existing records, no need to use return data
      await enterPaymentData(tester, test.payments);
      await checkPayment(tester, test.payments);
      await PersistFunctions.persistTest(test);
    }
  }

  static Future<void> deleteLastPayment(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    var count = CommonTest.getWidgetCountByKey(tester, 'finDocItem');
    if (count == test.payments.length) {
      // check if already deleted
      await CommonTest.refresh(tester);
      await CommonTest.tapByKey(tester, 'edit${count - 1}');
      await CommonTest.tapByKey(tester, 'cancelFinDoc', seconds: 5);
      expect(CommonTest.getTextField('status${count - 1}'),
          equals(finDocStatusValues[FinDocStatusVal.Cancelled.toString()]));
      //  only within testing deleted item will not be removed after refresh
      //    await CommonTest.refresh(tester);
      //    expect(find.byKey(Key('finDocItem')), findsNWidgets(count - 1));
      await PersistFunctions.persistTest(test.copyWith(
          payments: test.payments.sublist(0, test.payments.length - 1)));
    }
  }

  static Future<List<FinDoc>> enterPaymentData(
      WidgetTester tester, List<FinDoc> payments) async {
    List<FinDoc> newPayments = [];
    for (FinDoc payment in payments) {
      if (payment.paymentId == null)
        await CommonTest.tapByKey(tester, 'addNew');
      else {
        await CommonTest.doSearch(tester, searchString: payment.paymentId!);
        await CommonTest.tapByKey(tester, 'edit0');
        expect(
            CommonTest.getTextField('header').split('#')[1], payment.paymentId);
      }
      await CommonTest.checkWidgetKey(
          tester, "PaymentDialog${payment.sales ? 'Sales' : 'Purchase'}");
      await CommonTest.enterDropDownSearch(
          tester,
          "${payment.sales ? 'customer' : 'supplier'}",
          payment.otherUser!.lastName!);
      await CommonTest.tapByKey(
          tester, 'amount'); // required because keyboard come up
      await CommonTest.enterText(
          tester, 'amount', payment.grandTotal!.toString());
      switch (payment.paymentInstrument) {
        case PaymentInstrument.bank:
          await CommonTest.tapByKey(tester, 'bank');
          break;
        case PaymentInstrument.creditcard:
          await CommonTest.tapByKey(tester, 'creditCard');
          break;
        case PaymentInstrument.check:
          await CommonTest.tapByKey(tester, 'check');
          break;
        case PaymentInstrument.cash:
          await CommonTest.tapByKey(tester, 'cash');
          break;
      }
      await CommonTest.enterDropDown(
          tester, 'itemType', payment.items[0].itemTypeName!);
      await CommonTest.drag(tester, listViewName: 'listView2');
      await CommonTest.tapByKey(tester, 'update', seconds: 5);
      await CommonTest.waitForKey(tester, 'dismiss');
      await CommonTest.waitForSnackbarToGo(tester);
      if (payment.paymentId == null)
        payment = payment.copyWith(paymentId: CommonTest.getTextField('id0'));
      newPayments.add(payment);
    }
    await CommonTest.closeSearch(tester);
    return newPayments;
  }

  static Future<void> checkPayment(
      WidgetTester tester, List<FinDoc> payments) async {
    for (FinDoc payment in payments) {
      await CommonTest.doSearch(tester,
          searchString: payment.paymentId!, seconds: 5);
      expect(CommonTest.getTextField('otherUser0'),
          contains(payment.otherUser?.companyName));
      expect(CommonTest.getTextField('status0'),
          equals(finDocStatusValues[FinDocStatusVal.Created.toString()]));
      expect(CommonTest.getTextField('grandTotal0'),
          equals(payment.grandTotal.toString()));
      await CommonTest.tapByKey(tester, 'edit0');
      expect(
          find.byKey(Key(
              'PaymentDialog${payment.sales == true ? "Sales" : "Purchase"}')),
          findsOneWidget);
      expect(CommonTest.getTextFormField('amount'),
          equals(payment.grandTotal!.toString()));
      switch (payment.paymentInstrument) {
        case PaymentInstrument.creditcard:
          expect(CommonTest.getCheckbox('creditCard'), equals(true));
          break;
        case PaymentInstrument.bank:
          expect(CommonTest.getCheckbox('bank'), equals(true));
          break;
        case PaymentInstrument.cash:
          expect(CommonTest.getCheckbox('cash'), equals(true));
          break;
        case PaymentInstrument.check:
          expect(CommonTest.getCheckbox('check'), equals(true));
          break;
      }
      await CommonTest.tapByKey(tester, 'cancel');
    }
    await CommonTest.closeSearch(tester);
  }

  // not used locally...need replacement
  static Future<void> checkPayments(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> payments = test.orders.isNotEmpty
        ? test.orders
        : test.invoices.isNotEmpty
            ? test.invoices
            : test.payments;
    List<FinDoc> finDocs = [];
    for (FinDoc payment in payments) {
      await CommonTest.doSearch(tester, searchString: payment.id()!);
      // payment Id with order
      String paymentId = CommonTest.getTextField('id0');
      // if same as order number , wrong record, get next one
      if (CommonTest.getTextField('id0') == payment.id()) {
        paymentId = CommonTest.getTextField('id0');
      }
      finDocs.add(payment.copyWith(paymentId: paymentId));
      // check list
    }
    switch (payments[0].docType) {
      case FinDocType.order:
        await PersistFunctions.persistTest(test.copyWith(orders: finDocs));
        break;
      case FinDocType.invoice:
        await PersistFunctions.persistTest(test.copyWith(invoices: finDocs));
        break;
      case FinDocType.payment:
        await PersistFunctions.persistTest(test.copyWith(payments: finDocs));
        break;
    }
  }

  /// assume we are in the purchase payment list
  /// confirm that a payment has been send
  static Future<void> sendReceivePayment(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> payments = test.orders.isNotEmpty
        ? test.orders
        : test.invoices.isNotEmpty
            ? test.invoices
            : test.payments;
    for (FinDoc payment in payments) {
      await CommonTest.doSearch(tester, searchString: payment.id()!);
      if (CommonTest.getTextField('status0') ==
          finDocStatusValues[FinDocStatusVal.InPreparation.toString()])
        await CommonTest.tapByKey(tester, 'nextStatus0', seconds: 5);
      if (CommonTest.getTextField('status0') ==
          finDocStatusValues[FinDocStatusVal.Created.toString()])
        await CommonTest.tapByKey(tester, 'nextStatus0', seconds: 5);
      if (CommonTest.getTextField('status0') ==
          finDocStatusValues[FinDocStatusVal.Approved.toString()])
        await CommonTest.tapByKey(tester, 'nextStatus0', seconds: 5);
    }
    await CommonTest.closeSearch(tester);
  }

  /// check if the purchase process has been completed successfuly
  static Future<void> checkPaymentComplete(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> payments = test.orders.isEmpty ? test.payments : test.orders;
    for (FinDoc payment in payments) {
      await CommonTest.doSearch(tester, searchString: payment.paymentId!);
      expect(CommonTest.getTextField('status0'), 'Completed');
    }
  }
}
