import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:admin/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('just test the first screen on the app',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(milliseconds: 1000));

      if (find
          .byKey(Key('DashBoardUnAuth'))
          .toString()
          .contains('zero widgets')) {
        final Finder fab = find.byKey(Key('logoutButton'));
        await tester.tap(fab);
        await tester.pumpAndSettle();
      }

      // logged out
      expect(find.byKey(Key('DashBoardUnAuth')), findsOneWidget);

      final Finder fab1 = find.byKey(Key('loginButton'));
      await tester.tap(fab1);
      await tester.pumpAndSettle();
      final Finder fab2 = find.byKey(Key('loginButton'));
      await tester.tap(fab2);
      await tester.pumpAndSettle(Duration(milliseconds: 1000));

      // logged in at dashboard (home)
      expect(find.byKey(Key('DashBoardAuth')), findsOneWidget);

      final Finder fab3 = find.byKey(Key('logoutButton'));
      await tester.tap(fab3);
      await tester.pumpAndSettle();

      // logged out
      expect(find.byKey(Key('DashBoardUnAuth')), findsOneWidget);
    });
  });
}
