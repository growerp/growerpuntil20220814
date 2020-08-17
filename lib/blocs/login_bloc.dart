import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../services/repos.dart';
import '../models/@models.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Repos repos;

  LoginBloc({
    @required this.repos,
  })  : assert(repos != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoadLogin) {
      yield LoginLoading();
      if (event.companyPartyId == null) {
        dynamic companies = await repos.getCompanies();
        if (companies is List) {
          yield LoginLoaded(companies: companies);
        } else {
          yield LoginError(companies);
        }
      } else {
        // create new customer existing company
        yield LoginLoaded();
      }
    }
    if (event is LoginButtonPressed) {
      yield LogginInProgress();
      final result = await repos.login(
        companyPartyId: event.companyPartyId,
        username: event.username,
        password: event.password,
      );
      if (result is Authenticate) {
        yield LoginOk(result);
      } else if (result == "passwordChange") {
        yield LoginChangePw(event.username, event.password);
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
  final String companyPartyId;
  final String companyName;
  final String username;

  LoadLogin([this.companyPartyId, this.companyName, this.username]);
  @override
  List<Object> get props => [companyPartyId, companyName, username];

  @override
  String toString() =>
      'Login Load event: company: $companyName[$companyPartyId] username: $username';
}

class LoginButtonPressed extends LoginEvent {
  final String companyPartyId;
  final String username;
  final String password;

  const LoginButtonPressed({
    @required this.companyPartyId,
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
  final List<Company> companies;
  LoginLoaded({this.companies});
  @override
  List<Object> get props => [companies];
  String toString() => 'Login loaded, companies size: ${companies?.length}';
}

class LoginChangePw extends LoginState {
  final String username;
  final String password;
  LoginChangePw(this.username, this.password);
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
