import '../../../note_page/note.dart';

class FilterPageState {
  final List<Note> noteList;
  final List<Note> filterNotesList;
  final List<int> filterLabelList;
  FilterPageState copyWith({
    final List<Note> noteList,
    final List<Note> filterNotesList,
    final List<int> filterLabelList,
  }) {
    return FilterPageState(
      noteList: noteList ?? this.noteList,
      filterNotesList: filterNotesList ?? this.filterNotesList,
      filterLabelList: filterLabelList ?? this.filterLabelList,
    );
  }

  const FilterPageState({
    this.noteList,
    this.filterNotesList,
    this.filterLabelList,
  });
}
