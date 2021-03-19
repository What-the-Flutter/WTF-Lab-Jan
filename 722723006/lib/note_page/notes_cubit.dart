import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/db_provider.dart';
import 'note.dart';
part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit(NotesState state) : super(state);

  final DBProvider _dbHelper = DBProvider();

  void setWritingState(bool isWriting) =>
      emit(state.copyWith(isWriting: isWriting));

  void setIndexOfIcon(int indexOfSelectIcon) =>
      emit(state.copyWith(indexOfSelectIcon: indexOfSelectIcon));

  void addNote(String text) async {
    var note = Note(
      noteName: text,
      subTittleEvent: 'Add event',
      indexOfCircleAvatar: state.indexOfSelectIcon,
    );
    state.noteList.insert(0, note);
    note.id = await _dbHelper.insertNote(note);
    emit(state.copyWith(noteList: state.noteList));
  }
}
