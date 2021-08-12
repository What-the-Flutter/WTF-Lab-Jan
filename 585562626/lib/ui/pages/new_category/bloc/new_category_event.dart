import 'package:equatable/equatable.dart';

import '../../../../models/category.dart';

abstract class NewCategoryEvent extends Equatable {
  const NewCategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchDefaultCategoriesEvent extends NewCategoryEvent {
  final NoteCategory? editCategory;

  const FetchDefaultCategoriesEvent({this.editCategory});

  @override
  List<Object?> get props => [editCategory];
}

class NameChangedEvent extends NewCategoryEvent {
  final String name;

  NameChangedEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class CategoryChanged extends NewCategoryEvent {
  final NoteCategory category;

  CategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class NewCategorySubmitted extends NewCategoryEvent {
  const NewCategorySubmitted();
}
