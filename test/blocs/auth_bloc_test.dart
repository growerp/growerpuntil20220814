import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:master/blocs/@bloc.dart';
import 'package:master/services/repos.dart';
import '../data.dart';

class MockReposRepository extends Mock implements Repos {}

void main() {
  MockReposRepository mockReposRepository;

  setUp(() {
    mockReposRepository = MockReposRepository();
  });

  group('Authbloc test', () {
    blocTest(
      'check initial state',
      build: () => AuthBloc(repos: mockReposRepository),
      expect: <AuthState>[],
    );

    blocTest(
      'succesful connection and Unauthenticated',
      build: () => AuthBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getConnected()).thenAnswer((_) async => true);
        when(mockReposRepository.getAuthenticate())
            .thenAnswer((_) async => authenticateNoKey);
        bloc.add(LoadAuth());
      },
      expect: <AuthState>[
        AuthLoading(),
        AuthUnauthenticated(authenticateNoKey),
      ],
    );
    blocTest(
      'failed connection with ConnectionProblem',
      build: () => AuthBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getConnected())
            .thenAnswer((_) async => errorMessage);
        bloc.add(LoadAuth());
      },
      expect: <AuthState>[
        AuthLoading(),
        AuthConnectionProblem(errorMessage),
      ],
    );

    blocTest(
      'succesfull connection and Authenticated',
      build: () => AuthBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getConnected()).thenAnswer((_) async => true);
        when(mockReposRepository.getAuthenticate())
            .thenAnswer((_) async => authenticate);
        authenticate.apiKey = 'dummyKey';
        bloc.add(LoadAuth());
      },
      expect: <AuthState>[
        AuthLoading(),
        AuthAuthenticated(authenticate),
      ],
    );
    blocTest(
      'connection and login and logout',
      build: () => AuthBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getConnected()).thenAnswer((_) async => true);
        when(mockReposRepository.getAuthenticate())
            .thenAnswer((_) async => authenticateNoKey);
        when(mockReposRepository.logout())
            .thenAnswer((_) async => authenticateNoKey);
        bloc.add(LoadAuth());
        bloc.add(LoggedIn(authenticate: authenticate));
        bloc.add(Logout());
      },
      expect: <AuthState>[
        AuthLoading(),
        AuthUnauthenticated(authenticateNoKey),
        AuthAuthenticated(authenticate),
        AuthUnauthenticated(authenticateNoKey),
      ],
    );
    blocTest(
      'succesful connection and register',
      build: () => AuthBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getConnected()).thenAnswer((_) async => true);
        when(mockReposRepository.getAuthenticate())
            .thenAnswer((_) async => authenticateNoKey);
        bloc.add(LoadAuth());
        bloc.add(LoggedIn(authenticate: authenticate));
      },
      expect: <AuthState>[
        AuthLoading(),
        AuthUnauthenticated(authenticateNoKey),
        AuthAuthenticated(authenticate),
      ],
    );

    dynamic result = Response;
    blocTest(
      'succesful connection login screen and reset password',
      build: () => AuthBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getConnected()).thenAnswer((_) async => true);
        when(mockReposRepository.getAuthenticate())
            .thenAnswer((_) async => authenticateNoKey);
        when(mockReposRepository.resetPassword(username: 'dummyEmail'))
            .thenAnswer((_) async => result);
        bloc.add(LoadAuth());
        await bloc.add(ResetPassword(username: 'dummyEmail'));
      },
      expect: <AuthState>[
        AuthLoading(),
        AuthUnauthenticated(authenticateNoKey),
      ],
    );
  });
}
