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
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../models/@models.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final repos;

  CatalogBloc({@required this.repos}) : super(CatalogInitial());

  @override
  Stream<CatalogState> mapEventToState(CatalogEvent event) async* {
    if (event is LoadCatalog) {
      yield CatalogLoading();
      dynamic authenticate = await repos.getAuthenticate();
      String companyPartyId = authenticate?.company?.partyId;
      dynamic result = await repos.getCatalog(companyPartyId);
      print("===cat loaded: $result");
      if (result is Catalog)
        yield CatalogLoaded(catalog: result);
      else
        yield CatalogProblem(errorMessage: result);
    } else if (event is UpdateCategory) {
      yield CatalogLoading(
          (event.category?.categoryId == null ? "Adding " : "Updating") +
              " category ${event.category}");
      dynamic result =
          await repos.updateCategory(event.category, event.imagePath);
      if (result is ProductCategory) {
        if (event.category?.categoryId == null)
          event.catalog.categories.add(event.category);
        else {
          int index = event.catalog.categories
              .indexWhere((cat) => cat.categoryId == result.categoryId);
          event.catalog.categories.replaceRange(index, index + 1, [result]);
          await repos.persistAuthenticate(event.catalog);
        }
        yield CatalogLoaded(
            catalog: event.catalog,
            message: event.category.categoryId == null
                ? 'Category added'
                : 'Category updated');
      } else {
        yield CatalogProblem(newCategory: event.category, errorMessage: result);
      }
    } else if (event is DeleteCategory) {
      yield CatalogLoading("Deleting category ${event.category}");
      dynamic result = await repos.deleteCategory(event.category.categoryId);
      if (result == event.category.categoryId) {
        List categories = event.catalog.categories;
        int index = categories.indexWhere((cat) => cat.categoryId == result);
        categories.removeAt(index);
        yield CatalogLoaded(
            catalog: event.catalog,
            message: 'Category ${event.category} deleted');
      }
    }
  }
}

// ################# events ###################
@immutable
abstract class CatalogEvent extends Equatable {
  const CatalogEvent();
  @override
  List<Object> get props => [];
}

class LoadCatalog extends CatalogEvent {
  String toString() => "Loadcatalog: loading products and categories";
}

class DeleteProduct extends CatalogEvent {
  final Catalog catalog;
  final String productId;
  DeleteProduct(this.catalog, this.productId);
  @override
  String toString() => "DeleteProduct: delete product";
}

class UpdateProduct extends CatalogEvent {
  final Catalog catalog;
  final Product product;
  final String imagePath;
  UpdateProduct(this.catalog, this.product, this.imagePath);
  @override
  String toString() => "DeleteProduct: delete product";
}

class DeleteCategory extends CatalogEvent {
  final Catalog catalog;
  final ProductCategory category;
  DeleteCategory(this.catalog, this.category);
  @override
  String toString() => "DeleteCategory: $category";
}

class UpdateCategory extends CatalogEvent {
  final Catalog catalog;
  final ProductCategory category;
  final String imagePath;
  UpdateCategory(this.catalog, this.category, this.imagePath);
  @override
  String toString() => "UpdateCategory: $category";
}

// ################## state ###################
@immutable
abstract class CatalogState extends Equatable {
  const CatalogState();
  @override
  List<Object> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {
  final String message;
  CatalogLoading([this.message]);
  String toString() => 'CatalogLoading msg: $message';
}

class CatalogLoaded extends CatalogState {
  final Catalog catalog;
  final ProductCategory category;
  final Product product;
  final String message;
  const CatalogLoaded(
      {this.catalog, this.category, this.product, this.message});

  @override
  List<Object> get props => [catalog];
  @override
  String toString() => 'CatalogLoaded: catalog: $catalog';
}

class CatalogProblem extends CatalogState {
  final String errorMessage;
  final Product newproduct;
  final ProductCategory newCategory;

  const CatalogProblem({this.errorMessage, this.newproduct, this.newCategory});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'CatalogProblem { error: $errorMessage }';
}
