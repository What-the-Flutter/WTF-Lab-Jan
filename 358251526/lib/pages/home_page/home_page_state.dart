part of 'home_page_cubit.dart';

class HomePageState {
  final List<Category> categoriesList;

  const HomePageState({required this.categoriesList});

  HomePageState copyWith({List<Category>? categoriesList}) {
    return HomePageState(
      categoriesList: categoriesList ?? this.categoriesList,
    );
  }
}
