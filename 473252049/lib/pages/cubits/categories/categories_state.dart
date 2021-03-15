part of 'categories_cubit.dart';

abstract class CategoriesState extends Equatable {
  final List<Category> categories;

  const CategoriesState(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoriesInitial extends CategoriesState {
  CategoriesInitial(List<Category> categories) : super(categories);
}

class CategoriesLoadInProcess extends CategoriesState {
  CategoriesLoadInProcess(List<Category> categories) : super(categories);
}

class CategoriesLoadSuccess extends CategoriesState {
  CategoriesLoadSuccess(List<Category> categories) : super(categories);
}

class CategoryAddSuccess extends CategoriesState {
  final Category category;

  CategoryAddSuccess(
    List<Category> categories,
    this.category,
  ) : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryDeleteSuccess extends CategoriesState {
  final Category category;

  CategoryDeleteSuccess(
    List<Category> categories,
    this.category,
  ) : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryUpdateSuccess extends CategoriesState {
  final Category category;

  CategoryUpdateSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryChangePinSuccess extends CategoriesState {
  final Category category;

  CategoryChangePinSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}
