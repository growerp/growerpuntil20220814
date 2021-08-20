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

import 'package:core/forms/changeIp_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:backend/@backend.dart';
import 'package:core/styles/themes.dart';
import 'package:core/widgets/@widgets.dart';
import 'router.dart' as router;
import 'menuItem_data.dart';
import 'package:core/forms/@forms.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  await GlobalConfiguration().loadFromAsset("app_settings");
  // on mobile shared pref can have an updated url from the startup screen
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String prodUrl = prefs.getString("prodUrl") ?? '';
  if (prodUrl.isNotEmpty) GlobalConfiguration().updateValue("prodUrl", prodUrl);

  // running on the web in a docker container can set api address in external file
  if (kIsWeb) {
    try {
      print("try getting local url");
      await GlobalConfiguration().loadFromPath("/app_settings.json");
      print("local url: ${GlobalConfiguration().getValue('prodUrl')}");
    } catch (_) {}
  }

  // here you switch backends
  String backend = GlobalConfiguration().getValue("backend");
  var repos = backend == 'moqui'
      ? Moqui(client: Dio())
//      : backend == 'ofbiz'
//          ? Ofbiz(client: Dio())
      : null;

  runApp(AdminApp(repos: repos!));
}

class AdminApp extends StatelessWidget {
  const AdminApp({
    Key? key,
    required this.repos,
  }) : super(key: key);

  final Object repos;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repos,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(repos)..add(LoadAuth()),
              lazy: false),
          BlocProvider<LeadBloc>(
              create: (context) => UserBloc(
                  repos, "GROWERP_M_LEAD", BlocProvider.of<AuthBloc>(context))),
          BlocProvider<CustomerBloc>(
              create: (context) => UserBloc(repos, "GROWERP_M_CUSTOMER",
                  BlocProvider.of<AuthBloc>(context))),
          BlocProvider<SupplierBloc>(
              create: (context) => UserBloc(repos, "GROWERP_M_SUPPLIER",
                  BlocProvider.of<AuthBloc>(context))),
          BlocProvider<AdminBloc>(
              create: (context) => UserBloc(repos, "GROWERP_M_ADMIN",
                  BlocProvider.of<AuthBloc>(context))),
          BlocProvider<EmployeeBloc>(
              create: (context) => UserBloc(repos, "GROWERP_M_EMPLOYEE",
                  BlocProvider.of<AuthBloc>(context))),
          BlocProvider<CategoryBloc>(create: (context) => CategoryBloc(repos)),
          BlocProvider<ProductBloc>(create: (context) => ProductBloc(repos)),
          BlocProvider<SalesOrderBloc>(
              create: (context) => FinDocBloc(repos, true, 'order')),
          BlocProvider<PurchaseOrderBloc>(
              create: (context) => FinDocBloc(repos, false, 'order')),
          BlocProvider<SalesInvoiceBloc>(
              create: (context) => FinDocBloc(repos, true, 'invoice')),
          BlocProvider<PurchInvoiceBloc>(
              create: (context) => FinDocBloc(repos, false, 'invoice')),
          BlocProvider<SalesPaymentBloc>(
              create: (context) => FinDocBloc(repos, true, 'payment')),
          BlocProvider<PurchPaymentBloc>(
              create: (context) => FinDocBloc(repos, false, 'payment')),
          BlocProvider<OpportunityBloc>(
              create: (context) => OpportunityBloc(repos)),
          BlocProvider<AccntBloc>(create: (context) => AccntBloc(repos)),
          BlocProvider<TransactionBloc>(
              create: (context) => FinDocBloc(repos, false, 'transaction')),
          BlocProvider<AssetBloc>(create: (context) => AssetBloc(repos)),
        ],
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  static String title = "GrowERP administrator.";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            maxWidth: 2460,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
        theme: Themes.formTheme,
        onGenerateRoute: router.generateRoute,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthProblem)
              return FatalErrorForm("Internet or server problem?");
            if (state is AuthAuthenticated)
              return HomeForm(
                  message: state.message, menuItems: menuItems, title: title);
            if (state is AuthUnauthenticated)
              return HomeForm(
                  message: state.message, menuItems: menuItems, title: title);
            if (state is AuthChangeIp) return ChangeIpForm();
            return SplashForm();
          },
        ));
  }
}
