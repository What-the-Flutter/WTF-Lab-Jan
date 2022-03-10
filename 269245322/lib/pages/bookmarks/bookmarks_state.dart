import '../../models/note_model.dart';
import '../../models/page_model.dart';

class BookmarksState {
  final List<NoteModel> notesListUI;
  final List<NoteModel> notesList;
  final List<NoteModel> bookmarkedNotesList;
  final List<PageModel> pagesList;
  final Map<String, bool> pagesFilterMap;
  final Map<int, bool> iconsFilterMap;
  final List<String> pagesFilterList;
  final List<int> iconsFilterList;
  final bool bookmarkButtonEnable;
  final List<NoteModel>? notesListBookmarked;
  final List<NoteModel>? notesListWithFilters;

  BookmarksState({
    required this.notesListUI,
    required this.notesList,
    required this.bookmarkedNotesList,
    required this.pagesList,
    required this.pagesFilterMap,
    required this.iconsFilterMap,
    required this.pagesFilterList,
    required this.iconsFilterList,
    required this.bookmarkButtonEnable,
    this.notesListBookmarked,
    this.notesListWithFilters,
  });

  BookmarksState copyWith({
    final List<NoteModel>? notesListUI,
    final List<NoteModel>? notesList,
    final List<NoteModel>? bookmarkedNotesList,
    final List<PageModel>? pagesList,
    final Map<String, bool>? pagesFilterMap,
    final Map<int, bool>? iconsFilterMap,
    final List<String>? pagesFilterList,
    final List<int>? iconsFilterList,
    final bool? bookmarkButtonEnable,
    final List<NoteModel>? notesListBookmarked,
    final List<NoteModel>? notesListWithFilters,
  }) {
    return BookmarksState(
      notesListUI: notesListUI ?? this.notesListUI,
      notesList: notesList ?? this.notesList,
      bookmarkedNotesList: bookmarkedNotesList ?? this.bookmarkedNotesList,
      pagesList: pagesList ?? this.pagesList,
      pagesFilterMap: pagesFilterMap ?? this.pagesFilterMap,
      iconsFilterMap: iconsFilterMap ?? this.iconsFilterMap,
      pagesFilterList: pagesFilterList ?? this.pagesFilterList,
      iconsFilterList: iconsFilterList ?? this.iconsFilterList,
      bookmarkButtonEnable: bookmarkButtonEnable ?? this.bookmarkButtonEnable,
      notesListBookmarked: notesListBookmarked ?? this.notesListBookmarked,
      notesListWithFilters: notesListWithFilters ?? this.notesListWithFilters,
    );
  }
}
