part of 'event_page_cubit.dart';

class EventPageState extends Equatable {
  final Event? page;
  final List<int> selectedEvents;
  final bool isEditMode;
  final bool isSearchMode;
  final bool isBookmarkedOnly;
  final bool isMessageEdit;
  final List<Category> categories;
  final Category selectedCategory;
  final Event? replyPage;
  final int replyPageIndex;
  final double? xStart;
  final double? xCurrent;

  EventPageState({
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

  EventPageState copyWith({
    double? xStart,
    double? xCurrent,
    Event? page,
    List<int>? selectedEvents,
    bool? isEditMode,
    bool? isSearchMode,
    List<Category>? categories,
    bool? isBookmarkedOnly,
    bool? isMessageEdit,
    Category? selectedCategory,
    Event? replyPage,
    int? replyPageIndex,
  }) {
    return EventPageState(
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
  List<Object?> get props {
    return [
      selectedEvents,
      isEditMode,
      isSearchMode,
      isBookmarkedOnly,
      isMessageEdit,
      selectedCategory,
      replyPageIndex,
      page,
      replyPage,
      xStart,
      xCurrent,
    ];
  }
}
