part of 'event_page_cubit.dart';

class EventPageState extends Equatable {
  final List<Category> categories;
  final List<int> selectedEventElements;
  final bool isEditMode;
  final bool isSearchMode;
  final bool isBookmarked;
  final bool isMessageEdit;
  final int currentCategoryIndex;
  final int replyEventIndex;
  final Event? replyEvent;
  final Event? event;
  final bool isAvailableForSend;

  EventPageState({
    this.event,
    this.selectedEventElements = const [],
    this.categories = const [],
    this.isEditMode = false,
    this.isSearchMode = false,
    this.isBookmarked = false,
    this.isMessageEdit = false,
    this.currentCategoryIndex = 0,
    this.replyEvent,
    this.replyEventIndex = 0,
    this.isAvailableForSend = false,
  });

  EventPageState copyWith({
    Event? event,
    List<int>? selectedEventElements,
    bool? isEditMode,
    bool? isSearchMode,
    List<Category>? categories,
    bool? isBookmarked,
    bool? isMessageEdit,
    Category? currentCategory,
    Event? replyEvent,
    int? replyEventIndex,
    int? currentCategoryIndex,
    bool? isAvailableForSend,
  }) {
    return EventPageState(
      event: event ?? this.event,
      selectedEventElements: selectedEventElements ?? this.selectedEventElements,
      isEditMode: isEditMode ?? this.isEditMode,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      categories: categories ?? this.categories,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isMessageEdit: isMessageEdit ?? this.isMessageEdit,
      currentCategoryIndex: currentCategoryIndex ?? this.currentCategoryIndex,
      replyEvent: replyEvent ?? this.replyEvent,
      replyEventIndex: replyEventIndex ?? this.replyEventIndex,
      isAvailableForSend: isAvailableForSend ?? this.isAvailableForSend,
    );
  }

  @override
  List<Object?> get props {
    return [
      selectedEventElements,
      isEditMode,
      isSearchMode,
      isBookmarked,
      isMessageEdit,
      currentCategoryIndex,
      replyEventIndex,
      event,
      replyEvent,
      isAvailableForSend,
    ];
  }
}
