import 'package:equatable/equatable.dart';

import '../../../../models/category.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class FetchCategoriesEvent extends CategoriesEvent {
  const FetchCategoriesEvent();
}

abstract class CategoryHomeEvent extends CategoriesEvent {
  final NoteCategory category;

  CategoryHomeEvent(this.category);

  @override
  List<Object> get props => [category];
}

class AddCategoryEvent extends CategoryHomeEvent {
  AddCategoryEvent(category) : super(category);
}

class UpdateCategoryEvent extends CategoryHomeEvent {
  UpdateCategoryEvent(category) : super(category);
}

class SwitchPriorityForCategoryEvent extends CategoryHomeEvent {
  SwitchPriorityForCategoryEvent(category) : super(category);
}

class DeleteCategoryEvent extends CategoryHomeEvent {
  DeleteCategoryEvent(category) : super(category);
}
