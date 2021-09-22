part of 'event_cubit.dart';

class EventState {
  final bool isEditMode;
  final bool isPickingPhoto;
  final String? selectedPhoto;
  final bool isTextTyped;
  final bool isMultiSelection;
  final bool isTextEditMode;
  final bool isBookmarkedNoteMode;
  final bool isChangingCategory;
  final int selectedCategory;
  final List<int> activeNotes;
  final PageCategoryInfo? pageNote;
  final String title;
  final List<Note> allNotes;
  final int checked;
  final PageCategoryInfo? pageToReply;
  final int? pageReplyIndex;

  const EventState({
    this.selectedPhoto,
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
    String? title,
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
      selectedPhoto: selectedPhoto ?? selectedPhoto,
      isPickingPhoto: isPickingPhoto ?? this.isPickingPhoto,
      title: title ?? this.title,
      allNotes: allNotes ?? this.allNotes,
      isChangingCategory: isChangingCategory ?? this.isChangingCategory,
      pageNote: pageNote ?? this.pageNote,
      pageReplyIndex: pageReplyIndex ?? pageReplyIndex,
      pageToReply: pageToReply ?? pageToReply,
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
