part of 'home_page_cubit.dart';

class HomePageState {
  final List<Category> categories;

  const HomePageState({required this.categories});

  HomePageState copyWith({List<Category>? categories}) {
    return HomePageState(
      categories: categories ?? this.categories,
    );
  }
}
