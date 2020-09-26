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
      dynamic catalog;
      dynamic authenticate = await repos.getAuthenticate();
      String companyPartyId = authenticate?.company?.partyId;
      catalog = await repos.getCatalog(companyPartyId);
      if (catalog is Catalog)
        yield CatalogLoaded(catalog);
      else
        yield CatalogError(catalog);
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

// ################## state ###################
@immutable
abstract class CatalogState extends Equatable {
  const CatalogState();
  @override
  List<Object> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final Catalog catalog;

  const CatalogLoaded(this.catalog);

  @override
  List<Object> get props => [catalog];
  @override
  String toString() =>
      'CatalogLoaded, categories: ${catalog.categories.length}' +
      ' products: ${catalog.products.length}';
}

class CatalogError extends CatalogState {
  final String errorMessage;

  const CatalogError(this.errorMessage);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'CatalogError { error: $errorMessage }';
}
