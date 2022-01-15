/*
 * This GrowERP software is in the public domain under CC0 1.0 Universal plus a
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

import 'package:core/domains/common/functions/persist_functions.dart';
import 'package:core/domains/domains.dart';
import 'package:flutter_test/flutter_test.dart';
import 'main.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:core/api_repository.dart';
import 'package:core/services/chat_server.dart';

Future<void> startApp(WidgetTester tester,
    {bool newRandom = true, bool clear = true}) async {
  if (clear) {
    SaveTest test = await PersistFunctions.getTest();
    await PersistFunctions.persistTest(SaveTest(sequence: test.sequence));
  }
  await GlobalConfiguration().loadFromAsset("app_settings");

  await tester
      .pumpWidget(TopApp(dbServer: APIRepository(), chatServer: ChatServer()));
  await tester.pumpAndSettle(Duration(seconds: 2));
  await tester.pumpAndSettle(Duration(seconds: 5));
}
