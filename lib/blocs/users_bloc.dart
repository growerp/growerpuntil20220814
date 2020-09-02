import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../models/@models.dart';
import '../services/repos.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final Repos repos;
  final String companyPartyId;

  UsersBloc({@required this.repos, @required this.companyPartyId})
      : super(UsersInitial());

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    if (event is LoadUser) {
      yield UsersLoading();
      dynamic result = await repos.getUser(event.partyId);
      if (result is User) {
        yield UserLoaded(result);
      } else if (result is List<User>)
        yield UsersLoaded(result);
      else
        yield UsersError(result);
    } else if (event is UpdateUser) {
      yield UsersLoading();
      dynamic result;
      if (event.imageFilename != null)
        result = await repos.uploadImage(
            type: 'user',
            id: event.user?.partyId,
            fileName: event.imageFilename);
      if (result != null) yield UsersError(result);
      result = await repos.updateUser(event.user);
      if (result is User) {
        yield UserUpdateSuccess(result);
      } else {
        yield UserLoaded(event.user);
        yield UsersError(result);
      }
    } else if (event is DeleteUser) {
      dynamic result = await repos.deleteUser(event.partyId);
      if (result == event.partyId)
        yield UserDeleteSuccess();
      else
        yield UsersError(result);
    } else if (event is UploadImage) {
      yield UsersLoading();
      dynamic result = await repos.uploadImage(
          type: 'user', id: event.partyId, fileName: event.fileName);
      if (result == null)
        yield UserPictUpdated();
      else
        yield UsersError(result);
    }
  }
}

// ################# events ###################
@immutable
abstract class UsersEvent extends Equatable {
  const UsersEvent();
  @override
  List<Object> get props => [];
}

class LoadUser extends UsersEvent {
  final String partyId; // null for list, present for single party
  LoadUser([this.partyId]); // true for list otherwise detail
  String toString() => "Loaduser: loading user(s) : "
      "${partyId == null ? 'party list' : 'party: $partyId'}";
}

class UpdateUser extends UsersEvent {
  // partyId empty = add
  final String imageFilename;
  final User user;
  UpdateUser(this.user, [this.imageFilename]);
  String toString() => "Update user: ${this.user?.firstName} "
      "${this.user?.lastName}[${this.user?.partyId}]"
      "image: ${imageFilename != null ? imageFilename.length : ''}";
}

class UploadImage extends UsersEvent {
  final String partyId;
  final String fileName;
  UploadImage(this.partyId, this.fileName);
  String toString() => "Upload User $partyId image at $fileName]";
}

class DeleteUser extends UsersEvent {
  final String partyId;
  DeleteUser(this.partyId);
  String toString() => "Delete user: partyId: ${this.partyId}";
}

// ################## state ###################
@immutable
abstract class UsersState extends Equatable {
  const UsersState();
  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UserPictUpdated extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;
  const UsersLoaded(this.users);
  @override
  List<Object> get props => [users];
  @override
  String toString() => 'UsersLoaded, users: ${users?.length}';
}

class UserLoaded extends UsersState {
  final User user;
  const UserLoaded(this.user);
  @override
  List<Object> get props => [user];
  @override
  String toString() => 'UserLoaded, user: ${this.user?.firstName} '
      '${this.user?.lastName}[${this.user?.partyId}]';
}

class UserUpdateSuccess extends UsersState {
  final User user;
  const UserUpdateSuccess(this.user);
  @override
  List<Object> get props => [user];
  @override
  String toString() => 'UserUpdateSuccess, user: ${this.user?.firstName} '
      '${this.user?.lastName}[${this.user?.partyId}]';
}

class UserDeleteSuccess extends UsersState {}

class UsersError extends UsersState {
  final String errorMessage;
  const UsersError(this.errorMessage);
  @override
  List<Object> get props => [];
  @override
  String toString() => 'UsersError { error: $errorMessage }';
}
