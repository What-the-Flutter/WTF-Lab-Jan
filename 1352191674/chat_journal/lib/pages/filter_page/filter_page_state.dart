part of 'fllter_page_cubit.dart';

class FilterPageState {
  final List<Note> noteList;
  final List<Note> filterNotesList;
  final List<int> filterLabelList;

  FilterPageState copyWith({
    final List<Note>? noteList,
    final List<Note>? filterNotesList,
    final List<int>? filterLabelList,
  }) {
    return FilterPageState(
      noteList: noteList ?? this.noteList,
      filterNotesList: filterNotesList ?? this.filterNotesList,
      filterLabelList: filterLabelList ?? this.filterLabelList,
    );
  }

  const FilterPageState({
    required this.noteList,
    required this.filterNotesList,
    required this.filterLabelList,
  });
}
