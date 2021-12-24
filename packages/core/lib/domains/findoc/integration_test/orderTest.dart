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
import 'package:core/domains/domains.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../common/integration_test/commonTest.dart';
import '../models/models.dart';

class OrderTest {
  static Future<void> selectPurchaseOrder(WidgetTester tester) async {
    await CommonTest.selectOption(
        tester, 'dbOrders', 'FinDocListFormPurchaseOrder', '3');
  }

  static Future<void> createPurchaseOrder(
      WidgetTester tester, List<FinDoc> finDocs) async {
    List<FinDoc> orders = [];
    for (FinDoc order in finDocs) {
      // enter purchase order dialog
      await CommonTest.tapByKey(tester, 'addNew');
      await CommonTest.checkWidgetKey(tester, 'FinDocDialogPurchaseOrder');
      await CommonTest.tapByKey(tester, 'clear', seconds: 2);
      await CommonTest.enterText(tester, 'description', order.description!);
      // enter supplier
      await CommonTest.enterDropDownSearch(
          tester, 'supplier', order.otherUser!.companyName!);
      // add product data
      await CommonTest.tapByKey(tester, 'addProduct', seconds: 1);
      await CommonTest.checkWidgetKey(tester, 'addProductItemDialog');
      await CommonTest.enterDropDownSearch(
          tester, 'product', order.items[0].description!);
      await CommonTest.drag(tester, listViewName: 'listView3');
      await CommonTest.enterText(
          tester, 'price', order.items[0].price.toString());
      await CommonTest.enterText(
          tester, 'quantity', order.items[0].quantity.toString());
      await CommonTest.tapByKey(tester, 'ok');
      // create order
      await CommonTest.tapByKey(tester, 'update', seconds: 5);
      // get productId
      await CommonTest.tapByKey(tester, 'id0');
      FinDocItem newItem = order.items[0].copyWith(
          productId: CommonTest.getTextField('itemLine0').split(' ')[1]);
      await CommonTest.tapByKey(tester, 'id0');
      // save order with orderId and productId
      orders.add(order
          .copyWith(orderId: CommonTest.getTextField('id0'), items: [newItem]));
    }
    // save when successfull
    await PersistFunctions.persistFinDocList(orders);
  }

  static Future<void> checkPurchaseOrder(WidgetTester tester) async {
    List<FinDoc> orders = await PersistFunctions.getFinDocList();
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      // check list
      expect(CommonTest.getTextField('id0'), equals(order.orderId!));
      await CommonTest.tapByKey(tester, 'id0'); // open detail
      expect(order.items[0].productId,
          CommonTest.getTextField('itemLine0').split(' ')[1]);
      await CommonTest.checkText(tester, order.items[0].description!);
      await CommonTest.tapByKey(tester, 'id0'); // close detail
      // check detail
      await CommonTest.tapByKey(tester, 'edit0');
      await CommonTest.checkText(tester, order.orderId!);
      await CommonTest.checkText(tester, order.items[0].description!);
      await CommonTest.tapByKey(tester, 'cancel'); // cancel dialog
      await CommonTest.closeSearch(tester);
    }
  }

  static Future<void> sendPurchaseOrder(
      WidgetTester tester, List<FinDoc> orders) async {
    List<FinDoc> orders = await PersistFunctions.getFinDocList();
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      await CommonTest.tapByKey(tester, 'nextStatus0',
          seconds: 5); // to created
      await CommonTest.tapByKey(tester, 'nextStatus0',
          seconds: 5); // to approved
    }
    await CommonTest.gotoMainMenu(tester);
  }

  static Future<void> checkOrderCompleted(WidgetTester tester) async {
    List<FinDoc> orders = await PersistFunctions.getFinDocList();
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      expect(CommonTest.getTextField('status0'), equals('Completed'));
    }
  }
}
