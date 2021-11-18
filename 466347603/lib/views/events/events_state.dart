part of 'events_cubit.dart';

class EventsState extends Equatable {
  final int pageId;
  final PageInfo? page;
  final PageInfo? replyPage;
  final List<int> selectedEvents;
  final List<Event> showEvents;
  final List<Category> categories;
  final Category selectedCategory;
  final int replyPageIndex;
  final int showEventsLength;
  final String lastEventMessage;
  final bool isEditMode;
  final bool isSearchMode;
  final bool isBookmarkedOnly;
  final bool isMessageEdit;
  final bool isBubbleAlignmentRight;
  final bool isCenterDateBubble;
  final bool isDateModifiable;
  final DateTime? newEventDate;
  final String formattedEventDate;

  EventsState({
    this.pageId = -1,
    this.page,
    this.selectedEvents = const [],
    this.showEvents = const [],
    this.categories = const [],
    this.showEventsLength = 0,
    this.isEditMode = false,
    this.isSearchMode = false,
    this.isBookmarkedOnly = false,
    this.isMessageEdit = false,
    this.isBubbleAlignmentRight = false,
    this.isCenterDateBubble = false,
    this.isDateModifiable = false,
    this.lastEventMessage = '',
    this.selectedCategory = const Category(
      icon: Icons.favorite,
      title: 'favorite',
    ),
    this.replyPage,
    this.replyPageIndex = 0,
    this.newEventDate,
    this.formattedEventDate = 'Today',
  });

  EventsState copyWith({
    int? pageId,
    PageInfo? page,
    List<int>? selectedEvents,
    List<Event>? showEvents,
    bool? isEditMode,
    bool? isSearchMode,
    List<Category>? categories,
    bool? isBookmarkedOnly,
    bool? isMessageEdit,
    bool? isBubbleAlignmentRight,
    bool? isCenterDateBubble,
    bool? isDateModifiable,
    String? lastEventMessage,
    Category? selectedCategory,
    PageInfo? replyPage,
    int? replyPageIndex,
    int? showEventsLength,
    DateTime? newEventDate,
    String? formattedEventDate,
  }) {
    return EventsState(
      pageId: pageId ?? this.pageId,
      page: page ?? this.page,
      selectedEvents: selectedEvents ?? this.selectedEvents,
      showEvents: showEvents ?? this.showEvents,
      isEditMode: isEditMode ?? this.isEditMode,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      lastEventMessage: lastEventMessage ?? this.lastEventMessage,
      categories: categories ?? this.categories,
      isBookmarkedOnly: isBookmarkedOnly ?? this.isBookmarkedOnly,
      isMessageEdit: isMessageEdit ?? this.isMessageEdit,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isBubbleAlignmentRight:
          isBubbleAlignmentRight ?? this.isBubbleAlignmentRight,
      isDateModifiable: isDateModifiable ?? this.isDateModifiable,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      replyPage: replyPage ?? this.replyPage,
      replyPageIndex: replyPageIndex ?? this.replyPageIndex,
      showEventsLength: showEventsLength ?? this.showEventsLength,
      newEventDate: newEventDate,
      formattedEventDate: formattedEventDate ?? 'Today',
    );
  }

  @override
  List<Object> get props {
    return [
      selectedEvents,
      isEditMode,
      showEvents,
      isSearchMode,
      isBookmarkedOnly,
      isMessageEdit,
      selectedCategory,
      replyPageIndex,
      showEventsLength,
      lastEventMessage,
      isBubbleAlignmentRight,
      formattedEventDate,
      isCenterDateBubble,
      isDateModifiable,
      if (page != null) {page, page!.events.length},
      if (replyPage != null) {replyPage},
      if (newEventDate != null) {newEventDate},
    ];
  }
}
