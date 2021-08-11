import 'package:cool_notes/ui/pages/new_category/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repository/category_repository.dart';
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
        print('process $state ${event.name.isEmpty}');
        yield currentState.copyWith(
          name: event.name,
          error: event.name.isEmpty ? NameValidationError.empty : NameValidationError.none,
          category: currentState.selectedCategory?.copyWith(name: event.name),
          result: SubmissionResult.unknown,
        );
      } else if (event is CategoryChanged) {
        yield currentState.copyWith(
          category: event.category,
          name: event.category.name,
          result: SubmissionResult.unknown,
        );
      } else if (event is NewCategorySubmitted) {
        if (currentState.selectedCategory != null && currentState.name?.isNotEmpty == true) {
          yield currentState.copyWith(
            category: currentState.selectedCategory?.copyWith(name: currentState.name),
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
    } else {
      if (event is FetchDefaultCategoriesEvent) {
        final defaultCategories = await repository.defaultCategories;
        yield UpdateCategoryState(defaultCategories: defaultCategories);
      }
    }
  }
}
