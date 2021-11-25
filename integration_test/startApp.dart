import 'package:core/widgets/observer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/main.dart';
import 'package:backend/@backend.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:core/domains/common/integration_test/commonTest.dart';
import 'data.dart';

Future<void> startApp(WidgetTester tester,
    {bool newRandom = true, bool clear = true}) async {
  if (clear) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('Products');
    await prefs.remove('PurchaseOrders');
  }
  await GlobalConfiguration().loadFromAsset("app_settings");
  Bloc.observer = SimpleBlocObserver();
  await tester.pumpWidget(
      TopApp(dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()));
  if (newRandom = false) seq = CommonTest.getRandom();
  await tester.pumpAndSettle(Duration(seconds: 2));
  await tester.pumpAndSettle(Duration(seconds: 5));
}
