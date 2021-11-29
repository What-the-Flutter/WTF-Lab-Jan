part of 'cubit.dart';

class EventScreenState {
  final PageModel page;
  final int countOfSelected;
  final bool isEditing;
  final bool isImageSelected;

  bool get containsSelected => countOfSelected > 0;

  bool get containsMoreThanOneSelected => countOfSelected > 1;

  EventScreenState({
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
  }) =>
      EventScreenState(
        page: page ?? this.page,
        countOfSelected: countOfSelected ?? this.countOfSelected,
        isEditing: isEditing ?? this.isEditing,
        isImageSelected: isImageSelected ?? this.isImageSelected,
      );
}
