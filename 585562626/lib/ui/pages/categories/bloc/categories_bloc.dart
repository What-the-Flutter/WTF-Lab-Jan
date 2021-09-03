import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/category.dart';
import '../../../../repository/category_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoryRepository repository;

  CategoriesBloc(CategoriesState initialState, {required this.repository}) : super(initialState);

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
    if (event is FetchCategoriesEvent) {
      yield* _fetchCategories();
    } else if (state is CategoriesFetchedState) {
      final currentState = state as CategoriesFetchedState;
      if (event is AddCategoryEvent) {
        yield* _addCategory(event, currentState);
      } else if (event is UpdateCategoryEvent) {
        yield* _update(event.category, currentState);
      } else if (event is SwitchPriorityForCategoryEvent) {
        yield* _switchPriority(event, currentState);
      } else if (event is DeleteCategoryEvent) {
        yield* _deleteCategory(event, currentState);
      }
    }
  }

  Stream<CategoriesState> _fetchCategories() async* {
    yield const CategoriesFetchingState();
    final categories = await repository.fetchCategories();
    categories.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    yield CategoriesFetchedState(categories);
  }

  Stream<CategoriesState> _addCategory(
    AddCategoryEvent event,
    CategoriesFetchedState currentState,
  ) async* {
    final categories = List<Category>.from(currentState.categories);
    categories.add(event.category);
    yield CategoriesFetchedState(categories);
    final result = await repository.addCategory(event.category);
    if (result == 0) {
      categories.remove(event.category);
      yield CategoriesFetchedState(categories, errorOccurred: true);
    } else {
      final newCategory = event.category.copyWith(id: result);
      categories.remove(event.category);
      categories.add(newCategory);
      yield CategoriesFetchedState(categories);
    }
  }

  Stream<CategoriesState> _update(
    Category category,
    CategoriesFetchedState state, {
    bool withSorting = false,
  }) async* {
    final oldCategories = state.categories;
    final categories = List<Category>.from(oldCategories);
    final index = categories.indexWhere((element) => element.id == category.id);
    categories.removeAt(index);
    categories.insert(index, category);
    if (withSorting) {
      categories.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    }
    yield CategoriesFetchedState(categories);
    final result = await repository.updateCategory(category);
    if (result == 0) {
      yield CategoriesFetchedState(oldCategories, errorOccurred: true);
    }
  }

  Stream<CategoriesState> _switchPriority(
    SwitchPriorityForCategoryEvent event,
    CategoriesFetchedState currentState,
  ) async* {
    final priority;
    if (event.category.priority == CategoryPriority.high) {
      priority = CategoryPriority.normal;
    } else {
      priority = CategoryPriority.high;
    }
    final newCategory = event.category.copyWith(priority: priority);
    yield* _update(newCategory, currentState, withSorting: true);
  }

  Stream<CategoriesState> _deleteCategory(
    DeleteCategoryEvent event,
    CategoriesFetchedState currentState,
  ) async* {
    final categories = List<Category>.from(currentState.categories);
    final index = categories.indexOf(event.category);
    categories.remove(event.category);
    yield CategoriesFetchedState(categories);
    final result = await repository.deleteCategory(event.category);
    if (result == 0) {
      categories.insert(index, event.category);
      yield CategoriesFetchedState(categories, errorOccurred: true);
    }
  }
}
