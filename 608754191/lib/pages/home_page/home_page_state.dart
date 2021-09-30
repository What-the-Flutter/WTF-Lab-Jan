part of 'home_page_cubit.dart';

class HomePageState extends Equatable {
  final List<Category> categories;

  const HomePageState({required this.categories});

  HomePageState copyWith({List<Category>? categories, Category? category}) {
    return HomePageState(categories: categories ?? this.categories);
  }

  @override
  List<Object?> get props => [categories];
}
