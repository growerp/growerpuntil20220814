part of 'product_bloc.dart';

enum ProductStatus { initial, success, failure }

class ProductState extends Equatable {
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const <Product>[],
    this.message,
    this.hasReachedMax = false,
    this.searchString = '',
    this.search = false,
  });

  final ProductStatus status;
  final String? message;
  final List<Product> products;
  final bool hasReachedMax;
  final String searchString;
  final bool search;

  ProductState copyWith({
    ProductStatus? status,
    String? message,
    List<Product>? products,
    bool error = false,
    bool? hasReachedMax,
    String? searchString,
    bool? search,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message ?? this.message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchString: searchString ?? this.searchString,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [products, hasReachedMax, search];

  @override
  String toString() => '$status { #products: ${products.length}, '
      'hasReachedMax: $hasReachedMax message $message}';
}
