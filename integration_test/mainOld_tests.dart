import 'package:integration_test/integration_test.dart';
import 'oldTests/newCompany_test.dart' as newCompany;
import 'oldTests/newCompanyDemo_test.dart' as newCompanyDemo;
import 'oldTests/category_test.dart' as category;
import 'oldTests/product_test.dart' as product;
import 'oldTests/asset_test.dart' as asset;
import 'oldTests/opportunity_test.dart' as opportunity;
import 'oldTests/orderProduct_test.dart' as orderProduct;
import 'oldTests/orderRental_test.dart' as orderRental;
import 'oldTests/userListAdd_test.dart' as user;

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
  user.main();
}
