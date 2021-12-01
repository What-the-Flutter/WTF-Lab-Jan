part of 'home_cubit.dart';

class HomeState {
  List<Category> categories;
  int? index;

  HomeState({
    this.categories = const [],
    this.index = 0,
  });

  // CopyWith Then copyWith method comes handy. This method takes all the properties(which need to change) and their corresponding values and returns new object with your desired properties.
  HomeState copyWith({
    List<Category>? categories,
    Category? category,
    int? index,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      index: index ?? this.index,
    );
  }
}
