import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/category.dart';
import '../../../../repository/category_repository.dart';
import 'bloc.dart';
import 'new_category_event.dart';
import 'new_category_state.dart';

class NewCategoryBloc extends Bloc<NewCategoryEvent, NewCategoryState> {
  final CategoryRepository repository;

  NewCategoryBloc(NewCategoryState initialState, {required this.repository}) : super(initialState);

  @override
  Stream<NewCategoryState> mapEventToState(NewCategoryEvent event) async* {
    final currentState = state;
    if (currentState is UpdateCategoryState) {
      if (event is NameChangedEvent) {
        yield _nameChanged(currentState, event);
      } else if (event is CategoryChanged) {
        yield _categoryChanged(currentState, event);
      } else if (event is NewCategorySubmitted) {
        yield* _categorySubmitted(currentState);
      }
    } else {
      if (event is FetchDefaultCategoriesEvent) {
        yield await _fetchDefaultCategories(event);
      }
    }
  }

  NewCategoryState _nameChanged(UpdateCategoryState currentState, NameChangedEvent event) {
    return currentState.copyWith(
      name: event.name,
      error: event.name.isEmpty ? NameValidationError.empty : NameValidationError.none,
      category: currentState.selectedCategory?.copyWith(name: event.name),
      result: SubmissionResult.unknown,
    );
  }

  NewCategoryState _categoryChanged(UpdateCategoryState currentState, CategoryChanged event) {
    return currentState.copyWith(
      category: event.category,
      name: event.category.name,
      result: SubmissionResult.unknown,
    );
  }

  Stream<NewCategoryState> _categorySubmitted(UpdateCategoryState currentState) async* {
    if (currentState.selectedCategory != null && currentState.name?.isNotEmpty == true) {
      final category;
      if (currentState.editCategory != null) {
        category = currentState.editCategory!.copyWith(
          name: currentState.name,
          color: currentState.selectedCategory!.color,
          image: currentState.selectedCategory!.image,
        );
      } else {
        category = NoteCategory(
          color: currentState.selectedCategory!.color,
          image: currentState.selectedCategory!.image,
          name: currentState.name,
        );
      }
      yield currentState.copyWith(
        category: category,
        result: SubmissionResult.success,
      );
    } else {
      yield currentState.copyWith(
        result: SubmissionResult.failure,
        error: currentState.name?.isEmpty ?? true
            ? NameValidationError.empty
            : NameValidationError.none,
      );
    }
  }

  Future<NewCategoryState> _fetchDefaultCategories(FetchDefaultCategoriesEvent event) async {
    final defaultCategories = await repository.fetchDefaultCategories();
    return UpdateCategoryState(
        defaultCategories: defaultCategories,
        editCategory: event.editCategory,
        name: event.editCategory?.name,
        selectedCategory: event.editCategory);
  }
}
