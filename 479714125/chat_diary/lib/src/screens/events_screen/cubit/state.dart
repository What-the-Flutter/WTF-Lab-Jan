part of 'cubit.dart';

class EventScreenState {
  final PageModel page;
  final int countOfSelected;
  final int newEventIndex;
  final bool isEditing;
  final bool isImageSelected;
  final bool isCategory;
  final IconData? currentCategory;
  final bool isSearch;

  bool get containsSelected => countOfSelected > 0;

  bool get containsMoreThanOneSelected => countOfSelected > 1;

  EventScreenState({
    required this.newEventIndex,
    required this.currentCategory,
    required this.isCategory,
    required this.page,
    required this.isSearch,
    required this.countOfSelected,
    required this.isEditing,
    required this.isImageSelected,
  });

  EventScreenState copyWith({
    PageModel? page,
    int? countOfSelected,
    int? countOfSelectedCategories,
    int? newEventIndex,
    bool? isEditing,
    bool? isImageSelected,
    bool? isCategory,
    bool? isSearch,
    IconData? currentCategory,
  }) {
    return EventScreenState(
      currentCategory: currentCategory,
      isSearch: isSearch ?? this.isSearch,
      page: page ?? this.page,
      countOfSelected: countOfSelected ?? this.countOfSelected,
      isEditing: isEditing ?? this.isEditing,
      isImageSelected: isImageSelected ?? this.isImageSelected,
      isCategory: isCategory ?? this.isCategory,
      newEventIndex: newEventIndex ?? this.newEventIndex,
    );
  }
}
