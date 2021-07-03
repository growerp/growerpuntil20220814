import 'package:integration_test/integration_test.dart';
import 'newCompany_test.dart' as newCompany;
import 'category_test.dart' as category;
import 'product_test.dart' as product;
import 'asset_test.dart' as asset;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  newCompany.main();
  category.main();
  product.main();
  asset.main();
}
