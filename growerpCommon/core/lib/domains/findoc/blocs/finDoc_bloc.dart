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
import 'package:core/domains/domains.dart';
import 'package:core/services/api_result.dart';
import 'package:core/services/network_exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:stream_transform/stream_transform.dart';

part 'finDoc_event.dart';
part 'finDoc_state.dart';

const _finDocLimit = 20;

mixin PurchaseInvoiceBloc on Bloc<FinDocEvent, FinDocState> {}
mixin SalesInvoiceBloc on Bloc<FinDocEvent, FinDocState> {}
mixin PurchasePaymentBloc on Bloc<FinDocEvent, FinDocState> {}
mixin SalesPaymentBloc on Bloc<FinDocEvent, FinDocState> {}
mixin PurchaseOrderBloc on Bloc<FinDocEvent, FinDocState> {}
mixin SalesOrderBloc on Bloc<FinDocEvent, FinDocState> {}
mixin OutgoingShipmentBloc on Bloc<FinDocEvent, FinDocState> {}
mixin IncomingShipmentBloc on Bloc<FinDocEvent, FinDocState> {}
mixin TransactionBloc on Bloc<FinDocEvent, FinDocState> {}

EventTransformer<E> finDocDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FinDocBloc extends Bloc<FinDocEvent, FinDocState>
    with
        PurchaseInvoiceBloc,
        SalesInvoiceBloc,
        PurchasePaymentBloc,
        SalesPaymentBloc,
        PurchaseOrderBloc,
        SalesOrderBloc,
        IncomingShipmentBloc,
        OutgoingShipmentBloc,
        TransactionBloc {
  FinDocBloc(this.repos, this.sales, this.docType)
      : super(const FinDocState()) {
    on<FinDocFetch>(_onFinDocFetch,
        transformer: finDocDroppable(Duration(milliseconds: 100)));
    on<FinDocSearchOn>(((event, emit) => emit(state.copyWith(search: true))));
    on<FinDocSearchOff>(((event, emit) => emit(state.copyWith(search: false))));
    on<FinDocUpdate>(_onFinDocUpdate);
    on<FinDocDelete>(_onFinDocDelete);
    on<FinDocShipmentReceive>(_onFinDocShipmentReceive);
  }

  final repos;
  final bool sales;
  final String docType;

  String classificationId = GlobalConfiguration().get("classificationId");

  Future<void> _onFinDocFetch(
    FinDocFetch event,
    Emitter<FinDocState> emit,
  ) async {
    if (state.hasReachedMax && !event.refresh && event.searchString.isEmpty)
      return;
    try {
      // start from record zero for initial and refresh
      if (state.status == FinDocStatus.initial || event.refresh) {
        ApiResult<List<FinDoc>> compResult = await repos.getFinDoc(
            sales: sales, docType: docType, searchString: event.searchString);
        return emit(compResult.when(
            success: (data) => state.copyWith(
                  status: FinDocStatus.success,
                  finDocs: data,
                  hasReachedMax: data.length < _finDocLimit ? true : false,
                  searchString: '',
                ),
            failure: (NetworkExceptions error) => state.copyWith(
                status: FinDocStatus.failure, message: error.toString())));
      }
      // get first search page also for changed search
      if (event.searchString.isNotEmpty && state.searchString.isEmpty ||
          (state.searchString.isNotEmpty &&
              event.searchString != state.searchString)) {
        ApiResult<List<FinDoc>> compResult = await repos.getFinDoc(
            sales: sales, docType: docType, searchString: event.searchString);
        return emit(compResult.when(
            success: (data) => state.copyWith(
                  status: FinDocStatus.success,
                  finDocs: data,
                  hasReachedMax: data.length < _finDocLimit ? true : false,
                  searchString: event.searchString,
                ),
            failure: (NetworkExceptions error) => state.copyWith(
                status: FinDocStatus.failure, message: error.toString())));
      }
      // get next page also for search

      ApiResult<List<FinDoc>> compResult = await repos.getFinDoc(
          sales: sales, docType: docType, searchString: event.searchString);
      return emit(compResult.when(
          success: (data) => state.copyWith(
                status: FinDocStatus.success,
                finDocs: List.of(state.finDocs)..addAll(data),
                hasReachedMax: data.length < _finDocLimit ? true : false,
              ),
          failure: (NetworkExceptions error) => state.copyWith(
              status: FinDocStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: FinDocStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onFinDocUpdate(
    FinDocUpdate event,
    Emitter<FinDocState> emit,
  ) async {
    try {
      List<FinDoc> finDocs = List.from(state.finDocs);
      if (event.finDoc.idIsNull()) {
        // create
        ApiResult<FinDoc> compResult = await repos.createFinDoc(
            event.finDoc.copyWith(classificationId: classificationId));
        return emit(compResult.when(
            success: (data) {
              finDocs.insert(0, data);
              return state.copyWith(
                  status: FinDocStatus.success, finDocs: finDocs);
            },
            failure: (NetworkExceptions error) => state.copyWith(
                status: FinDocStatus.failure, message: error.toString())));
      } else {
        // update
        ApiResult<FinDoc> compResult = await repos.updateFinDoc(
            event.finDoc.copyWith(classificationId: classificationId));
        return emit(compResult.when(
            success: (data) {
              late int index;
              switch (docType) {
                case 'order':
                  index = finDocs.indexWhere(
                      (element) => element.orderId == event.finDoc.orderId);
                  break;
                case 'payment':
                  index = finDocs.indexWhere(
                      (element) => element.paymentId == event.finDoc.paymentId);
                  break;
                case 'invoice':
                  index = finDocs.indexWhere(
                      (element) => element.invoiceId == event.finDoc.invoiceId);
                  break;
                case 'shipment':
                  index = finDocs.indexWhere((element) =>
                      element.shipmentId == event.finDoc.shipmentId);
                  break;
                case 'transaction':
                  index = finDocs.indexWhere((element) =>
                      element.transactionId == event.finDoc.transactionId);
                  break;
              }
              finDocs[index] = data;
              return state.copyWith(
                  status: FinDocStatus.success, finDocs: finDocs);
            },
            failure: (NetworkExceptions error) => state.copyWith(
                status: FinDocStatus.failure, message: error.toString())));
      }
    } catch (error) {
      emit(state.copyWith(
          status: FinDocStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onFinDocDelete(
    FinDocDelete event,
    Emitter<FinDocState> emit,
  ) async {
    try {
      List<FinDoc> finDocs = List.from(state.finDocs);
      ApiResult<FinDoc> compResult = await repos.deleteFinDoc(event.finDoc);
      return emit(compResult.when(
          success: (data) {
            int index =
                finDocs.indexWhere((element) => element.id == event.finDoc.id);
            finDocs.removeAt(index);
            return state.copyWith(
                status: FinDocStatus.success, finDocs: finDocs);
          },
          failure: (NetworkExceptions error) => state.copyWith(
              status: FinDocStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: FinDocStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onFinDocShipmentReceive(
    FinDocShipmentReceive event,
    Emitter<FinDocState> emit,
  ) async {
    try {
      ApiResult<FinDoc> shipResult = await repos.receiveShipment(event.finDoc);
      return emit(shipResult.when(
          success: (data) {
            List<FinDoc> finDocs = List.from(state.finDocs);
            int index = finDocs
                .indexWhere((element) => element.id() == event.finDoc.id());
            finDocs.removeAt(index);
            return state.copyWith(
                status: FinDocStatus.success, finDocs: finDocs);
          },
          failure: (NetworkExceptions error) => state.copyWith(
              status: FinDocStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: FinDocStatus.failure, message: error.toString()));
    }
  }
}
