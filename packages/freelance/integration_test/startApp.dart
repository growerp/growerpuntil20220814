import 'package:core/widgets/observer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart';
import 'package:backend/@backend.dart';
import 'package:global_configuration/global_configuration.dart';

Future<void> startApp(WidgetTester tester) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  Bloc.observer = SimpleBlocObserver();
  await tester.pumpWidget(
      TopApp(dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()));
  await tester.pumpAndSettle(Duration(seconds: 2));
  await tester.pumpAndSettle(Duration(seconds: 2));
}
