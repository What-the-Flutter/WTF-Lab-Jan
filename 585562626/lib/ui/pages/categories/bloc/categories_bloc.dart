import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repository/category_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoryRepository repository;

  CategoriesBloc(CategoriesState initialState, {required this.repository}) : super(initialState);

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
    if (event is AddCategoryEvent) {
      await repository.addCategory(event.category);
    } else if (event is UpdateCategoryEvent) {
      await repository.updateCategory(event.category);
    } else if (event is SwitchPriorityForCategoryEvent) {
      await repository.switchPriority(event.category);
    } else if (event is DeleteCategoryEvent) {
      await repository.deleteCategory(event.category);
    }
    yield* _fetchCategories();
  }

  Stream<CategoriesState> _fetchCategories() async* {
    yield const CategoriesFetchingState();
    final categories = await repository.fetchCategories();
    categories.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    yield CategoriesFetchedState(categories);
  }
}
