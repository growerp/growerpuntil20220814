/*
 * This software is in the public domain under CC0 1.0 Universal plus a
 * Grant of Patent License.
 * 
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any
 * warranty.
 * 
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software (see the LICENSE.md file). If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

import 'dart:math';
import 'package:admin/main.dart';
import 'package:dio/dio.dart';
import 'package:core/integration_test/test_functions.dart';
import 'package:backend/@backend.dart';
import 'package:core/widgets/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:integration_test/integration_test.dart';

/// needs the debug company created
/// and [chatchatEcho.dart] executing in a different process

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  String random = 'chatTest' + Random.secure().nextInt(1024).toString();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  group('Chat test Prepare >>>>>', () {
    testWidgets("create chat user to login >>>>>", (WidgetTester tester) async {
      await Test.login(
          tester,
          TopApp(
              dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()),
          username: "test@example.com");
      // create chat user
      await tester.tap(find.byKey(Key('dbCompany')));
      await tester.pump(Duration(seconds: 5));
      if (Test.isPhone())
        await tester.tap(find.byTooltip('2'));
      else
        await tester.tap(find.byKey(Key('tapUsersFormAdmin')));
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.byKey(Key('addNew')));
      await tester.pump(Duration(seconds: 3));
      expect(find.byKey(Key('UserDialogAdmin')), findsOneWidget);
      await tester.enterText(find.byKey(Key('firstName')), 'firstName');
      await tester.enterText(find.byKey(Key('lastName')), 'lastName');
      await tester.enterText(find.byKey(Key('username')), random);
      await tester.enterText(
          find.byKey(Key('email')), 'e${random}2@example.org');
      await tester.pumpAndSettle();
      await Test.drag(tester);
      await tester.tap(find.byKey(Key('updateUser')));
      await tester.pumpAndSettle(Duration(seconds: 5));
    }, skip: false);
  });
  group('chat form basics>>>>>', () {
    testWidgets("Screen handling>>>>>>", (WidgetTester tester) async {
      await Test.login(
          tester,
          TopApp(
              dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()),
          username: '$random');
      // chatrooms screen
      await tester.tap(find.byTooltip('Chat'));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('ChatRoomsDialog')), findsOneWidget);
      // open new chat
      await Test.tap(tester, 'addNew');
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('ChatRoomDialog')), findsOneWidget);
      await Test.tap(tester, 'userDropDown');
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(find.text('Michael-l Brown1').last);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await Test.tap(tester, 'update');
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('chatRoomItem')), findsNWidgets(1));
      // select created chat
      await Test.tap(tester, 'chatRoomName0');
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byKey(Key('ChatDialog')), findsOneWidget);
      // enter chat message
      await Test.enterText(tester, 'messageContent', 'hello!');
      await Test.tap(tester, 'send');
      expect(find.text('hello!'), findsOneWidget);
      // leave chatroom form
      await Test.tap(tester, 'cancel');
      await tester.pumpAndSettle(Duration(seconds: 1));
      // delete chatroom
      await Test.tap(tester, 'delete0');
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byKey(Key('chatRoomItem')), findsNWidgets(0));
      // leave chatrooms form
      await Test.tap(tester, 'cancel');
      await tester.pumpAndSettle(Duration(seconds: 1));
    }, skip: false);
    testWidgets("chat with chat echo in other process>>>>>>",
        (WidgetTester tester) async {
      await Test.login(
          tester,
          TopApp(
              dbServer: MoquiServer(client: Dio()),
              chatServer: ChatServer()), //),
          username: '$random');
      // chatrooms screen
      await tester.tap(find.byTooltip('Chat'));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await Test.refresh(tester);
      // open new chat
      await Test.tap(tester, 'addNew');
      await tester.pumpAndSettle(Duration(seconds: 1));
      await Test.tap(tester, 'userDropDown');
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(find.text('John Doe').last);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await Test.tap(tester, 'update');
      await tester.pumpAndSettle(Duration(seconds: 5));
      // select created chat
      await Test.tap(tester, 'chatRoomName0');
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byKey(Key('ChatDialog')), findsOneWidget);
      // enter chat message
      await Test.enterText(tester, 'messageContent', 'hello!');
      await Test.tap(tester, 'send');
      await tester.pumpAndSettle(Duration(seconds: 10));
      expect(find.text('hello!'), findsNWidgets(2));
    }, skip: false);
  });
}
