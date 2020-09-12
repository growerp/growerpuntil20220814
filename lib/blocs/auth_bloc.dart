/*
 * This software is in the public domain under CC0 1.0 Universal plus a
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
        yield AuthProblem(connected);
      } else {
        Authenticate authenticate = await repos.getAuthenticate();
        if (authenticate?.company?.partyId != null) {
          // check if company still exist
          dynamic result = await repos.checkCompany(authenticate.company.partyId);
          if (result == false) {
            // when not get default company
            authenticate.company = null;
          }
        }
        if (authenticate?.company == null) {
          // no preferred company yet, find one
          dynamic companies = await repos.getCompanies();
          if (companies is String)
            yield AuthProblem(companies);
          else if (companies != null && companies.length > 0) {
            authenticate = Authenticate(company: companies[0], user: null);
            await repos.persistAuthenticate(authenticate);
            yield AuthUnauthenticated(authenticate);
          } else
            yield AuthUnauthenticated(null);
        } else {
          // check if apiKey still valid
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
    } else if (event is UpdateCompany) {
      yield AuthLoading();
      dynamic result;
      if (event.imageFilename != null) {
        result = await repos.uploadImage(
            type: 'company',
            id: event.authenticate.company.partyId,
            fileName: event.imageFilename);
        if (result != null) yield AuthProblem(result);
      } else {
        result = await repos.updateCompany(event.authenticate.company);
        if (result is Company) {
          event.authenticate.company = result;
          yield AuthCompanyUpdateSuccess(event.authenticate);
        } else {
          yield AuthProblem(result);
        }
      }
    } else if (event is UpdateUser) {
      yield AuthLoading();
      dynamic result;
      if (event.imageFilename != null) {
        result = await repos.uploadImage(
            type: 'user',
            id: event.authenticate.user.partyId,
            fileName: event.imageFilename);
        if (result != null) yield AuthProblem(result);
      } else {
        result = await repos.updateUser(event.user);
        if (result is User) {
          event.authenticate.user = result;
          await repos.persistAuthenticate(event.authenticate);
          yield AuthUserUpdateSuccess(event.authenticate);
        } else {
          yield AuthProblem(result);
        }
      }
    } else if (event is UploadImage) {
      yield AuthLoading();
      dynamic result = await repos.uploadImage(
          type: 'user', id: event.partyId, fileName: event.fileName);
      if (result == null)
        yield AuthImageUpdated();
      else
        yield AuthProblem(result);
    } else {
      final Authenticate authenticate = await repos.getAuthenticate();
      if (authenticate.apiKey != null)
        yield AuthAuthenticated(authenticate);
      else
        yield AuthUnauthenticated(authenticate);
    }
  }
}

// ################# events ###################
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

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
  String toString() => 'Update Authenticate ${authenticate.toString()}';
}

class UpdateCompany extends AuthEvent {
  final Authenticate authenticate;
  final String imageFilename;
  UpdateCompany(this.authenticate, this.imageFilename);
  @override
  List<Object> get props => [authenticate];
  @override
  String toString() => 'Update Company ${authenticate.company.toString()}';
}

class UpdateUser extends AuthEvent {
  final Authenticate authenticate;
  final User user;
  final String imageFilename;
  UpdateUser(this.authenticate, this.user, this.imageFilename);
  @override
  List<Object> get props => [authenticate];
  @override
  String toString() => 'Update User ${authenticate.user.toString()} ';
}

class DeleteUser extends AuthEvent {
  final Authenticate authenticate;
  final String partyId;
  DeleteUser(this.authenticate, this.partyId);
  @override
  List<Object> get props => [authenticate];
  @override
  String toString() => 'Update User ${authenticate.user.toString()} ';
}

class LoggedIn extends AuthEvent {
  final Authenticate authenticate;
  const LoggedIn({@required this.authenticate});
  @override
  List<Object> get props => [authenticate.user.name];
  @override
  String toString() => 'Logging in userName: ${authenticate.user.toString()}';
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

class UploadImage extends AuthEvent {
  final String partyId;
  final String fileName;
  UploadImage(this.partyId, this.fileName);
  String toString() => "Upload User $partyId image at $fileName]";
}

// ################## state ###################
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthImageUpdated extends AuthState {}

class AuthProblem extends AuthState {
  final String errorMessage;
  AuthProblem(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
  @override
  String toString() => 'AuthProblem: errorMessage: $errorMessage';
}

class AuthUserUpdateSuccess extends AuthAuthenticated {
  AuthUserUpdateSuccess(Authenticate authenticate) : super(authenticate);
}

class AuthUserDeleteSuccess extends AuthAuthenticated {
  AuthUserDeleteSuccess(Authenticate authenticate) : super(authenticate);
}

class AuthCompanyUpdateSuccess extends AuthAuthenticated {
  AuthCompanyUpdateSuccess(Authenticate authenticate) : super(authenticate);
}

class AuthAuthenticated extends AuthState {
  final Authenticate authenticate;
  AuthAuthenticated(this.authenticate);
  @override
  List<Object> get props => [authenticate];
  @override
  String toString() => authenticate.toString();
}

class AuthUnauthenticated extends AuthState {
  final Authenticate authenticate;
  AuthUnauthenticated(this.authenticate);
  @override
  List<Object> get props => [authenticate];
  @override
  String toString() => authenticate.toString();
}
