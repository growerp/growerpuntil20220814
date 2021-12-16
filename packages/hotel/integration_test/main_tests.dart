import 'package:integration_test/integration_test.dart';
import 'orderRental_test.dart' as reservation;
import 'checkInOut_test.dart' as checkInOut;

/// all integration tests can be ran independantly
/// They start with a new company and create the items needed for the test,
/// then do the actual test
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  reservation.main();
  checkInOut.main();
}
