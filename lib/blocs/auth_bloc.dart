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
import '../models/@models.dart';

/// Authbloc controls the connection to the backend
///
/// It contains company and user information and signals connection errrors,
/// keeps the token and apiKey in the [Authenticate] class.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final repos;
  Authenticate authenticate;

  AuthBloc(this.repos)
      : assert(repos != null),
        super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    // ################# local functions ###################

    Future<void> findDefaultCompany() async {
      //print("===15==1==");
      dynamic companies = await repos.getCompanies();
      if (companies is List<Company> && companies.length > 0) {
        // print("===15==2==");
        authenticate = Authenticate(company: companies[0], user: null);
        await repos.persistAuthenticate(authenticate);
      } else {
        //print("===15==3==");
        authenticate = null;
        await repos.persistAuthenticate(authenticate);
      }
    }

    Future<AuthState> checkApikey() async {
      // print("===10==== apiKey: ${authenticate?.apiKey}");
      if (authenticate?.apiKey == null) {
        return AuthUnauthenticated(authenticate);
      } else {
        repos.setApikey(authenticate?.apiKey);
        dynamic result = await repos.checkApikey();
        // print("=====checkapiKey result: $result");
        if (result is bool && result) {
          // print("===11====");
          return AuthAuthenticated(authenticate);
        } else {
          //print("===12====");
          authenticate.apiKey = null; // revoked
          repos.setApikey(null);
          //print("===13====");
          await repos.persistAuthenticate(authenticate);
          return AuthUnauthenticated(authenticate);
        }
      }
    }

    // ################# start bloc ###################
    if (event is LoadAuth) {
      yield AuthLoading();
      dynamic connected = await repos.getConnected();
      if (connected is String) {
        yield AuthProblem(connected);
      } else {
        authenticate = await repos.getAuthenticate();
        if (authenticate?.company?.partyId != null) {
          //print("===1====${authenticate.apiKey}");
          // check company
          dynamic result =
              await repos.checkCompany(authenticate.company.partyId);
          if (result == false) await findDefaultCompany();
          // now check user apiKey
          yield await checkApikey();
        } else {
          //print("===3====${authenticate?.apiKey}");
          await findDefaultCompany();
          yield await checkApikey();
        }
      }
    } else if (event is LoggedIn) {
      yield AuthLoading();
      await repos.persistAuthenticate(event.authenticate);
      yield AuthAuthenticated(event.authenticate, "Successfully logged in");
    } else if (event is Logout) {
      yield AuthLoading();
      final Authenticate authenticate = await repos.logout();
      yield AuthUnauthenticated(authenticate, "you are logged out now");
    } else if (event is ResetPassword) {
      await repos.resetPassword(username: event.username);
    } else if (event is UpdateAuth) {
      await repos.persistAuthenticate(event.authenticate);
      yield AuthUnauthenticated(event.authenticate);
    } else if (event is UpdateCompany) {
      yield AuthLoading();
      dynamic result =
          await repos.updateCompany(event.company, event.imagePath);
      if (result is Company) {
        authenticate.company = result;
        yield AuthAuthenticated(authenticate, 'Company updated');
      } else {
        yield AuthProblem(result);
      }
    } else if (event is UpdateEmployee) {
      yield AuthLoading((event.user?.partyId == null ? "Adding " : "Updating") +
          " user ${event.user}");
      dynamic result = await repos.updateUser(event.user, event.imagePath);
      if (result is User) {
        if (authenticate.user.partyId == result.partyId)
          authenticate.user = result;
        if (event.user.partyId == null)
          authenticate.company.employees.add(result);
        else {
          int index = authenticate.company.employees
              .indexWhere((user) => user.partyId == result.partyId);
          authenticate.company.employees
              .replaceRange(index, index + 1, [result]);
        }
        await repos.persistAuthenticate(authenticate);
        yield AuthAuthenticated(authenticate,
            'User ' + (event.user?.partyId == null ? 'Added' : 'Updated'));
      } else {
        yield AuthProblem(result);
      }
    } else if (event is DeleteEmployee) {
      yield AuthLoading("Deleting user ${event.user}");
      dynamic result = await repos.deleteUser(event.user.partyId);
      if (result == event.user.partyId) {
        int index = authenticate.company.employees
            .indexWhere((user) => user.partyId == result);
        authenticate.company.employees.removeAt(index);
        await repos.persistAuthenticate(authenticate);
        yield AuthAuthenticated(authenticate, 'User ${event.user} deleted');
      } else {
        yield AuthProblem(result);
      }
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
  final Company company;
  final String imagePath;
  UpdateCompany(this.company, this.imagePath);
  @override
  String toString() => 'Update Company ${company}';
}

class UpdateEmployee extends AuthEvent {
  final User user;
  final String imagePath;
  UpdateEmployee(this.user, this.imagePath);
  @override
  String toString() => (user?.partyId == null ? 'Add' : 'Update') + '$user';
}

class DeleteEmployee extends AuthEvent {
  final User user;
  DeleteEmployee(this.user);
  @override
  String toString() => 'Update User $user';
}

class LoggedIn extends AuthEvent {
  final Authenticate authenticate;
  const LoggedIn(this.authenticate);
  @override
  String toString() => 'Auth Logged in with userName: ${authenticate.user}';
}

class ResetPassword extends AuthEvent {
  final String username;
  const ResetPassword({@required this.username});
  @override
  String toString() => 'ResetPassword userName/email: $username';
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

class AuthLoading extends AuthState {
  final String message;
  AuthLoading([this.message]);
  String toString() => 'Authloading msg: $message';
}

class AuthProblem extends AuthState {
  final String errorMessage;
  AuthProblem(this.errorMessage);
  @override
  String toString() => 'AuthProblem: errorMessage: $errorMessage';
}

class AuthAuthenticated extends AuthState {
  final Authenticate authenticate;
  final String message;
  AuthAuthenticated(this.authenticate, [this.message]);
  @override
  String toString() => 'Authenticated: Msg: $message $authenticate}';
}

class AuthUnauthenticated extends AuthState {
  final Authenticate authenticate;
  final String message;
  AuthUnauthenticated(this.authenticate, [this.message]);
  @override
  String toString() => 'Unauthenticated: msg: $message $authenticate';
}
