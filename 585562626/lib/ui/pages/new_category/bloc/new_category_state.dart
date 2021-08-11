import 'package:equatable/equatable.dart';

import '../../../../models/category.dart';

enum NameValidationError { empty, none }
enum SubmissionResult { success, failure, unknown }

abstract class NewCategoryState extends Equatable {
  const NewCategoryState();

  @override
  List<Object?> get props => [];
}

class FetchingDefaultCategoriesState extends NewCategoryState {
  const FetchingDefaultCategoriesState();
}

class UpdateCategoryState extends NewCategoryState {
  final List<NoteCategory> defaultCategories;
  final NoteCategory? selectedCategory;
  final String? name;
  final NameValidationError? error;
  final SubmissionResult? result;

  UpdateCategoryState({
    this.selectedCategory,
    this.name,
    this.error,
    this.result,
    required this.defaultCategories,
  });

  UpdateCategoryState copyWith({
    List<NoteCategory>? categories,
    NoteCategory? category,
    String? name,
    NameValidationError? error,
    SubmissionResult? result,
  }) {
    return UpdateCategoryState(
      defaultCategories: categories ?? defaultCategories,
      selectedCategory: category ?? selectedCategory,
      name: name ?? this.name,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [selectedCategory, error, defaultCategories, result, name];
}
