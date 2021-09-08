part of 'event_cubit.dart';

class EventState extends Equatable {
  final bool isEditMode;
  final bool isTextTyped;
  final bool isMultiSelection;
  final bool isTextEditMode;
  final bool isBookmarkedNoteMode;
  final bool isChangingCategory;
  final EventCategory selectedCategory;
  final List<int> activeNotes;
  final PageCategoryInfo? pageNote;
  final int? checked;
  final PageCategoryInfo? pageToReply;
  final int? pageReplyIndex;

  EventState({
    this.pageNote,
    this.pageReplyIndex,
    this.pageToReply,
    this.isEditMode = false,
    this.selectedCategory = const EventCategory(icon: Icons.event, title: ''),
    this.checked,
    this.isTextTyped = false,
    this.isChangingCategory = false,
    this.isBookmarkedNoteMode = false,
    this.isTextEditMode = false,
    this.isMultiSelection = false,
    this.activeNotes = const [],
  });

  EventState copyWith({
    bool? isEditMode,
    PageCategoryInfo? pageToReply,
    int? pageReplyIndex,
    bool? isTextTyped,
    bool? isMultiSelection,
    bool? isTextEditMode,
    bool? isBookmarkedNoteMode,
    bool? isChangingCategory,
    EventCategory? selectedCategory,
    int? checked,
    List<int>? activeNotes,
    PageCategoryInfo? pageNote,
  }) {
    return EventState(
      isChangingCategory: isChangingCategory ?? this.isChangingCategory,
      pageNote: pageNote ?? this.pageNote,
      pageReplyIndex: pageReplyIndex ?? pageReplyIndex,
      pageToReply: pageToReply ?? pageToReply,
      checked: checked ?? checked,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isTextTyped: isTextTyped ?? this.isTextTyped,
      isMultiSelection: isMultiSelection ?? this.isMultiSelection,
      isEditMode: isEditMode ?? this.isEditMode,
      isTextEditMode: isTextEditMode ?? this.isTextEditMode,
      isBookmarkedNoteMode: isBookmarkedNoteMode ?? this.isBookmarkedNoteMode,
      activeNotes: activeNotes ?? this.activeNotes,
    );
  }

  @override
  List<Object?> get props {
    return [
      isEditMode,
      isTextTyped,
      isMultiSelection,
      isTextEditMode,
      isBookmarkedNoteMode,
      isChangingCategory,
      selectedCategory,
      activeNotes,
      pageNote,
      checked,
      pageToReply,
      pageReplyIndex,
    ];
  }
}
