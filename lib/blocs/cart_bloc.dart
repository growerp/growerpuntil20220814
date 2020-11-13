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
import 'package:meta/meta.dart';
import '../models/@models.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final repos;
  Authenticate authenticate;

  CartBloc(this.repos) : super(CartInitial());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is LoadCart) {
      yield* _mapLoadCartToState();
    } else if (event is AddOrderItem) {
      yield* _mapAddOrderItemToState(event);
    } else if (event is PayOrder) {
      yield CartPaying();
      dynamic result = await repos.createOrder(event.order);
      if (result is String && result.startsWith('orderId')) {
        yield CartPaid(orderId: result.substring(7));
        repos.saveCart(order: null);
        yield* _mapLoadCartToState();
      } else
        yield CartError(message: result);
    }
  }

  Stream<CartState> _mapLoadCartToState() async* {
    yield CartLoading();
    dynamic order = await repos.getCart();
    if (order is String) {
      yield CartError(message: order);
    } else {
      if (order == null) {
        Authenticate authenticate = await repos.getAuthenticate();
        order = Order(
          orderStatusId: "OrderOpen",
          partyId: authenticate?.user?.partyId,
          firstName: authenticate?.user?.firstName,
          lastName: authenticate?.user?.lastName,
          statusId: "Open",
          currencyId: authenticate?.company?.currencyId,
          companyPartyId: authenticate?.company?.partyId,
          orderItems: [],
        );
      }
      yield CartLoaded(order);
    }
  }

  Stream<CartState> _mapAddOrderItemToState(AddOrderItem event) async* {
    final currentState = state;
    if (currentState is CartLoaded) {
      currentState.order.orderItems.add(event.orderItem);
      dynamic result = await repos.saveCart(order: currentState.order);
      if (result is String)
        yield CartError(message: result);
      else
        yield CartLoaded(currentState.order);
    }
  }
}

// ===================events =====================
@immutable
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddOrderItem extends CartEvent {
  final OrderItem orderItem;
  const AddOrderItem(this.orderItem);
  @override
  List<Object> get props => [orderItem];
}

class PayOrder extends CartEvent {
  final Order order;
  PayOrder(this.order);
  @override
  List<Object> get props => [order.lastName];
}

// ================= state ========================
@immutable
abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Order order;
  const CartLoaded(this.order);
  Decimal get totalPrice {
    if (order?.orderItems?.length == 0) return Decimal.parse('0');
    Decimal total = Decimal.parse('0');
    if (order != null)
      for (OrderItem i in order?.orderItems)
        total += (i.price * Decimal.parse(i.quantity.toString()));
    return total;
  }

  @override
  List<Object> get props => [order];
  @override
  String toString() =>
      'Cart loaded, products: ' +
      '${order?.orderItems?.length} value: $totalPrice';
}

class CartPaying extends CartState {}

class CartPaid extends CartState {
  final String orderId;
  const CartPaid({this.orderId});
  List<Object> get props => [orderId];
  String toString() => 'Cart Paid, orderId : $orderId';
}

class CartError extends CartState {
  final message;
  const CartError({this.message});
  @override
  List<Object> get props => [message];
}
