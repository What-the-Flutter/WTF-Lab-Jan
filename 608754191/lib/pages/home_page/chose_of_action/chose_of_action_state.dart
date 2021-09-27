part of 'chose_of_action_cubit.dart';

class ChoseOfActionState {
  final List<Category> categories;

  ChoseOfActionState({required this.categories});

  ChoseOfActionState copyWith({List<Category>? categories}) {
    return ChoseOfActionState(
      categories: categories ?? this.categories,
    );
  }
}
