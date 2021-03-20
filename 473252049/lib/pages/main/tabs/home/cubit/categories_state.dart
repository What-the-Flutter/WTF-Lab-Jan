part of 'categories_cubit.dart';

class CategoryWithLastRecord {
  Category category;
  Record lastRecord;

  CategoryWithLastRecord({
    @required this.category,
    @required this.lastRecord,
  });
}

abstract class CategoriesState extends Equatable {
  final List<CategoryWithLastRecord> categories;

  const CategoriesState(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoriesInitial extends CategoriesState {
  CategoriesInitial(List<CategoryWithLastRecord> categories)
      : super(categories);
}

class CategoriesLoadInProcess extends CategoriesState {
  CategoriesLoadInProcess(List<CategoryWithLastRecord> categories)
      : super(categories);
}

class CategoriesLoadSuccess extends CategoriesState {
  CategoriesLoadSuccess(List<CategoryWithLastRecord> categories)
      : super(categories);
}

class CategoryAddSuccess extends CategoriesState {
  final Category category;

  CategoryAddSuccess(
    List<CategoryWithLastRecord> categories,
    this.category,
  ) : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryDeleteSuccess extends CategoriesState {
  final Category category;

  CategoryDeleteSuccess(
    List<CategoryWithLastRecord> categories,
    this.category,
  ) : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryUpdateSuccess extends CategoriesState {
  final Category category;

  CategoryUpdateSuccess(List<CategoryWithLastRecord> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryChangePinSuccess extends CategoriesState {
  final Category category;

  CategoryChangePinSuccess(
      List<CategoryWithLastRecord> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}
