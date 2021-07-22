import 'package:integration_test/integration_test.dart';
import 'newCompany_test.dart' as newCompany;
import 'newCompanyDemo_test.dart' as newCompanyDemo;
import 'category_test.dart' as category;
import 'product_test.dart' as product;
import 'asset_test.dart' as asset;
import 'opportunity_test.dart' as opportunity;
import 'orderProduct_test.dart' as orderProduct;
import 'orderRental_test.dart' as orderRental;

/// all integration tests can be ran independantly
/// They start with a new company and create the items needed for the test,
/// then do the actual test
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  newCompany.main();
  newCompanyDemo.main();
  category.main();
  product.main();
  asset.main();
  opportunity.main();
  orderProduct.main();
  orderRental.main();
}
