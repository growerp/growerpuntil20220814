import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
<<<<<<< HEAD
import 'package:master/blocs/@blocs.dart';
import 'package:master/services/repos.dart';
=======
import 'package:ecommerce/blocs/@blocs.dart';
import 'package:ecommerce/services/@services.dart';
>>>>>>> 839327b... added central configuration file
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
      build: () => RegisterBloc(repos: mockReposRepository)..add(LoadRegister()),
      expect: <RegisterState>[
        RegisterLoading(),
        RegisterLoaded()
      ],
    );

    blocTest(
      'Register existing shop success',
      build: () => RegisterBloc(repos: mockReposRepository),
      act: (bloc) async {
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
        RegisterLoaded(),
        RegisterSending(),
        RegisterError(errorMessage)
      ],
    );
  });
}
