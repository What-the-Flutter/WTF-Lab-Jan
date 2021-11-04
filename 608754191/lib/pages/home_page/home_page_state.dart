part of 'home_page_cubit.dart';

class HomePageState extends Equatable {
  final List<Category> categories;

  HomePageState([List<Category>? categories]) : categories = categories ?? [];

  HomePageState copyWith({
    List<Category>? categories,
  }) {
    return HomePageState(
      categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [categories];
}

class CategoryAddedSuccess extends HomePageState {
  final Category addedCategory;

  CategoryAddedSuccess(
    this.addedCategory,
    List<Category> categories,
  ) : super(categories);

  @override
  List<Object?> get props => [categories, addedCategory];
}

class CategoryDeleteSuccess extends HomePageState {
  final Category deletedCategory;

  CategoryDeleteSuccess(
    List<Category> categories,
    this.deletedCategory,
  ) : super(categories);

  @override
  List<Object> get props => [categories, deletedCategory];
}
