import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoryRepository repository;

  CategoriesCubit({required this.repository})
      : super(const CategoriesInitial());

  Future<void> fetchCategories() async {
    try {
      emit(const CategoriesFetchingState());
      final categories = await repository.fetchCategories();
      categories.sort((a, b) => a.priority.index.compareTo(b.priority.index));
      emit(CategoriesFetchedState(categories));
    } catch (e) {
      emit(CategoriesFetchingError(message: e.toString()));
    }
  }

  Future<void> addCategory(Category category) async {
    final currentState = state as CategoriesFetchedState;
    final categories = List<Category>.from(currentState.categories);
    categories.add(category);
    emit(CategoriesFetchedState(categories));
    final result = await repository.addCategory(category);
    if (result == 0) {
      categories.remove(category);
      emit(CategoriesFetchedState(categories, error: true));
    } else {
      final newCategory = category.copyWith(id: result);
      categories.remove(category);
      categories.add(newCategory);
      emit(CategoriesFetchedState(categories));
    }
  }

  Future<void> switchPriorityCategory(Category category) async {
    final priority;
    if (category.priority == CategoryPriority.high) {
      priority = CategoryPriority.normal;
    } else {
      priority = CategoryPriority.high;
    }
    final newCategory = category.copyWith(priority: priority);
    await updateCategory(newCategory, withSorting: true);
  }

  Future<void> deleteCategory(Category category) async {
    final currentState = state as CategoriesFetchedState;
    final categories = List<Category>.from(currentState.categories);
    final index = categories.indexOf(category);
    categories.remove(category);
    emit(CategoriesFetchedState(categories));
    final result = await repository.deleteCategory(category);
    if (result == 0) {
      categories.insert(index, category);
      emit(CategoriesFetchedState(categories, error: true));
    }
  }

  Future<void> updateCategory(
    Category category, {
    bool withSorting = false,
  }) async {
    final currentState = state as CategoriesFetchedState;
    final oldCategories = currentState.categories;
    final categories = List<Category>.from(oldCategories);
    final index = categories.indexWhere((element) => element.id == category.id);
    categories.removeAt(index);
    categories.insert(index, category);
    if (withSorting) {
      categories.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    }
    emit(CategoriesFetchedState(categories));
    final result = await repository.updateCategory(category);
    if (result == 0) {
      emit(CategoriesFetchedState(categories, error: true));
    }
  }
}
