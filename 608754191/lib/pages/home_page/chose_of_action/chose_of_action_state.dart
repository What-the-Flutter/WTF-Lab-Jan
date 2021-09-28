part of 'chose_of_action_cubit.dart';

class ChoseOfActionState {
  final List<Category> categories;
  final int index;

  ChoseOfActionState({required this.categories, required this.index});

  ChoseOfActionState copyWith({List<Category>? categories, int? index}) {
    return ChoseOfActionState(
      categories: categories ?? this.categories,
      index: index ?? this.index,
    );
  }
}
