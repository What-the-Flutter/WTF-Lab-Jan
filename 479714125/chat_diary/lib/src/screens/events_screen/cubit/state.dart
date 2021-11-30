part of 'cubit.dart';

class EventScreenState {
  final PageModel page;
  final int countOfSelected;
  final bool isEditing;
  final bool isImageSelected;
  final bool isCategory;
  final IconData? currentCategory;

  bool get containsSelected => countOfSelected > 0;

  bool get containsMoreThanOneSelected => countOfSelected > 1;

  EventScreenState({
    required this.currentCategory,
    required this.isCategory,
    required this.page,
    required this.countOfSelected,
    required this.isEditing,
    required this.isImageSelected,
  });

  EventScreenState copyWith({
    PageModel? page,
    int? countOfSelected,
    bool? isEditing,
    bool? isImageSelected,
    bool? isCategory,
    IconData? currentCategory,
  }) =>
      EventScreenState(
        currentCategory: currentCategory ?? this.currentCategory,
        page: page ?? this.page,
        countOfSelected: countOfSelected ?? this.countOfSelected,
        isEditing: isEditing ?? this.isEditing,
        isImageSelected: isImageSelected ?? this.isImageSelected,
        isCategory: isCategory ?? this.isCategory,
      );
}
