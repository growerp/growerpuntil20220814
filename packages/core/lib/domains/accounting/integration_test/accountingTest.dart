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
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../common/integration_test/commonTest.dart';

class AccountingTest {
  static Future<void> selectPurchaseInvoices(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbAccounting', 'AcctDashBoard');
    await CommonTest.selectOption(
        tester, 'accntPurchase', 'FinDocListFormPurchaseInvoice');
  }

  static Future<void> selectSalesInvoices(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbAccounting', 'AcctDashBoard');
    await CommonTest.selectOption(
        tester, 'accntSales', 'FinDocListFormSalesInvoice');
  }

  static Future<void> addPayments(WidgetTester tester, List<FinDoc> payments,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest();
    int seq = test.sequence!;
    if (test.payments.isEmpty) {
      // not yet created
      test = test.copyWith(payments: payments);
      expect(find.byKey(Key('userItem')), findsNWidgets(0)); // initial admin
      await enterPaymentData(tester, payments);
      await PersistFunctions.persistTest(
          test.copyWith(payments: payments, sequence: seq));
    }
    if (check && test.payments[0].paymentId == null) {
      await checkPaymentList(tester, payments);
      await PersistFunctions.persistTest(test.copyWith(
        payments: await checkPaymentDetail(tester, test.payments),
        sequence: seq,
      ));
    }
  }

  static Future<void> enterPaymentData(
      WidgetTester tester, List<FinDoc> payments) async {
    int index = 0;
    for (FinDoc payment in payments) {
      if (payment.paymentId == null)
        await CommonTest.tapByKey(tester, 'addNew');
      else {
        await CommonTest.tapByKey(tester, 'name$index');
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
      await CommonTest.drag(tester);
      await CommonTest.tapByKey(tester, 'update', seconds: 5);
      await tester.pumpAndSettle(); // for the message to disappear
      index++;
    }
  }

  static Future<void> checkPaymentList(
      WidgetTester tester, List<FinDoc> payments) async {
    await CommonTest.refresh(tester);
    payments.forEachIndexed((index, payment) {
      expect(
          CommonTest.getTextField('amount$index'), equals(payment.grandTotal));
    });
  }

  static Future<List<FinDoc>> checkPaymentDetail(
      WidgetTester tester, List<FinDoc> payments) async {
    int index = 0;
    List<FinDoc> newPayments = [];
    for (FinDoc payment in payments) {
      await CommonTest.tapByKey(tester, 'name${index}');
      var id = CommonTest.getTextField('header').split('#')[1];
      expect(find.byKey(Key('PaymentDialog')), findsOneWidget);
      expect(
          CommonTest.getTextFormField('amount'), equals(payment.grandTotal!));
      newPayments.add(payment.copyWith(paymentId: id));
      index++;
      await CommonTest.tapByKey(tester, 'cancel');
    }
    return newPayments;
  }

  static Future<void> checkPurchaseInvoices(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    List<FinDoc> finDocs = [];
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      // save invoice Id with order
      String invoiceId = CommonTest.getTextField('id0');
      invoiceId = CommonTest.getTextField('id0');
      finDocs.add(order.copyWith(invoiceId: invoiceId));
      // check list
      await CommonTest.tapByKey(tester, 'id0'); // open items
      expect(order.items[0].productId,
          CommonTest.getTextField('itemLine0').split(' ')[1]);
      await CommonTest.tapByKey(tester, 'id0'); // close items
    }
    await PersistFunctions.persistTest(test.copyWith(orders: finDocs));
  }

  static Future<void> checkSalesInvoices(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    List<FinDoc> finDocs = [];
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      // save invoice Id with order
      String invoiceId = CommonTest.getTextField('id0');
      finDocs.add(order.copyWith(invoiceId: invoiceId));
      // check list
      await CommonTest.tapByKey(tester, 'id0'); // open items
      expect(order.items[0].productId,
          CommonTest.getTextField('itemLine0').split(' ')[1]);
      await CommonTest.tapByKey(tester, 'id0'); // close items
    }
    await PersistFunctions.persistTest(test.copyWith(orders: finDocs));
  }

  static Future<void> approvePurchaseInvoices(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      await CommonTest.tapByKey(tester, 'nextStatus0', seconds: 5);
      await CommonTest.checkText(tester, 'Approved');
    }
  }

  static Future<void> sendSalesInvoices(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      await CommonTest.tapByKey(tester, 'nextStatus0', seconds: 5);
      await CommonTest.checkText(tester, 'Approved');
    }
  }

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

  static Future<void> checkPurchasePayments(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    List<FinDoc> finDocs = [];
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      // save invoice Id with order
      String paymentId = CommonTest.getTextField('id0');
      // if same as order number , wrong record, get next one
      if (CommonTest.getTextField('id0') == order.orderId) {
        paymentId = CommonTest.getTextField('id0');
      }
      finDocs.add(order.copyWith(paymentId: paymentId));
      // check list
    }
    await PersistFunctions.persistTest(test.copyWith(orders: finDocs));
  }

  static Future<void> checkSalesPayments(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    List<FinDoc> finDocs = [];
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      // save invoice Id with order
      String paymentId = CommonTest.getTextField('id0');
      // if same as order number , wrong record, get next one
      if (CommonTest.getTextField('id0') == order.orderId) {
        paymentId = CommonTest.getTextField('id0');
      }
      finDocs.add(order.copyWith(paymentId: paymentId));
      // check list
    }
    await PersistFunctions.persistTest(test.copyWith(orders: finDocs));
  }

  static Future<void> selectTransactions(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbAccounting', 'AcctDashBoard');
    await CommonTest.selectOption(
        tester, 'accntLedger', 'FinDocListFormTransaction', '2');
  }

  static Future<void> checkTransactions(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.invoiceId!);
      await CommonTest.doSearch(tester, searchString: order.paymentId!);
      await CommonTest.doSearch(tester, searchString: order.shipmentId!);
      // save invoice Id with order
    }
  }

  /// assume we are in the purchase payment list
  /// conform that a payment has been send
  static Future<void> sendReceivePayment(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.paymentId!);
      await CommonTest.tapByKey(tester, 'nextStatus0'); // open items
    }
  }

  /// check if the purchase process has been completed successfuly
  static Future<void> checkPaymentComplete(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.paymentId!);
      expect(CommonTest.getTextField('status0'), 'Completed');
    }
  }

  /// check if the purchase process has been completed successfuly
  static Future<void> checkPurchaseInvoicesComplete(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.invoiceId!);
      expect(CommonTest.getTextField('status0'), 'Completed');
    }
  }

  static Future<void> checkSalesInvoicesComplete(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.invoiceId!);
      expect(CommonTest.getTextField('status0'), 'Completed');
    }
  }
}
