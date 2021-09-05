import '../models/category.dart';
import '../models/event.dart';
import '../models/section.dart';

class EventState {
  final bool isSearchMode;
  final bool isEditMode;
  final List<int> selectedEvent;
  final Category? category;
  final Section? selectedSection;
  final bool isWriting;
  final bool isMessageEdit;
  final Category? replyCategory;
  final int replyCategoryIndex;

  EventState({
    this.category,
    this.selectedEvent = const [],
    this.isSearchMode = false,
    this.isEditMode = false,
    this.selectedSection,
    this.isWriting = false,
    this.isMessageEdit = false,
    this.replyCategory,
    this.replyCategoryIndex = 0,
  });

  EventState copyWith({
    Category? category,
    List<Event>? eventList,
    bool? isSearchMode,
    List<int>? selectedEvent,
    Section? selectedSection,
    bool? isWriting,
    bool? isEditMode,
    bool? isMessageEdit,
    Category? replyCategory,
    int? replyCategoryIndex,
  }) {
    return EventState(
      category: category ?? this.category,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      selectedSection: selectedSection ?? this.selectedSection,
      selectedEvent: selectedEvent ?? this.selectedEvent,
      isWriting: isWriting ?? this.isWriting,
      isEditMode: isEditMode ?? this.isEditMode,
      isMessageEdit: isMessageEdit ?? this.isMessageEdit,
      replyCategory: replyCategory ?? this.replyCategory,
      replyCategoryIndex: replyCategoryIndex ?? this.replyCategoryIndex,
    );
  }
}
