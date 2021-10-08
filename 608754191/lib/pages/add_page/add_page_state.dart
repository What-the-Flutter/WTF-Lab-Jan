part of 'add_page_cubit.dart';

class AddPageState {
  final List<Category> categories;
  final Category? category;
  final int selectedIconIndex;

  const AddPageState({
    required this.selectedIconIndex,
    required this.categories,
    this.category,
  });

  AddPageState copyWith({
    int? selectedIconIndex,
    List<Category>? categories,
    Category? category,
  }) {
    return AddPageState(
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
      categories: categories ?? this.categories,
      category: category ?? this.category,
    );
  }
}
