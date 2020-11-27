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
import '@blocs.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final repos;
  final AuthBloc authBloc;
  StreamSubscription authBlocSubscription;
  Catalog catalog;
  Authenticate authenticate;

  CatalogBloc(this.repos, this.authBloc) : super(CatalogInitial()) {
    authBlocSubscription = authBloc.listen((state) {
      print("====listening to authbloc in catalog bloc: state: $state");
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      if (state is AuthUnauthenticated) authenticate = state.authenticate;
      if (authenticate != null) add(LoadCatalog());
    });
  }
  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }

  @override
  Stream<CatalogState> mapEventToState(CatalogEvent event) async* {
    if (event is LoadCatalog) {
      yield CatalogLoading();
      String companyPartyId = authenticate?.company?.partyId;
      print("===catalog, authenticate: $authenticate");
      dynamic result = await repos.getCatalog(companyPartyId);
      if (result is Catalog)
        yield CatalogLoaded(catalog: result);
      else
        yield CatalogProblem(errorMessage: result);
    } else if (event is UpdateProduct) {
      yield CatalogLoading(
          (event.product?.productId == null ? "Adding " : "Updating") +
              " product ${event.product}");
      dynamic result =
          await repos.updateProduct(event.product, event.imagePath);
      if (result is Product) {
        if (event.product?.productId == null)
          event.catalog.products?.add(event.product);
        else {
          int index = event.catalog.products
              .indexWhere((prod) => prod.productId == result.productId);
          event.catalog.products.replaceRange(index, index + 1, [result]);
        }
        yield CatalogLoaded(
            catalog: event.catalog,
            message: event.product.productId == null
                ? 'Product added'
                : 'Product updated');
      } else {
        yield CatalogProblem(newProduct: event.product, errorMessage: result);
      }
    } else if (event is DeleteProduct) {
      yield CatalogLoading("Deleting product ${event.product.productId}");
      dynamic result = await repos.deleteProduct(event.product.productId);
      if (result == event.product.productId) {
        List categories = event.catalog.categories;
        int index = categories.indexWhere((cat) => cat.productId == result);
        categories.removeAt(index);
        yield CatalogLoaded(
            catalog: event.catalog,
            message: 'Product ${event.product} deleted');
      }
    } else if (event is UpdateCategory) {
      yield CatalogLoading(
          "${(event.category?.categoryId == null ? 'Adding' : 'Updating')}"
          " category ${event.category}");
      dynamic result =
          await repos.updateCategory(event.category, event.imagePath);
      if (result is ProductCategory) {
        if (event.category?.categoryId == null) {
          event.catalog.categories.add(event.category);
        } else {
          int index = event.catalog.categories
              .indexWhere((cat) => cat.categoryId == result.categoryId);
          event.catalog.categories.replaceRange(index, index + 1, [result]);
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
  final Product product;
  DeleteProduct(this.catalog, this.product);
  @override
  String toString() => "DeleteProduct: $product in $catalog";
}

class UpdateProduct extends CatalogEvent {
  final Catalog catalog;
  final Product product;
  final String imagePath;
  UpdateProduct(this.catalog, this.product, this.imagePath);
  @override
  String toString() => "UpdateProduct: $product in $catalog";
}

class DeleteCategory extends CatalogEvent {
  final Catalog catalog;
  final ProductCategory category;
  DeleteCategory(this.catalog, this.category);
  @override
  String toString() => "DeleteCategory: $category in $catalog";
}

class UpdateCategory extends CatalogEvent {
  final Catalog catalog;
  final ProductCategory category;
  final String imagePath;
  UpdateCategory(this.catalog, this.category, this.imagePath);
  @override
  String toString() => "UpdateCategory: $category in $catalog";
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
  final Product newProduct;
  final ProductCategory newCategory;

  const CatalogProblem({this.errorMessage, this.newProduct, this.newCategory});

  @override
  String toString() => 'CatalogProblem { error: $errorMessage }';
}
