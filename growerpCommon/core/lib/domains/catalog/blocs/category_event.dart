part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object> get props => [];
}

class CategoryFetch extends CategoryEvent {
  const CategoryFetch({this.searchString = '', this.refresh = false});
  final String searchString;
  final bool refresh;
  @override
  List<Object> get props => [searchString, refresh];
}

class CategorySearchOn extends CategoryEvent {}

class CategorySearchOff extends CategoryEvent {}

class CategoryDelete extends CategoryEvent {
  const CategoryDelete(this.category);
  final Category category;
}

class CategoryUpdate extends CategoryEvent {
  const CategoryUpdate(this.category);
  final Category category;
}
