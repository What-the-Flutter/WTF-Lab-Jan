part of 'events_cubit.dart';

class EventsState extends Equatable {
  final PageInfo? page;
  final PageInfo? replyPage;
  final List<int> selectedEvents;
  final List<Event> showEvents;
  final List<Category> categories;
  final int categoryIndex;
  final int replyPageIndex;
  final bool isEditMode;
  final bool isSearchMode;
  final bool isBookmarkedOnly;
  final bool isMessageEdit;

  EventsState({
    this.page,
    this.selectedEvents = const [],
    this.showEvents = const [],
    this.categories = const [],
    this.categoryIndex = 0,
    this.isEditMode = false,
    this.isSearchMode = false,
    this.isBookmarkedOnly = false,
    this.isMessageEdit = false,
    this.replyPage,
    this.replyPageIndex = 0,
  });

  EventsState copyWith({
    PageInfo? page,
    List<int>? selectedEvents,
    List<Event>? showEvents,
    bool? isEditMode,
    bool? isSearchMode,
    List<Category>? categories,
    bool? isBookmarkedOnly,
    bool? isMessageEdit,
    int? categoryIndex,
    PageInfo? replyPage,
    int? replyPageIndex,
  }) {
    return EventsState(
      page: page ?? this.page,
      selectedEvents: selectedEvents ?? this.selectedEvents,
      showEvents: showEvents ?? this.showEvents,
      isEditMode: isEditMode ?? this.isEditMode,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      categories: categories ?? this.categories,
      isBookmarkedOnly: isBookmarkedOnly ?? this.isBookmarkedOnly,
      isMessageEdit: isMessageEdit ?? this.isMessageEdit,
      categoryIndex: categoryIndex ?? this.categoryIndex,
      replyPage: replyPage ?? this.replyPage,
      replyPageIndex: replyPageIndex ?? this.replyPageIndex,
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
      categoryIndex,
      replyPageIndex,
      if (page != null) {page},
      if (replyPage != null) {replyPage},
    ];
  }
}
