import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../services/repos.dart';
import '../models/@models.dart';

/// Authbloc controls the connection to the backend
///
/// It contains company and user information and signals connection errrors,
/// keeps the token and apiKey in the [Authenticate] class.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Repos repos;

  AuthBloc({@required this.repos})
      : assert(repos != null),
        super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoadAuth) {
      yield AuthLoading();
      final dynamic connected = await repos.getConnected();
      if (connected is String) {
        yield AuthConnectionProblem(connected);
      } else {
        Authenticate authenticate = await repos.getAuthenticate();
        if (authenticate == null || authenticate?.company == null) {
          dynamic companies = await repos.getCompanies();
          if (companies is String)
            yield AuthConnectionProblem(companies);
          else if (companies != null && companies.length > 0) {
            authenticate = Authenticate(company: companies[0], user: null);
            await repos.persistAuthenticate(authenticate);
            yield AuthUnauthenticated(authenticate);
          } else
            yield AuthUnauthenticated(null);
        } else {
          if (authenticate.apiKey != null) {
            repos.setApikey(authenticate.apiKey);
            dynamic result = await repos.checkApikey();
            if (result is bool && result == true)
              yield AuthAuthenticated(authenticate);
            else {
              authenticate.apiKey = null; // revoked
              repos.setApikey(null);
              await repos.persistAuthenticate(authenticate);
              yield AuthUnauthenticated(authenticate);
            }
          } else
            yield AuthUnauthenticated(authenticate);
        }
      }
    } else if (event is LoggedIn) {
      await repos.persistAuthenticate(event.authenticate);
      yield AuthAuthenticated(event.authenticate);
    } else if (event is Logout) {
      final Authenticate authenticate = await repos.logout();
      yield AuthUnauthenticated(authenticate);
    } else if (event is ResetPassword) {
      await repos.resetPassword(username: event.username);
    } else if (event is UpdateAuth) {
      await repos.persistAuthenticate(event.authenticate);
      yield AuthUnauthenticated(event.authenticate);
    } else {
      final Authenticate authenticate = await repos.getAuthenticate();
      yield AuthUnauthenticated(authenticate);
    }
  }
}

//--------------------------events---------------------------------------
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class ConnectionProblem extends AuthEvent {}

class LoadAuth extends AuthEvent {
  @override
  String toString() => 'Load AuthBoc with backend status.';
}

class Logout extends AuthEvent {}

class UpdateAuth extends AuthEvent {
  final Authenticate authenticate;

  UpdateAuth(this.authenticate);
  @override
  List<Object> get props => [authenticate];

  @override
  String toString() => 'Update Authenticate in AuthBloc';
}

class LoggedIn extends AuthEvent {
  final Authenticate authenticate;
  const LoggedIn({@required this.authenticate});
  @override
  List<Object> get props => [authenticate.user.name];
  @override
  String toString() => 'LoggingIn userName: ${authenticate.user.name}';
}

class ResetPassword extends AuthEvent {
  final String username;
  const ResetPassword({@required this.username});
  @override
  List<Object> get props => [username];
  @override
  String toString() => 'ResetPassword userName: $username';
}

class LoggingOut extends AuthEvent {
  final Authenticate authenticate;
  const LoggingOut({this.authenticate});
  @override
  List<Object> get props => [authenticate];
  @override
  String toString() => 'loggedOut userName: ${authenticate?.user?.name}';
}

//------------------------------state ------------------------------------
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthConnectionProblem extends AuthState {
  final String errorMessage;
  AuthConnectionProblem(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
  @override
  String toString() => 'AuthConnectionProblem: errorMessage: $errorMessage';
}

class AuthAuthenticated extends AuthState {
  final Authenticate authenticate;
  AuthAuthenticated(this.authenticate);
  @override
  List<Object> get props => [authenticate];
  @override
  String toString() =>
      'AuthAuthenticated, company: ${authenticate?.company?.name}' +
      '[${authenticate?.company?.partyId}] username: ${authenticate?.user?.name}';
}

class AuthUnauthenticated extends AuthState {
  final Authenticate authenticate;
  AuthUnauthenticated(this.authenticate);
  @override
  List<Object> get props => [authenticate];
  @override
  String toString() =>
      'AuthUnauthenticated: company: ${authenticate?.company?.name}' +
      '[${authenticate?.company?.partyId}] username: ${authenticate?.user?.name}';
}
