import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:master/blocs/@bloc.dart';
import 'package:master/services/repos.dart';
import '../data.dart';

class MockReposRepository extends Mock implements Repos {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MockReposRepository mockReposRepository;

  setUp(() {
    mockReposRepository = MockReposRepository();
  });

  group('ChangePassword bloc test', () {
    blocTest('check initial state',
        build: () => ChangePwBloc(repos: mockReposRepository),
        expect: <AuthState>[]);

    blocTest('ChangePw success',
        build: () => ChangePwBloc(repos: mockReposRepository),
        act: (bloc) async {
          when(mockReposRepository.updatePassword(
                  username: username,
                  oldPassword: password,
                  newPassword: password))
              .thenAnswer((_) async => authenticateNoKey);
          bloc.add(ChangePwButtonPressed(
              username: username,
              oldPassword: password,
              newPassword: password));
        },
        expect: <ChangePwState>[ChangePwInProgress(), ChangePwOk()]);
// cannot run see: https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
/*    blocTest('ChangePw failure',
        build: () =>
            ChangePwBloc(authBloc: mockAuthBloc, repos: mockReposRepository),
        act: (bloc) async {
          when(mockReposRepository.updatePassword(
                  username: username,
                  oldPassword: password,
                  newPassword: password))
              .thenAnswer((_) async => errorMessage);
          bloc.add(ChangePwButtonPressed(
              username: username, oldPassword: password, newPassword: password));
          whenListen(mockAuthBloc, Stream.fromIterable(<AuthEvent>[Login()]));
        },
      expect: <ChangePwState>[
        ChangePwInProgress(),
        ChangePwFailure(message: errorMessage)
      ],
    );
*/
  });
}
