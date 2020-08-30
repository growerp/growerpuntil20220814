import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:master/blocs/@blocs.dart';
import 'package:master/services/repos.dart';
import '../data.dart';

class MockReposRepository extends Mock implements Repos {}

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
      build: () => RegisterBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getCurrencies())
            .thenAnswer((_) async => currencies);
        bloc.add(LoadRegister());
      },
      expect: <RegisterState>[
        RegisterLoading(),
        RegisterLoaded(currencies: currencies)
      ],
    );

    blocTest(
      'Register load error',
      build: () => RegisterBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getCurrencies())
            .thenAnswer((_) async => errorMessage);
        bloc.add(LoadRegister());
      },
      expect: <RegisterState>[RegisterLoading(), RegisterError(errorMessage)],
    );

    blocTest(
      'Register existing shop success',
      build: () => RegisterBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getCurrencies())
            .thenAnswer((_) async => currencies);
        when(mockReposRepository.register(
                companyPartyId: companyPartyId,
                firstName: firstName,
                lastName: lastName,
                email: email))
            .thenAnswer((_) async => authenticate);
        bloc.add(LoadRegister());
        bloc.add(RegisterButtonPressed(
            companyPartyId: companyPartyId,
            firstName: firstName,
            lastName: lastName,
            email: email));
      },
      expect: <RegisterState>[
        RegisterLoading(),
        RegisterLoaded(currencies: currencies),
        RegisterSending(),
        RegisterSuccess(authenticate)
      ],
    );
    blocTest(
      'Register new shop success',
      build: () => RegisterBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getCurrencies())
            .thenAnswer((_) async => currencies);
        when(mockReposRepository.register(
                companyName: companyName,
                currency: currencyId,
                firstName: firstName,
                lastName: lastName,
                email: email))
            .thenAnswer((_) async => authenticateNoKey);
        bloc.add(LoadRegister());
        bloc.add(RegisterCompanyAdmin(
            companyName: companyName,
            currency: currencyId,
            firstName: firstName,
            lastName: lastName,
            email: email));
      },
      expect: <RegisterState>[
        RegisterLoading(),
        RegisterLoaded(currencies: currencies),
        RegisterSending(),
        RegisterSuccess(authenticateNoKey)
      ],
    );
    blocTest(
      'Register Failure',
      build: () => RegisterBloc(repos: mockReposRepository),
      act: (bloc) async {
        when(mockReposRepository.getCurrencies())
            .thenAnswer((_) async => currencies);
        when(mockReposRepository.register(
                companyPartyId: companyPartyId,
                firstName: firstName,
                lastName: lastName,
                email: email))
            .thenAnswer((_) async => errorMessage);
        bloc.add(LoadRegister());
        bloc.add(RegisterButtonPressed(
            companyPartyId: companyPartyId,
            firstName: firstName,
            lastName: lastName,
            email: email));
      },
      expect: <RegisterState>[
        RegisterLoading(),
        RegisterLoaded(currencies: currencies),
        RegisterSending(),
        RegisterError(errorMessage)
      ],
    );
  });
}
