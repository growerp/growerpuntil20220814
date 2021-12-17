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
import 'package:decimal/decimal.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domains.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';

mixin PurchaseCartBloc on Bloc<CartEvent, CartState> {}
mixin SalesCartBloc on Bloc<CartEvent, CartState> {}

class CartBloc extends Bloc<CartEvent, CartState>
    with PurchaseCartBloc, SalesCartBloc {
  CartBloc(
      {required this.sales, required this.docType, required this.finDocBloc})
      : super(CartState(
            finDoc: FinDoc(sales: sales, docType: docType, items: []))) {
    on<CartFetch>(_onCartFetch);
    on<CartCreateFinDoc>(_onCartCreateFinDoc);
    on<CartCancelFinDoc>(_onCartCancelFinDoc);
    on<CartHeader>(_onCartHeader);
    on<CartAdd>(_onCartAdd);
    on<CartDeleteItem>(_onCartDeleteItem);
    on<CartClear>(_onCartClear);
  }

  final bool sales;
  final FinDocType docType;
  final FinDocBloc finDocBloc;
  late FinDoc finDoc;

  Future<void> _onCartFetch(
    CartFetch event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state.status == CartStatus.initial) {
        finDoc = event.finDoc;
        if (event.finDoc.idIsNull()) {
          FinDoc? result =
              await getCart(event.finDoc.sales, event.finDoc.docType!);
          if (result != null) finDoc = result;
        }
        emit(
          state.copyWith(
            status: CartStatus.inProcess,
            finDoc: finDoc,
          ),
        );
      }
    } catch (error) {
      emit(state.copyWith(
          status: CartStatus.failure, message: error.toString()));
    }
  }

  // store findoc in database
  Future<void> _onCartCreateFinDoc(
    CartCreateFinDoc event,
    Emitter<CartState> emit,
  ) async {
    try {
      state.copyWith(status: CartStatus.saving);
      finDocBloc.add(FinDocUpdate(event.finDoc));
      add(CartClear());
      return emit(
        state.copyWith(
          status: CartStatus.complete,
          finDoc: FinDoc(docType: docType, sales: sales, items: []),
        ),
      );
    } catch (error) {
      emit(state.copyWith(
          status: CartStatus.failure, message: error.toString()));
    }
  }

  // cancel findoc in database
  Future<void> _onCartCancelFinDoc(
    CartCancelFinDoc event,
    Emitter<CartState> emit,
  ) async {
    try {
      finDocBloc.add(
          FinDocUpdate(event.finDoc.copyWith(statusId: 'FinDocCancelled')));
      add(CartClear());
      return emit(
        state.copyWith(
          status: CartStatus.complete,
          finDoc: FinDoc(docType: docType, sales: sales),
        ),
      );
    } catch (error) {
      emit(state.copyWith(
          status: CartStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onCartHeader(
    CartHeader event,
    Emitter<CartState> emit,
  ) async {
    try {
      await saveCart(event.finDoc);
      return emit(
        state.copyWith(
          status: CartStatus.inProcess,
          finDoc: event.finDoc,
        ),
      );
    } catch (error) {
      emit(state.copyWith(
          status: CartStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onCartAdd(
    CartAdd event,
    Emitter<CartState> emit,
  ) async {
    try {
      List<FinDocItem> items = List.from(finDoc.items);
      items.add(event.newItem
          .copyWith(itemSeqId: (finDoc.items.length + 1).toString()));
      Decimal grandTotal = Decimal.parse('0');
      finDoc.items.forEach((x) {
        grandTotal += x.quantity! * x.price!;
      });
      finDoc = event.finDoc.copyWith(
          otherUser: event.finDoc.otherUser,
          description: event.finDoc.description,
          items: items,
          grandTotal: grandTotal);
      await saveCart(finDoc);
      emit(
        state.copyWith(
          status: CartStatus.inProcess,
          finDoc: finDoc,
        ),
      );
    } catch (error) {
      emit(state.copyWith(
          status: CartStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onCartDeleteItem(
    CartDeleteItem event,
    Emitter<CartState> emit,
  ) async {
    try {
      finDoc.items.removeAt(event.index);
      Decimal grandTotal = Decimal.parse('0');
      int i = 0;
      finDoc.items.forEach((x) {
        finDoc.items[i] =
            finDoc.items[i].copyWith(itemSeqId: (1 + i++).toString());
        grandTotal += x.quantity! * x.price!;
      });
      finDoc = finDoc.copyWith(grandTotal: grandTotal);
      await saveCart(finDoc);
      emit(
        state.copyWith(
          status: CartStatus.inProcess,
          finDoc: finDoc,
        ),
      );
    } catch (error) {
      emit(state.copyWith(
          status: CartStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onCartClear(
    CartClear event,
    Emitter<CartState> emit,
  ) async {
    try {
      finDoc = FinDoc(sales: sales, docType: docType, items: []);
      await clearSavedCart(finDoc);
      return emit(
        state.copyWith(
          status: CartStatus.inProcess,
          finDoc: finDoc,
        ),
      );
    } catch (error) {
      emit(state.copyWith(
          status: CartStatus.failure, message: error.toString()));
    }
  }

  Future<void> saveCart(FinDoc finDoc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "${finDoc.sales.toString}${finDoc.docType}", finDocToJson(finDoc));
  }

  Future<void> clearSavedCart(FinDoc finDoc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("${finDoc.sales.toString}${finDoc.docType}");
  }

  Future<FinDoc?> getCart(bool sales, FinDocType docType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartContent = prefs.getString("${sales.toString}$docType");
    if (cartContent != null) return finDocFromJson(cartContent.toString());
    return null;
  }
}
