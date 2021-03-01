part of 'homepage_bloc.dart';

abstract class HomepageEvent extends Equatable {
  const HomepageEvent();

  @override
  List<Object> get props => [];
}

class CategorySelected extends HomepageEvent {
  final Category category;

  CategorySelected(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryUnselected extends HomepageEvent {
  final Category category;

  CategoryUnselected(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryPinned extends HomepageEvent {
  final Category category;

  CategoryPinned(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryUnpinned extends HomepageEvent {
  final Category category;

  CategoryUnpinned(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryPinChanged extends HomepageEvent {
  final Category category;

  CategoryPinChanged(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryUpdateStarted extends HomepageEvent {
  final Category category;

  CategoryUpdateStarted(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryUpdateCancelled extends HomepageEvent {}

class CategoryUpdated extends HomepageEvent {
  final Category category;
  final IconData newIconData;
  final String newName;

  CategoryUpdated(this.category,
      {@required this.newIconData, @required this.newName});

  @override
  List<Object> get props => [category, newIconData, newName];
}

class CategoryDeleteStarted extends HomepageEvent {
  final Category category;

  CategoryDeleteStarted(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryDeleteCancelled extends HomepageEvent {}

class CategoryDeleted extends HomepageEvent {
  final Category category;

  CategoryDeleted(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryAddStarted extends HomepageEvent {}

class CategoryAddCancelled extends HomepageEvent {}

class CategoryAdded extends HomepageEvent {
  final Category category;

  CategoryAdded(this.category);

  @override
  List<Object> get props => [category];
}

class CategoriesSorted extends HomepageEvent {}
