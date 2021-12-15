import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  testWidgets("failing test example", (WidgetTester tester) async {
    expect(3 + 1, 5);
  });
}
