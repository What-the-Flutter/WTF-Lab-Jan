import '../event.dart';
import '../note.dart';

class StatesEventPage {
  final List<Event> currentEventsList;
  final Note note;
  final int selectedIconIndex;
  final bool isEditing;
  final bool isSearch;
  final bool isAddingPhoto;
  final bool isSendPhotoButton;
  final bool isDateTimeModification;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;
  final bool isSortedByBookmarks;
  final int selectedItemIndex;
  final int selectedPageReplyIndex;
  final String selectedDate;
  final String selectedTime;

  const StatesEventPage({
    this.note,
    this.currentEventsList,
    this.selectedIconIndex,
    this.isSortedByBookmarks,
    this.isEditing,
    this.isSearch,
    this.isAddingPhoto,
    this.isSendPhotoButton,
    this.isDateTimeModification,
    this.isBubbleAlignment,
    this.isCenterDateBubble,
    this.selectedItemIndex,
    this.selectedPageReplyIndex,
    this.selectedDate,
    this.selectedTime,
  });

  StatesEventPage copyWith({
    final List<Event> currentEventsList,
    final Note note,
    final String selectedDate,
    final String selectedTime,
    final int selectedIconIndex,
    final bool isDateTimeModification,
    final bool isBubbleAlignment,
    final bool isCenterDateBubble,
    final bool isEditing,
    final bool isAddingPhoto,
    final bool isSendPhotoButton,
    final bool isSearch,
    final bool isSortedByBookmarks,
    final int selectedItemIndex,
    final int selectedPageReplyIndex,
  }) {
    return StatesEventPage(
      note: note ?? this.note,
      currentEventsList: currentEventsList ?? this.currentEventsList,
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      isDateTimeModification:
          isDateTimeModification ?? this.isDateTimeModification,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isEditing: isEditing ?? this.isEditing,
      isAddingPhoto: isAddingPhoto ?? this.isAddingPhoto,
      isSendPhotoButton: isSendPhotoButton ?? this.isSendPhotoButton,
      isSearch: isSearch ?? this.isSearch,
      isSortedByBookmarks: isSortedByBookmarks ?? this.isSortedByBookmarks,
      selectedItemIndex: selectedItemIndex ?? this.selectedItemIndex,
      selectedPageReplyIndex:
          selectedPageReplyIndex ?? this.selectedPageReplyIndex,
    );
  }
}
