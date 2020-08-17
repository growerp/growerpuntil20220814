import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../services/repos.dart';
import '../models/@models.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Repos repos;

  RegisterBloc({
    @required this.repos,
  })  : assert(repos != null),
        super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is LoadRegister) {
      yield RegisterLoading();
      if (event.companyPartyId == null) {
        // create new company and admin user
        dynamic currencies = await repos.getCurrencies();
        if (currencies is List) {
          yield RegisterLoaded(currencies: currencies);
        } else {
          yield RegisterError(currencies);
        }
      } else {
        // create new customer existing company
        yield RegisterLoaded();
      }
    } else if (event is RegisterButtonPressed) {
      yield RegisterSending();
      final authenticate = await repos.register(
          companyPartyId: event.companyPartyId,
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email);
      if (authenticate is Authenticate) {
        await repos.persistAuthenticate(authenticate);
        yield RegisterSuccess(authenticate);
      } else {
        yield RegisterError(authenticate);
      }
    } else if (event is CreateShopButtonPressed) {
      yield RegisterSending();
      final authenticate = await repos.register(
          companyName: event.companyName,
          currency: event.currency,
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email);
      if (authenticate is Authenticate) {
        await repos.persistAuthenticate(authenticate);
        yield RegisterSuccess(authenticate);
      } else {
        yield RegisterError(authenticate);
      }
    }
  }
}

//--------------------------events ---------------------------------
@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class LoadRegister extends RegisterEvent {
  final String companyPartyId;
  final String companyName;

  LoadRegister({this.companyPartyId, this.companyName});
  @override
  List<Object> get props => [companyPartyId];

  @override
  String toString() => 'Register Load event: companyPartyId: $companyPartyId';
}

class RegisterButtonPressed extends RegisterEvent {
  final String companyPartyId;
  final String firstName;
  final String lastName;
  final String email;

  const RegisterButtonPressed({
    @required this.companyPartyId,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
  });

  @override
  List<Object> get props => [companyPartyId, firstName, lastName, email];

  @override
  String toString() =>
      'RegisterButtonPressed { first/Last name: $firstName/$lastName,' +
      ' email: $email }';
}

class CreateShopButtonPressed extends RegisterEvent {
  final String companyName;
  final String currency;
  final String firstName;
  final String lastName;
  final String email;

  const CreateShopButtonPressed({
    @required this.companyName,
    @required this.currency,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
  });

  @override
  List<Object> get props => [companyName, currency, firstName, lastName, email];

  @override
  String toString() =>
      'Create shop ButtonPressed { company name: $companyName, email: $email }';
}

// -------------------------------state ------------------------------
@immutable
abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterLoaded extends RegisterState {
  final List<String> currencies;
  RegisterLoaded({this.currencies});
  @override
  List<Object> get props => [currencies];
  @override
  String toString() => "Register Loaded: currencies: ${currencies?.length}";
}

class RegisterSending extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final Authenticate authenticate;
  RegisterSuccess(this.authenticate);
  List<Object> get props => [authenticate];
  String toString() =>
      "Register success new company: " +
      "${authenticate.company.name}[${authenticate.company.partyId}]";
}

class RegisterError extends RegisterState {
  final String errorMessage;

  const RegisterError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'RegisterError { error: $errorMessage }';
}
