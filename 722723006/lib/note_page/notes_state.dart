part of 'notes_cubit.dart';

class NotesState {
  List<Note> noteList;
  Note note;
  bool isWriting = false;
  int indexOfSelectIcon;

  NotesState copyWith({
    List<Note> noteList,
    Note note,
    bool isWriting,
    CircleAvatar selectIcon,
    int indexOfSelectIcon,
  }) {
    var state = NotesState(note ?? this.note, noteList ?? this.noteList);
    state.isWriting = isWriting ?? this.isWriting;
    state.indexOfSelectIcon = indexOfSelectIcon ?? this.indexOfSelectIcon;
    return state;
  }

  NotesState(this.note, this.noteList);
}
