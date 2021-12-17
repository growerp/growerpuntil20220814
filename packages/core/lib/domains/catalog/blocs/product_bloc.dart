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
import 'package:stream_transform/stream_transform.dart';

import '../../../api_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

const _productLimit = 20;

EventTransformer<E> productDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this.repos) : super(const ProductState()) {
    on<ProductFetch>(_onProductFetch,
        transformer: productDroppable(Duration(milliseconds: 100)));
    on<ProductSearchOn>(((event, emit) => emit(state.copyWith(search: true))));
    on<ProductSearchOff>(
        ((event, emit) => emit(state.copyWith(search: false))));
    on<ProductUpdate>(_onProductUpdate);
    on<ProductDelete>(_onProductDelete);
  }

  final APIRepository repos;

  Future<void> _onProductFetch(
    ProductFetch event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax && !event.refresh && event.searchString.isEmpty)
      return;
    try {
      // start from record zero for initial and refresh
      if (state.status == ProductStatus.initial || event.refresh) {
        ApiResult<List<Product>> compResult =
            await repos.getProduct(searchString: event.searchString);
        return emit(compResult.when(
            success: (data) => state.copyWith(
                  status: ProductStatus.success,
                  products: data,
                  hasReachedMax: data.length < _productLimit ? true : false,
                  searchString: '',
                ),
            failure: (NetworkExceptions error) => state.copyWith(
                status: ProductStatus.failure, message: error.toString())));
      }
      // get first search page also for changed search
      if (event.searchString.isNotEmpty && state.searchString.isEmpty ||
          (state.searchString.isNotEmpty &&
              event.searchString != state.searchString)) {
        ApiResult<List<Product>> compResult =
            await repos.getProduct(searchString: event.searchString);
        return emit(compResult.when(
            success: (data) => state.copyWith(
                  status: ProductStatus.success,
                  products: data,
                  hasReachedMax: data.length < _productLimit ? true : false,
                  searchString: event.searchString,
                ),
            failure: (NetworkExceptions error) => state.copyWith(
                status: ProductStatus.failure, message: error.toString())));
      }
      // get next page also for search

      ApiResult<List<Product>> compResult =
          await repos.getProduct(searchString: event.searchString);
      return emit(compResult.when(
          success: (data) => state.copyWith(
                status: ProductStatus.success,
                products: List.of(state.products)..addAll(data),
                hasReachedMax: data.length < _productLimit ? true : false,
              ),
          failure: (NetworkExceptions error) => state.copyWith(
              status: ProductStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: ProductStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onProductUpdate(
    ProductUpdate event,
    Emitter<ProductState> emit,
  ) async {
    try {
      List<Product> products = List.from(state.products);
      if (event.product.productId.isNotEmpty) {
        ApiResult<Product> compResult =
            await repos.updateProduct(event.product);
        return emit(compResult.when(
            success: (data) {
              int index = products.indexWhere(
                  (element) => element.productId == event.product.productId);
              products[index] = data;
              return state.copyWith(
                  status: ProductStatus.success, products: products);
            },
            failure: (NetworkExceptions error) => state.copyWith(
                status: ProductStatus.failure, message: error.toString())));
      } else {
        // add
        ApiResult<Product> compResult =
            await repos.createProduct(event.product);
        return emit(compResult.when(
            success: (data) {
              products.insert(0, data);
              return state.copyWith(
                  status: ProductStatus.success, products: products);
            },
            failure: (NetworkExceptions error) => state.copyWith(
                status: ProductStatus.failure, message: error.toString())));
      }
    } catch (error) {
      emit(state.copyWith(
          status: ProductStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onProductDelete(
    ProductDelete event,
    Emitter<ProductState> emit,
  ) async {
    try {
      List<Product> products = List.from(state.products);
      ApiResult<Product> compResult = await repos.deleteProduct(event.product);
      return emit(compResult.when(
          success: (data) {
            int index = products.indexWhere(
                (element) => element.productId == event.product.productId);
            products.removeAt(index);
            return state.copyWith(
                status: ProductStatus.success, products: products);
          },
          failure: (NetworkExceptions error) => state.copyWith(
              status: ProductStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: ProductStatus.failure, message: error.toString()));
    }
  }
}
