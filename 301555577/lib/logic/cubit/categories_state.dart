part of 'categories_cubit.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial() : super();

  @override
  List<Object?> get props => [];
}

class CategoriesFetchingState extends CategoriesState {
  const CategoriesFetchingState();

  @override
  List<Object?> get props => [];
}

class CategoriesFetchingError extends CategoriesState {
  final String message;
  const CategoriesFetchingError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CategoriesFetchedState extends CategoriesState {
  final List<Category> categories;
  final bool error;

  const CategoriesFetchedState(this.categories, {this.error = false});

  @override
  List<Object?> get props => [categories, error];
}
