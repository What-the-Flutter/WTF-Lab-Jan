import 'package:my_lab_project/models/note_model.dart';

class BookmarksState {
  final List<NoteModel> notesList;
  final List<String> pagesFilterList;
  final List<int> iconsFilterList;
  final bool bookmarkButtonEnable;

  BookmarksState({
    required this.notesList,
    required this.pagesFilterList,
    required this.iconsFilterList,
    required this.bookmarkButtonEnable,
  });

  BookmarksState copyWith({
    final List<NoteModel>? notesList,
    final List<String>? pagesFilterList,
    final List<int>? iconsFilterList,
    final bool? bookmarkButtonEnable,
  }) {
    return BookmarksState(
      notesList: notesList ?? this.notesList,
      pagesFilterList: pagesFilterList ?? this.pagesFilterList,
      iconsFilterList: iconsFilterList ?? this.iconsFilterList,
      bookmarkButtonEnable: bookmarkButtonEnable ?? this.bookmarkButtonEnable,
    );
  }
}
