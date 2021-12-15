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

import 'dart:io';

/* this script assums the following:

Moqui installed in ~/growerpMoqui
Chat installed in ~/growerpChat

android studio installed with emulator configured

*/

void main(List<String> arguments) async {
  var process;
  var emulator = 'pixel';
  if (arguments.isNotEmpty) emulator = arguments[0];

  print('Start integration test');
  process = Process.runSync('git', ['pull'],
      workingDirectory: '../growerpMoqui/runtime/component/growerp');
  print('=========git pull backend: ${process.stdout}');

  process =
      Process.runSync('git', ['pull'], workingDirectory: '../growerpChat');
  print('=========git pull chatServer: ${process.stdout}');

  process = Process.runSync('./gradlew', ['appRun'],
      workingDirectory: '../growerpChat');

  process = Process.runSync('./gradlew', ['cleandb'],
      workingDirectory: '../growerpMoqui');
  print('=========Moqui clean db ${process.stdout}');

  print('=========Moqui loading seed, install data....');
  process = Process.runSync(
      'java', ['-jar', 'moqui.war', 'load', 'types=seed,seed-initial,install'],
      workingDirectory: '../growerpMoqui');

  print('======= start moqui...');
  await Process.start('java', ['-jar', 'moqui.war'],
      workingDirectory: '../growerpMoqui', mode: ProcessStartMode.detached);

  // admin
  print('======start emulator.....');
  process = await Process.start('flutter', ['emulators', '--launch', emulator]);

  process = Process.runSync('git', ['pull'], workingDirectory: '.');
  print('========update admin git: ${process.stdout}');

  print(' wait for emulator to start');
  await Future.delayed(Duration(seconds: 60));

  print('======start test....');
  await Process.start(
      'flutter',
      [
        'drive',
        '--driver=test_driver/integration_test.dart',
        '--target=integration_test/main_tests.dart',
        '-d',
        'emulator-5554',
        '--screenshot=.'
      ],
      workingDirectory: '.',
      mode: ProcessStartMode.inheritStdio);
}
