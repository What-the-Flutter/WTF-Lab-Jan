part of 'event_cubit.dart';

class EventState {
  final bool isSearchState;
  final bool isEditMode;
  final bool isPickingPhoto;
  final bool isAddingHashTag;
  final String? selectedPhoto;
  final String? textInput;
  final String? searchInput;
  final DateTime? selectedDate;
  final bool isTextTyped;
  final bool isMultiSelection;
  final bool isTextEditMode;
  final bool isBookmarkedNoteMode;
  final bool isChangingCategory;
  final int selectedCategory;
  final List<int> activeNotes;
  final List<int> bookmarkedNotes;
  final PageCategoryInfo? pageNote;
  final String title;
  final List<Note> allNotes;
  final int checked;
  final PageCategoryInfo? pageToReply;
  final int? pageReplyIndex;

  const EventState({
    this.searchInput = '',
    this.isSearchState = false,
    this.textInput = '',
    this.isAddingHashTag = false,
    this.bookmarkedNotes = const [],
    this.selectedDate,
    this.selectedPhoto = '',
    required this.title,
    required this.allNotes,
    this.pageNote,
    this.pageReplyIndex,
    this.pageToReply,
    this.isPickingPhoto = false,
    this.isEditMode = false,
    this.selectedCategory = 0,
    this.checked = 0,
    this.isTextTyped = false,
    this.isChangingCategory = false,
    this.isBookmarkedNoteMode = false,
    this.isTextEditMode = false,
    this.isMultiSelection = false,
    this.activeNotes = const [],
  });

  EventState copyWith({
    String? searchInput,
    bool? isSearchState,
    String? textInput,
    bool? isAddingHashTag,
    List<int>? bookmarkedNotes,
    String? title,
    DateTime? selectedDate,
    String? selectedPhoto,
    List<Note>? allNotes,
    bool? isEditMode,
    PageCategoryInfo? pageToReply,
    int? pageReplyIndex,
    bool? isPickingPhoto,
    bool? isTextTyped,
    bool? isMultiSelection,
    bool? isTextEditMode,
    bool? isBookmarkedNoteMode,
    bool? isChangingCategory,
    int? selectedCategory,
    int? checked,
    List<int>? activeNotes,
    PageCategoryInfo? pageNote,
  }) {
    return EventState(
      searchInput: searchInput ?? this.searchInput,
      isSearchState: isSearchState ?? this.isSearchState,
      textInput: textInput ?? this.textInput,
      isAddingHashTag: isAddingHashTag ?? this.isAddingHashTag,
      bookmarkedNotes: bookmarkedNotes ?? this.bookmarkedNotes,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedPhoto: selectedPhoto ?? this.selectedPhoto,
      isPickingPhoto: isPickingPhoto ?? this.isPickingPhoto,
      title: title ?? this.title,
      allNotes: allNotes ?? this.allNotes,
      isChangingCategory: isChangingCategory ?? this.isChangingCategory,
      pageNote: pageNote ?? this.pageNote,
      pageReplyIndex: pageReplyIndex ?? this.pageReplyIndex,
      pageToReply: pageToReply ?? this.pageToReply,
      checked: checked ?? this.checked,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isTextTyped: isTextTyped ?? this.isTextTyped,
      isMultiSelection: isMultiSelection ?? this.isMultiSelection,
      isEditMode: isEditMode ?? this.isEditMode,
      isTextEditMode: isTextEditMode ?? this.isTextEditMode,
      isBookmarkedNoteMode: isBookmarkedNoteMode ?? this.isBookmarkedNoteMode,
      activeNotes: activeNotes ?? this.activeNotes,
    );
  }
}
