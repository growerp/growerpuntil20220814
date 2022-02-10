import 'package:admin/main.dart';
import 'package:core/api_repository.dart';
import 'package:core/domains/catalog/integration_test/asset_test.dart';
import 'package:core/domains/catalog/integration_test/category_test.dart';
import 'package:core/domains/catalog/integration_test/product_test.dart';
import 'package:core/services/chat_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/domains/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
  });

  testWidgets('''GrowERP asset test''', (tester) async {
    await CommonTest.startApp(
        tester, TopApp(dbServer: APIRepository(), chatServer: ChatServer()),
        clear: true);
    await CompanyTest.createCompany(tester);
    await CategoryTest.selectCategory(tester);
    await CategoryTest.addCategories(tester, [categories[0], categories[1]],
        check: false);
    await ProductTest.selectProduct(tester);
    await ProductTest.addProducts(tester, [products[0], products[1]],
        check: false);
    await AssetTest.selectAsset(tester);
    await AssetTest.addAssets(tester, assets);
    await AssetTest.updateAssets(tester);
    await AssetTest.deleteAssets(tester);
    await CommonTest.logout(tester);
  });
}
