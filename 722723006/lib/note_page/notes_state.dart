part of 'notes_cubit.dart';
class NotesState {
  List<Note> noteList;
  Note note;
  bool isWriting = false;
  CircleAvatar selectIcon;

  NotesState copyWith({
    List<Note> noteList,
    Note note,
    bool isWriting,
    CircleAvatar selectIcon,
  }) {
    var state = NotesState(note ?? this.note, noteList ?? this.noteList);
    state.isWriting = isWriting ?? this.isWriting;
    state.selectIcon = selectIcon ?? this.selectIcon;
    return state;
  }

  NotesState(this.note, this.noteList);
}
