import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:admin/blocs/@blocs.dart';
import 'package:admin/services/@services.dart';
import '../data.dart';

class MockReposRepository extends Mock implements Moqui {}

class MockAuthBloc extends MockBloc<AuthState> implements AuthBloc {}

void main() {
  MockReposRepository mockReposRepository;
  MockAuthBloc mockAuthBloc;

  setUp(() {
    mockReposRepository = MockReposRepository();
    mockAuthBloc = MockAuthBloc();
  });

  tearDown(() {
    mockAuthBloc?.close();
  });

  group('Register bloc test', () {
    blocTest(
      'check initial state',
      build: () => RegisterBloc(repos: mockReposRepository),
      expect: <AuthState>[],
    );

    blocTest(
      'Register load success',
      build: () =>
          RegisterBloc(repos: mockReposRepository)..add(LoadRegister()),
      expect: <RegisterState>[RegisterLoading(), RegisterLoaded()],
    );

    blocTest(
      'Register existing shop success',
      build: () => RegisterBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.register(
                companyPartyId: companyPartyId,
                firstName: firstName,
                lastName: lastName,
                email: emailAddress))
            .thenAnswer((_) async => authenticate);
        bloc.add(LoadRegister());
        bloc.add(RegisterButtonPressed(
            companyPartyId: companyPartyId,
            firstName: firstName,
            lastName: lastName,
            email: emailAddress));
      },
      expect: <RegisterState>[
        RegisterLoading(),
        RegisterLoaded(),
        RegisterSending(),
        RegisterSuccess(authenticate)
      ],
    );
    blocTest(
      'Register new shop success',
      build: () => RegisterBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.register(
                companyName: companyName,
                currencyId: currencyId,
                firstName: firstName,
                lastName: lastName,
                email: emailAddress))
            .thenAnswer((_) async => authenticateNoKey);
        bloc.add(LoadRegister());
        bloc.add(RegisterCompanyAdmin(
            companyName: companyName,
            currencyId: currencyId,
            firstName: firstName,
            lastName: lastName,
            email: emailAddress));
      },
      expect: <RegisterState>[
        RegisterLoading(),
        RegisterLoaded(),
        RegisterSending(),
        RegisterSuccess(authenticateNoKey)
      ],
    );
    blocTest(
      'Register Failure',
      build: () => RegisterBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.register(
                companyPartyId: companyPartyId,
                firstName: firstName,
                lastName: lastName,
                email: emailAddress))
            .thenAnswer((_) async => errorMessage);
        bloc.add(LoadRegister());
        bloc.add(RegisterButtonPressed(
            companyPartyId: companyPartyId,
            firstName: firstName,
            lastName: lastName,
            email: emailAddress));
      },
      expect: <RegisterState>[
        RegisterLoading(),
        RegisterLoaded(),
        RegisterSending(),
        RegisterError(errorMessage)
      ],
    );
  });
}
