part of 'homepage_bloc.dart';

abstract class HomepageState extends Equatable {
  final List<Category> categories;

  const HomepageState(this.categories);

  @override
  List<Object> get props => [categories];
}

class HomepageInitial extends HomepageState {
  HomepageInitial(List<Category> categories) : super(categories);
}

class CategorySelectSuccess extends HomepageState {
  final Category category;
  CategorySelectSuccess(List<Category> categories, this.category)
      : super(categories);
}

class CategoryUnselectSuccess extends HomepageState {
  CategoryUnselectSuccess(List<Category> categories) : super(categories);
}

class CategoryPinSuccess extends HomepageState {
  CategoryPinSuccess(List<Category> categories) : super(categories);
}

class CategoryUnpinSuccess extends HomepageState {
  CategoryUnpinSuccess(List<Category> categories) : super(categories);
}

class CategoryUpdateInProcess extends HomepageState {
  final Category category;

  CategoryUpdateInProcess(List<Category> categories, this.category)
      : super(categories);
}

class CategoryUpdateCancelSuccess extends HomepageState {
  CategoryUpdateCancelSuccess(List<Category> categories) : super(categories);
}

class CategoryUpdateSuccess extends HomepageState {
  CategoryUpdateSuccess(List<Category> categories) : super(categories);
}

class CategoryDeleteInProcess extends HomepageState {
  final Category category;

  CategoryDeleteInProcess(List<Category> categories, this.category)
      : super(categories);
}

class CategoryDeleteCancelSuccess extends HomepageState {
  CategoryDeleteCancelSuccess(List<Category> categories) : super(categories);
}

class CategoryDeleteSuccess extends HomepageState {
  CategoryDeleteSuccess(List<Category> categories) : super(categories);
}

class CategoryAddInProcess extends HomepageState {
  CategoryAddInProcess(List<Category> categories) : super(categories);
}

class CategoryAddCancelSuccess extends HomepageState {
  CategoryAddCancelSuccess(List<Category> categories) : super(categories);
}

class CategoryAddSuccess extends HomepageState {
  CategoryAddSuccess(List<Category> categories) : super(categories);
}

class CategoriesSortSuccess extends HomepageState {
  CategoriesSortSuccess(List<Category> categories) : super(categories);
}
