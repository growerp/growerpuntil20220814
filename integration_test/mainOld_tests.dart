import 'package:integration_test/integration_test.dart';
import 'oldTests/newCompany_test.dart' as newCompany;
import 'oldTests/newCompanyDemo_test.dart' as newCompanyDemo;
import 'oldTests/orderProduct_test.dart' as orderProduct;
import 'oldTests/orderRental_test.dart' as orderRental;
import 'oldTests/userListAdd_test.dart' as user;
import 'oldTests/asset_test.dart' as asset;
import 'oldTests/product_test.dart' as product;
import 'oldTests/category_test.dart' as category;

/// all integration tests can be ran independantly
/// They start with a new company and create the items needed for the test,
/// then do the actual test
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//  newCompany.main();
//  newCompanyDemo.main();
//  orderProduct.main();
//  orderRental.main();
//  user.main();
//  asset.main();
//  product.main();
  category.main();
}
