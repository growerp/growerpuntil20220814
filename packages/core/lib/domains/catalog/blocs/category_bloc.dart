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
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/domains/domains.dart';
import 'package:core/services/api_result.dart';
import 'package:core/services/network_exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:fast_csv/fast_csv.dart' as _fast_csv;

import '../../../api_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

const _categoryLimit = 20;

EventTransformer<E> categoryDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(this.repos) : super(const CategoryState()) {
    on<CategoryFetch>(_onCategoryFetch,
        transformer: categoryDroppable(Duration(milliseconds: 100)));
    on<CategoryUpdate>(_onCategoryUpdate);
    on<CategoryDelete>(_onCategoryDelete);
    on<CategoryUpload>(_onCategoryUpload);
    on<CategoryDownload>(_onCategoryDownload);
  }

  final APIRepository repos;

  Future<void> _onCategoryFetch(
    CategoryFetch event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.hasReachedMax &&
        event.refresh == false &&
        event.searchString.isEmpty) return;
    try {
      // start from record zero for initial and refresh
      emit(state.copyWith(status: CategoryStatus.loading));
      if (state.status == CategoryStatus.initial || event.refresh) {
        ApiResult<List<Category>> compResult = await repos.getCategory(
            companyPartyId: event.companyPartyId,
            searchString: event.searchString);
        return emit(compResult.when(
            success: (data) {
              return state.copyWith(
                status: CategoryStatus.success,
                categories: data,
                hasReachedMax: data.length < _categoryLimit ? true : false,
                searchString: '',
                message: event.refresh == true ? 'List refreshed....' : null,
              );
            },
            failure: (NetworkExceptions error) => state.copyWith(
                status: CategoryStatus.failure, message: error.toString())));
      }
      // get first search page also for changed search
      if (event.searchString.isNotEmpty && state.searchString.isEmpty ||
          (state.searchString.isNotEmpty &&
              event.searchString != state.searchString)) {
        ApiResult<List<Category>> compResult = await repos.getCategory(
            companyPartyId: event.companyPartyId,
            searchString: event.searchString);
        return emit(compResult.when(
            success: (data) => state.copyWith(
                  status: CategoryStatus.success,
                  categories: data,
                  hasReachedMax: data.length < _categoryLimit ? true : false,
                  searchString: event.searchString,
                ),
            failure: (NetworkExceptions error) => state.copyWith(
                status: CategoryStatus.failure, message: error.toString())));
      }
      // get next page also for search

      ApiResult<List<Category>> compResult = await repos.getCategory(
          companyPartyId: event.companyPartyId,
          searchString: event.searchString);
      return emit(compResult.when(
          success: (data) => state.copyWith(
                status: CategoryStatus.success,
                categories: List.of(state.categories)..addAll(data),
                hasReachedMax: data.length < _categoryLimit ? true : false,
              ),
          failure: (NetworkExceptions error) => state.copyWith(
              status: CategoryStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: CategoryStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onCategoryUpdate(
    CategoryUpdate event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CategoryStatus.loading));
      List<Category> categories = List.from(state.categories);
      if (event.category.categoryId.isNotEmpty) {
        ApiResult<Category> compResult =
            await repos.updateCategory(event.category);
        return emit(compResult.when(
            success: (data) {
              int index = categories.indexWhere(
                  (element) => element.categoryId == event.category.categoryId);
              categories[index] = data;
              return state.copyWith(
                  status: CategoryStatus.success,
                  categories: categories,
                  message: 'Category ${event.category.categoryName} updated!');
            },
            failure: (NetworkExceptions error) => state.copyWith(
                status: CategoryStatus.failure, message: error.toString())));
      } else {
        // add
        ApiResult<Category> compResult =
            await repos.createCategory(event.category);
        return emit(compResult.when(
            success: (data) {
              categories.insert(0, data);
              return state.copyWith(
                  status: CategoryStatus.success,
                  categories: categories,
                  message: 'Category ${event.category.categoryName} added!');
            },
            failure: (NetworkExceptions error) => state.copyWith(
                status: CategoryStatus.failure, message: error.toString())));
      }
    } catch (error) {
      emit(state.copyWith(
          status: CategoryStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onCategoryDelete(
    CategoryDelete event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CategoryStatus.loading));
      List<Category> categories = List.from(state.categories);
      ApiResult<Category> compResult =
          await repos.deleteCategory(event.category);
      return emit(compResult.when(
          success: (data) {
            int index = categories.indexWhere(
                (element) => element.categoryId == event.category.categoryId);
            categories.removeAt(index);
            return state.copyWith(
                status: CategoryStatus.success,
                categories: categories,
                message: 'Category ${event.category.categoryName} deleted!');
          },
          failure: (NetworkExceptions error) => state.copyWith(
              status: CategoryStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: CategoryStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onCategoryUpload(
    CategoryUpload event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CategoryStatus.loading));
      List<Category> categories = [];
      final result = _fast_csv.parse(await event.file.readAsString());
      int line = 0;
      // import csv into categories
      for (final row in result) {
        if (line++ < 2) continue;
        if (row.length > 1) {
          ;
          categories.add(Category(
              categoryName: row[0],
              description: row[1],
              image: Base64Decoder().convert(row[2])));
        }
      }
      ApiResult<String> compResult = await repos.importCategories(categories);
      return emit(compResult.when(
          success: (data) {
            return state.copyWith(
                status: CategoryStatus.success,
                categories: state.categories,
                message: data);
          },
          failure: (NetworkExceptions error) => state.copyWith(
              status: CategoryStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: CategoryStatus.failure, message: error.toString()));
    }
  }

  Future<void> _onCategoryDownload(
    CategoryDownload event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CategoryStatus.loading));
      ApiResult<String> compResult = await repos.exportCategories();
      return emit(compResult.when(
          success: (data) {
            return state.copyWith(
                status: CategoryStatus.success,
                categories: state.categories,
                message:
                    "The request is scheduled and the email be be sent shortly");
          },
          failure: (NetworkExceptions error) => state.copyWith(
              status: CategoryStatus.failure, message: error.toString())));
    } catch (error) {
      emit(state.copyWith(
          status: CategoryStatus.failure, message: error.toString()));
    }
  }
}
