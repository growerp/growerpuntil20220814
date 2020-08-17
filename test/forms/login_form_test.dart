import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:master/blocs/@bloc.dart';
import 'package:master/services/repos.dart';
import 'package:master/forms/@forms.dart';
import 'package:master/models/@models.dart';
import 'package:master/router.dart' as router;
import '../data.dart';

class MockRepos extends Mock implements Repos {}

class MockAuthBloc extends MockBloc<AuthState> implements AuthBloc {}

class MockLoginBloc extends MockBloc<LoginState> implements LoginBloc {}

void main() {
  group('Login_Form test:', () {
    Repos repos;
    LoginBloc loginBloc;
    AuthBloc authBloc;

    setUp(() {
      repos = MockRepos();
      authBloc = MockAuthBloc();
      loginBloc = MockLoginBloc();
    });

    tearDown(() {
      loginBloc.close();
      authBloc.close();
    });

    testWidgets('check text fields with company selection',
        (WidgetTester tester) async {
      when(authBloc.state).thenReturn(AuthUnauthenticated(null));
      when(loginBloc.state).thenReturn(LoginLoaded(companies: companies));
      await tester.pumpWidget(RepositoryProvider(
        create: (context) => repos,
        child: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: MaterialApp(
            onGenerateRoute: router.generateRoute,
            home: Scaffold(
              body: LoginForm(),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('drop_down')), findsOneWidget);
      whenListen(loginBloc, Stream.fromIterable(<LoginEvent>[LoadLogin()]));
    });

    testWidgets('check text fields with NO company dropdown: customer login',
        (WidgetTester tester) async {
      when(authBloc.state).thenReturn(AuthUnauthenticated(
          Authenticate(company: Company(partyId: '100000', name: 'dummy'))));
      when(loginBloc.state).thenReturn(LoginLoaded(companies: companies));
      await tester.pumpWidget(RepositoryProvider(
        create: (context) => repos,
        child: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: MaterialApp(
            onGenerateRoute: router.generateRoute,
            home: Scaffold(
              body: LoginForm(),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('drop_down')), findsNothing);
      whenListen(loginBloc, Stream.fromIterable(<LoginEvent>[LoadLogin()]));
    });
    testWidgets('enter fields and press login', (WidgetTester tester) async {
      when(authBloc.state).thenReturn(AuthUnauthenticated(null));
//      when(loginBloc.state).thenReturn(LoginLoaded(companies));
      when(authBloc.state).thenReturn(AuthUnauthenticated(
          Authenticate(company: Company(partyId: '100000', name: 'dummy'))));
      when(loginBloc.state).thenReturn(LoginLoaded(companies: companies));
      await tester.pumpWidget(RepositoryProvider(
        create: (context) => repos,
        child: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: MaterialApp(
            onGenerateRoute: router.generateRoute,
            home: Scaffold(
              body: LoginForm(),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('username')), username);
      await tester.enterText(find.byKey(Key('password')), password);
      await tester.tap(find.widgetWithText(RaisedButton, 'Login'));
      await tester.pumpAndSettle();

      whenListen(
          loginBloc,
          Stream.fromIterable(<LoginEvent>[
            LoginButtonPressed(
                companyPartyId: companyPartyId,
                username: username,
                password: password)
          ]));
    });
    testWidgets('goto register screen: register new customer',
        (WidgetTester tester) async {
      when(authBloc.state).thenReturn(AuthUnauthenticated(authenticate));
      await tester.pumpWidget(RepositoryProvider(
        create: (context) => repos,
        child: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: MaterialApp(
            onGenerateRoute: router.generateRoute,
            home: Scaffold(
              body: LoginForm(),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(GestureDetector, 'register new account'));
      await tester.pumpAndSettle();
      expect(find.text('Register as a customer'), findsOneWidget);
    });
    testWidgets('forgot password', (WidgetTester tester) async {
      when(authBloc.state).thenReturn(AuthUnauthenticated(
          Authenticate(company: Company(partyId: '100000', name: 'dummy'))));
      when(loginBloc.state).thenReturn(LoginLoaded(companies: companies));
      await tester.pumpWidget(RepositoryProvider(
        create: (context) => repos,
        child: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: MaterialApp(
            onGenerateRoute: router.generateRoute,
            home: Scaffold(
              body: LoginForm(),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('forgot password?'), findsOneWidget);
      await tester
          .tap(find.widgetWithText(GestureDetector, 'forgot password?'));
      await tester.pumpAndSettle();
      expect(
          find.text(
              'Email you registered with?\nWe will send you a reset password'),
          findsOneWidget);
      await tester.press(find.widgetWithText(FlatButton, 'Ok'));
      expect(find.text('forgot password?'), findsOneWidget);
    });
  });
}
