part of 'events_cubit.dart';

class EventsState extends Equatable {
  final PageInfo? page;
  final PageInfo? replyPage;
  final List<int> selectedEvents;
  final List<Event> showEvents;
  final List<Category> categories;
  final Category selectedCategory;
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
    this.isEditMode = false,
    this.isSearchMode = false,
    this.isBookmarkedOnly = false,
    this.isMessageEdit = false,
    this.selectedCategory = const Category(
      icon: Icons.favorite,
      title: 'favorite',
    ),
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
    Category? selectedCategory,
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
      selectedCategory: selectedCategory ?? this.selectedCategory,
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
      selectedCategory,
      replyPageIndex,
      if (page != null) {page},
      if (replyPage != null) {replyPage},
    ];
  }
}
