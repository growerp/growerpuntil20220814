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
import '../models/models.dart';

class CatalogTest {
  static Future<void> selectCatalog(WidgetTester tester) async {
    await CommonTest.selectOption(tester, 'dbCatalog', 'ProductListForm');
  }

  static Future<void> updateProduct(
      WidgetTester tester, List<Product> productsIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var str = prefs.getString('Products');
    late List<Product> products;
    if (str != null)
      products = productsFromJson(str);
    else
      products = productsIn;
    for (Product product in products) {
      await CommonTest.doSearch(tester, searchString: product.productName!);
      await CommonTest.tapByKey(tester, 'name0');
      if (product.price != null)
        await CommonTest.enterText(tester, 'price', product.price!.toString());
      await CommonTest.drag(tester);
      if (CommonTest.getCheckbox('useWarehouse') != product.useWarehouse)
        await CommonTest.tapByKey(tester, 'useWarehouse');
      await CommonTest.tapByKey(tester, 'update', seconds: 5);
    }
  }
}
