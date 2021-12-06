part of 'category_bloc.dart';

enum CategoryStatus { initial, success, failure }

class CategoryState extends Equatable {
  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const <Category>[],
    this.message,
    this.hasReachedMax = false,
    this.searchString = '',
    this.search = false,
  });

  final CategoryStatus status;
  final String? message;
  final List<Category> categories;
  final bool hasReachedMax;
  final String searchString;
  final bool search;

  CategoryState copyWith({
    CategoryStatus? status,
    String? message,
    List<Category>? categories,
    bool error = false,
    bool? hasReachedMax,
    String? searchString,
    bool? search,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      message: message ?? this.message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchString: searchString ?? this.searchString,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [categories, hasReachedMax, search];

  @override
  String toString() => '$status { #categories: ${categories.length}, '
      'hasReachedMax: $hasReachedMax message $message}';
}
