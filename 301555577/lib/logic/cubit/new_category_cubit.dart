import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

part 'new_category_state.dart';

class NewCategoryCubit extends Cubit<NewCategoryState> {
  final CategoryRepository repository;

  NewCategoryCubit({required this.repository})
      : super(const NewCategoryInitial());

  void nameChanged(String name) {
    final currentState = state as UpdateCategoryState;
    emit(currentState.copyWith(
      name: name,
      error:
          name.isEmpty ? NameValidationError.empty : NameValidationError.none,
      category: currentState.selectedCategory?.copyWith(name: name),
      result: SubmissionResult.unknown,
    ));
  }

  void categoryChanged(Category category) {
    final currentState = state as UpdateCategoryState;
    emit(currentState.copyWith(
      category: category,
      name: category.name,
      result: SubmissionResult.unknown,
    ));
  }

  Future<void> categorySubmitted() async {
    final currentState = state as UpdateCategoryState;
    if (currentState.selectedCategory != null &&
        currentState.name?.isNotEmpty == true) {
      final category;
      if (currentState.editCategory != null) {
        category = currentState.editCategory!.copyWith(
          name: currentState.name,
          icon: currentState.selectedCategory!.icon,
        );
      } else {
        category = Category(
          icon: currentState.selectedCategory!.icon,
          name: currentState.name,
        );
      }
      emit(currentState.copyWith(
        category: category,
        result: SubmissionResult.success,
      ));
    } else {
      emit(currentState.copyWith(
        result: SubmissionResult.failure,
        error: currentState.name?.isEmpty ?? true
            ? NameValidationError.empty
            : NameValidationError.none,
      ));
    }
  }

  Future<void> fetchDefaultCategories(Category? editCategory) async {
    emit(const FetchingDefaultCategoriesState());
    final defaultCategories = await repository.fetchDefaultCategories();
    emit(UpdateCategoryState(
      defaultCategories: defaultCategories,
      editCategory: editCategory,
      name: editCategory?.name,
      selectedCategory: editCategory,
    ));
  }
}
