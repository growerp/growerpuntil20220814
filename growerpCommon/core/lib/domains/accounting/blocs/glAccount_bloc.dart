/*
 * This GrowERP software is in the public domain under CC0 1.0 Universal plus a
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
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/domains/accounting/models/glAccount_model.dart';
import 'package:core/services/api_result.dart';
import 'package:core/services/network_exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

part 'glAccount_event.dart';
part 'glAccount_state.dart';

const _accntLimit = 20;

EventTransformer<E> accntDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class GlAccountBloc extends Bloc<GlAccountEvent, GlAccountState> {
  GlAccountBloc(this.repos) : super(const GlAccountState()) {
    on<GlAccountFetch>(_onGlAccountFetch,
        transformer: accntDroppable(Duration(milliseconds: 100)));
    on<GlAccountSearchOn>(
        ((event, emit) => emit(state.copyWith(search: true))));
    on<GlAccountSearchOff>(
        ((event, emit) => emit(state.copyWith(search: false))));
  }

  final repos;

  Future<void> _onGlAccountFetch(
    GlAccountFetch event,
    Emitter<GlAccountState> emit,
  ) async {
    if (state.hasReachedMax && !event.refresh && event.searchString.isEmpty)
      return;
    try {
      // start from record zero for initial and refresh
      if (state.status == GlAccountStatus.initial || event.refresh) {
        ApiResult<List<GlAccount>> compResult =
            await repos.getGlAccount(searchString: event.searchString);
        return emit(compResult.when(
            success: (data) => state.copyWith(
                  status: GlAccountStatus.success,
                  glAccounts: data,
                  hasReachedMax: data.length < _accntLimit ? true : false,
                  searchString: '',
                ),
            failure: (NetworkExceptions error) => state.copyWith(
                status: GlAccountStatus.failure, message: error.toString())));
      }
      // get first search page also for changed search
      if (event.searchString.isNotEmpty && state.searchString.isEmpty ||
          (state.searchString.isNotEmpty &&
              event.searchString != state.searchString)) {
        ApiResult<List<GlAccount>> compResult =
            await repos.getGlAccount(searchString: event.searchString);
        return emit(compResult.when(
            success: (data) => state.copyWith(
                  status: GlAccountStatus.success,
                  glAccounts: data,
                  hasReachedMax: data.length < _accntLimit ? true : false,
                  searchString: event.searchString,
                ),
            failure: (NetworkExceptions error) => state.copyWith(
                status: GlAccountStatus.failure, message: error.toString())));
      }
      // get next page also for search

      ApiResult<List<GlAccount>> compResult =
          await repos.getGlAccount(searchString: event.searchString);
      return emit(compResult.when(
          success: (data) => state.copyWith(
                status: GlAccountStatus.success,
                glAccounts: List.of(state.glAccounts)..addAll(data),
                hasReachedMax: data.length < _accntLimit ? true : false,
              ),
          failure: (NetworkExceptions error) => state.copyWith(
              status: GlAccountStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: GlAccountStatus.failure, message: error.toString()));
    }
  }
}
/*
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:core/domains/accounting/models/glAccount_model.dart';
import 'package:core/services/api_result.dart';
import 'package:core/services/network_exceptions.dart';
import 'package:equatable/equatable.dart';

class GlAccountBloc extends Bloc<GlAccountEvent, GlAccountState> {
  final repos;

  GlAccountBloc(this.repos) : super(GlAccountInitial());

  @override
  Stream<GlAccountState> mapEventToState(GlAccountEvent event) async* {
    if (event is FetchLedger) {
      yield GlAccountInProgress();
      ApiResult<List<GlAccount>> apiResult = await repos.getLedger();
      apiResult.when(success: (List<GlAccount> data) sync* {
        yield GlAccountSuccess(ledgerTree: data, message: "Ledger summary loaded");
      }, failure: (NetworkExceptions error) sync* {
        yield GlAccountProblem(error.toString());
      });
    }
  }
}

//--------------------------events ---------------------------------
abstract class GlAccountEvent extends Equatable {
  const GlAccountEvent();
  @override
  List<Object> get props => [];
}

class FetchBalanceSheet extends GlAccountEvent {}

class FetchLedger extends GlAccountEvent {}

// -------------------------------state ------------------------------
abstract class GlAccountState extends Equatable {
  const GlAccountState();

  @override
  List<Object?> get props => [];
}

class GlAccountInitial extends GlAccountState {}

class GlAccountInProgress extends GlAccountState {}

class GlAccountSuccess extends GlAccountState {
  final List<GlAccount>? ledgerTree;
  final String? message;

  GlAccountSuccess({this.message, this.ledgerTree});
  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'GlAccountLoad { $message }';
}

class GlAccountProblem extends GlAccountState {
  final String errorMessage;

  const GlAccountProblem(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];

  @override
  String toString() => 'GlAccountFailed { error: $errorMessage }';
}
*/
