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

import 'package:core/domains/domains.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/integration_test/commonTest.dart';

class AccountingTest {
  static Future<void> selectPurchaseInvoices(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbAccounting', 'AcctDashBoard');
    await CommonTest.selectOption(
        tester, 'accntPurchase', 'FinDocListFormPurchaseInvoice');
  }

  static Future<void> checkPurchaseInvoices(WidgetTester tester) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var str = prefs.getString('PurchaseOrders');
    expect(str != null, true,
        reason: "need purchase orders from previous tests");
    List<FinDoc> orders = finDocsFromJson(str!);
    List<FinDoc> finDocs = [];
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      // save invoice Id with order
      String invoiceId = CommonTest.getTextField('id0');
      String seq = '0';
      // if same as order number , wrong record, get next one
      if (CommonTest.getTextField('id0') == order.orderId) {
        invoiceId = CommonTest.getTextField('id1');
        seq = '1';
      }
      finDocs.add(order.copyWith(invoiceId: invoiceId));
      // check list
      await CommonTest.tapByKey(tester, 'id$seq'); // open items
      expect(order.items[0].productId,
          CommonTest.getTextField('itemLine$seq').split(' ')[1]);
      await CommonTest.tapByKey(tester, 'id$seq'); // close items
    }
    await prefs.setString('PurchaseOrders', finDocsToJson(finDocs));
  }

  static Future<void> approvePurchaseInvoices(WidgetTester tester) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var str = prefs.getString('PurchaseOrders');
    expect(str != null, true,
        reason: "need purchase orders from previous tests");
    List<FinDoc> orders = finDocsFromJson(str!);
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      String seq = '0';
      // if same as order number , wrong record, get next one
      if (CommonTest.getTextField('id0') == order.orderId) {
        seq = '1';
      }
      await CommonTest.tapByKey(tester, 'nextStatus$seq', seconds: 5);
      await CommonTest.checkText(tester, 'Approved');
    }
  }

  static Future<void> selectPurchasePayments(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbAccounting', 'AcctDashBoard');
    await CommonTest.selectOption(
        tester, 'accntPurchase', 'FinDocListFormPurchasePayment', '2');
  }

  static Future<void> checkPurchasePayments(WidgetTester tester) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var str = prefs.getString('PurchaseOrders');
    expect(str != null, true,
        reason: "need purchase orders from previous tests");
    List<FinDoc> orders = finDocsFromJson(str!);
    List<FinDoc> finDocs = [];
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      // save invoice Id with order
      String paymentId = CommonTest.getTextField('id0');
      // if same as order number , wrong record, get next one
      if (CommonTest.getTextField('id0') == order.orderId) {
        paymentId = CommonTest.getTextField('id1');
      }
      finDocs.add(order.copyWith(paymentId: paymentId));
      // check list
    }
    await prefs.setString('PurchaseOrders', finDocsToJson(finDocs));
  }

  static Future<void> selectTransactions(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbAccounting', 'AcctDashBoard');
    await CommonTest.selectOption(
        tester, 'accntLedger', 'FinDocListFormTransaction', '2');
  }

  static Future<void> checkTransactions(WidgetTester tester) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var str = prefs.getString('PurchaseOrders');
    expect(str != null, true,
        reason: "need purchase orders from previous tests");
    List<FinDoc> orders = finDocsFromJson(str!);
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.invoiceId!);
      await CommonTest.doSearch(tester, searchString: order.paymentId!);
      await CommonTest.doSearch(tester, searchString: order.shipmentId!);
      // save invoice Id with order
    }
  }

  static Future<void> checkAccountingComplete(
      WidgetTester tester, List<FinDoc> orders) async {}
}
