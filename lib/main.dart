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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:ofbiz/ofbiz.dart';
import 'package:moqui/moqui.dart';
import 'package:core/styles/themes.dart';
import 'router.dart' as router;
import 'forms/@forms.dart';
import 'package:core/forms/@forms.dart' as core;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  Bloc.observer = SimpleBlocObserver();

  String backend = GlobalConfiguration().getValue("backend");
  var repos = backend == 'moqui'
      ? Moqui(client: Dio())
      : backend == 'ofbiz'
          ? Ofbiz(client: Dio())
          : null;

  runApp(AdminApp(repos: repos));
}

class AdminApp extends StatelessWidget {
  const AdminApp({
    Key key,
    @required this.repos,
  })  : assert(repos != null),
        super(key: key);

  final Object repos;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repos,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LeadBloc>(
              create: (context) => UserBloc(repos, "GROWERP_M_LEAD")),
          BlocProvider<CustomerBloc>(
              create: (context) => UserBloc(repos, "GROWERP_M_CUSTOMER")),
          BlocProvider<SupplierBloc>(
              create: (context) => UserBloc(repos, "GROWERP_M_SUPPLIER")),
          BlocProvider<AdminBloc>(
              create: (context) => UserBloc(repos, "GROWERP_M_ADMIN")),
          BlocProvider<EmployeeBloc>(
              create: (context) => UserBloc(repos, "GROWERP_M_EMPLOYEE")),
          BlocProvider<CategoryBloc>(create: (context) => CategoryBloc(repos)),
          BlocProvider<ProductBloc>(create: (context) => ProductBloc(repos)),
          BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(repos)..add(LoadAuth())),
          BlocProvider<SalesFinDocBloc>(
              create: (context) => FinDocBloc(repos, true, 'order')),
          BlocProvider<PurchFinDocBloc>(
              create: (context) => FinDocBloc(repos, false, 'order')),
          BlocProvider<SalesInvoiceBloc>(
              create: (context) => FinDocBloc(repos, true, 'invoice')),
          BlocProvider<PurchInvoiceBloc>(
              create: (context) => FinDocBloc(repos, false, 'invoice')),
          BlocProvider<SalesPaymentBloc>(
              create: (context) => FinDocBloc(repos, true, 'payment')),
          BlocProvider<PurchPaymentBloc>(
              create: (context) => FinDocBloc(repos, false, 'payment')),
          BlocProvider<SalesCartBloc>(
              create: (context) => CartBloc(
                  repos: repos,
                  sales: true,
                  finDocBloc: BlocProvider.of<SalesFinDocBloc>(context))),
          BlocProvider<PurchCartBloc>(
              create: (context) => CartBloc(
                  repos: repos,
                  sales: false,
                  finDocBloc: BlocProvider.of<SalesFinDocBloc>(context))),
          BlocProvider<OpportunityBloc>(
              create: (context) => OpportunityBloc(repos)),
          BlocProvider<AccntgBloc>(
              create: (context) => AccntgBloc(repos)..add(LoadAccntg())),
        ],
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String classificationId = GlobalConfiguration().get("classificationId");
    return MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget),
            maxWidth: 2460,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
        theme: Themes.formTheme,
        onGenerateRoute: router.generateRoute,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthProblem)
              return core.FatalErrorForm("Internet or server problem?");
            if (state is AuthUnauthenticated) {
              if (state.authenticate?.company == null) {
                if (classificationId == 'AppAdmin')
                  return core.RegisterForm(
                      'No companies found in system, create one?');
                else
                  return core.FatalErrorForm(
                      S.of(context).classificationNotDefined(classificationId));
              } else
                return HomeForm();
            }
            if (state is AuthAuthenticated) {
              if (classificationId == 'AppAdmin') {
                return HomeForm();
              } else
                return core.FatalErrorForm(S
                    .of(context)
                    .screenNotFound('for classification ' + classificationId));
            }
            return core.SplashForm();
          },
        ));
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Cubit cubit, Object event) {
    print(">>>Bloc event { $event: }");
    super.onEvent(cubit, event);
  }

  @override
  void onTransition(Cubit cubit, Transition transition) {
    print(">>>$transition");
    super.onTransition(cubit, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(">>>error: $error");
    super.onError(cubit, error, stackTrace);
  }
}
