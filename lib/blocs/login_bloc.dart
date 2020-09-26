import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../models/@models.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final repos;

  LoginBloc({
    @required this.repos,
  })  : assert(repos != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoadLogin) {
      yield LoginLoading();
      if (event.authenticate?.company?.partyId == null) {
        // no company selected yet so select one
        dynamic companies = await repos.getCompanies();
        if (companies is List) {
          yield LoginLoaded(event.authenticate, companies);
        } else {
          yield LoginError(companies);
        }
      } else {
        // create new customer existing company
        yield LoginLoaded(event.authenticate);
      }
    }
    if (event is LoginButtonPressed) {
      yield LogginInProgress();
      final result = await repos.login(
        username: event.username,
        password: event.password,
      );
      if (result is Authenticate) {
        if (result.company == null) result.company = event.company;
        yield LoginOk(result);
      } else if (result == "passwordChange") {
        yield LoginChangePw(event.company, event.username, event.password);
      } else {
        yield LoginError(result);
      }
    }
  }
}

//--------------------------events ---------------------------------
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoadLogin extends LoginEvent {
  final Authenticate authenticate;
  LoadLogin([this.authenticate]);

  @override
  String toString() =>
      'Login Load event: company: ${authenticate?.company?.toString()}';
}

class LoginButtonPressed extends LoginEvent {
  final Company company;
  final String username;
  final String password;

  const LoginButtonPressed({
    @required this.company,
    @required this.username,
    @required this.password,
  });

  @override
  String toString() => 'LoginButtonPressed { username: $username }';
}

// -------------------------------state ------------------------------
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final Authenticate authenticate;
  final List<Company> companies;
  LoginLoaded(this.authenticate, [this.companies]);
  @override
  List<Object> get props => [companies];
  String toString() => 'Login loaded, companies size: ${companies?.length}';
}

class LoginChangePw extends LoginState {
  final Company company;
  final String username;
  final String password;
  LoginChangePw(this.company, this.username, this.password);
  @override
  List<Object> get props => [username];
  @override
  String toString() => 'LoginChangePw { username: $username }';
}

class LoginOk extends LoginState {
  final Authenticate authenticate;
  LoginOk(this.authenticate);
  @override
  List<Object> get props => [authenticate];
  @override
  String toString() => 'LoginOk { username: ${authenticate.user.name} }';
}

class LogginInProgress extends LoginState {}

class LoginError extends LoginState {
  final String errorMessage;
  LoginError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
  @override
  String toString() => 'LoginError { error: $errorMessage }';
}
