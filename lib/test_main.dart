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

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:backend/@backend.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'main.dart';

// used by the driver. this uses enableFlutterDriverExtension
Future main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  await GlobalConfiguration().loadFromAsset("app_settings");
  String backend = GlobalConfiguration().getValue("backend");
  var repos = backend == 'moqui'
      ? Moqui(client: Dio())
//      : backend == 'ofbiz'
//          ? Ofbiz(client: Dio())
      : null;

  runApp(AdminApp(repos: repos!));
}
