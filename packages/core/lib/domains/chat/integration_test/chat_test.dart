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

import 'package:flutter_test/flutter_test.dart';
import '../../common/integration_test/commonTest.dart';
import '../../domains.dart';

class ChatTest {
  static Future<void> selectChatRoom(WidgetTester tester) async {
    await CommonTest.tapByTooltip(tester, 'Chat');
  }

  static Future<void> addRooms(WidgetTester tester, List<ChatRoom> rooms,
      {bool check = true}) async {}
  // TODO: create tests
  static Future<void> updateRooms(WidgetTester tester) async {}

  static Future<void> deleteRooms(WidgetTester tester) async {}

  static Future<void> sendDirectMessage(WidgetTester tester) async {}

  static Future<void> sendRoomMessage(WidgetTester tester) async {}
}
