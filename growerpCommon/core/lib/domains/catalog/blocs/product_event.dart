part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object> get props => [];
}

class ProductFetch extends ProductEvent {
  const ProductFetch(
      {this.companyPartyId = '', this.searchString = '', this.refresh = false});
  final String companyPartyId;
  final String searchString;
  final bool refresh;
  @override
  List<Object> get props => [searchString, refresh];
}

class ProductSearchOn extends ProductEvent {}

class ProductSearchOff extends ProductEvent {}

class ProductDelete extends ProductEvent {
  const ProductDelete(this.product);
  final Product product;
}

class ProductUpdate extends ProductEvent {
  const ProductUpdate(this.product);
  final Product product;
}
