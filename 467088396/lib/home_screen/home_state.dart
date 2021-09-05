import '../models/category.dart';

class HomeState {
  final List<Category> categoryList;
  //Category? category;
  int? index;

  HomeState({
    this.categoryList = const [],
    this.index = 0,
  });

  HomeState copyWith({
    List<Category>? categoryList,
    Category? category,
    int? index,
  }) {
    return HomeState(
      categoryList: categoryList ?? this.categoryList,
      //category: category ?? this.category,
      index: index ?? this.index,
    );
  }
}
