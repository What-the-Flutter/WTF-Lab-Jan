part of 'notes_cubit.dart';

class NotesState {
  final List<Note> noteList;
  final Note note;
  final bool isWriting;
  final int indexOfSelectIcon;

  NotesState copyWith({
    final List<Note> noteList,
    final Note note,
    final bool isWriting,
    final CircleAvatar selectIcon,
    final int indexOfSelectIcon,
  }) {
    return NotesState(
      noteList: noteList ?? this.noteList,
      note: note ?? this.note,
      isWriting: isWriting ?? this.isWriting,
      indexOfSelectIcon: indexOfSelectIcon ?? this.indexOfSelectIcon,
    );
  }

  const NotesState({
    this.noteList,
    this.note,
    this.isWriting,
    this.indexOfSelectIcon,
  });
}
