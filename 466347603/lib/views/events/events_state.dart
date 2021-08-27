part of 'events_cubit.dart';

class EventsState extends Equatable {
  final PageInfo? page;
  final List<int> selectedEvents;
  final bool isEditMode;
  final bool isSearchMode;
  final bool isBookmarkedOnly;
  final bool isMessageEdit;
  final List<Category> categories;
  final Category selectedCategory;
  final PageInfo? replyPage;
  final int replyPageIndex;
  final double? xStart;
  final double? xCurrent;

  EventsState({
    this.xCurrent,
    this.xStart,
    this.page,
    this.selectedEvents = const [],
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
    double? xStart,
    double? xCurrent,
    PageInfo? page,
    List<int>? selectedEvents,
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
      xStart: xStart ?? this.xStart,
      xCurrent: xCurrent ?? this.xCurrent,
      page: page ?? this.page,
      selectedEvents: selectedEvents ?? this.selectedEvents,
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
      isSearchMode,
      isBookmarkedOnly,
      isMessageEdit,
      selectedCategory,
      replyPageIndex,
      if (page != null) {page},
      if (replyPage != null) {replyPage},
      if (xStart != null) {xStart},
      if (xCurrent != null) {xCurrent},
    ];
  }
}
