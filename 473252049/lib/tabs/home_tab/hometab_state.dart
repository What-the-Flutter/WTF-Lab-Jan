part of 'hometab_cubit.dart';

abstract class HometabState extends Equatable {
  final List<Category> categories;

  const HometabState(this.categories);

  @override
  List<Object> get props => [categories];
}

class HometabInitial extends HometabState {
  HometabInitial(List categories) : super(categories);
}

class CategoryPinSuccess extends HometabState {
  final Category category;

  CategoryPinSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryUnpinSuccess extends HometabState {
  final Category category;

  CategoryUnpinSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryUpdateSuccess extends HometabState {
  final Category category;

  CategoryUpdateSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryDeleteSuccess extends HometabState {
  final Category category;

  CategoryDeleteSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryAddSuccess extends HometabState {
  final Category category;

  CategoryAddSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoriesSortSuccess extends HometabState {
  CategoriesSortSuccess(List<Category> categories) : super(categories);

  @override
  List<Object> get props => [categories];
}
