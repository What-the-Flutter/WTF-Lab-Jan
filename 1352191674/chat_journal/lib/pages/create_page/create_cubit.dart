import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/note_model.dart';
import '../../services/db_provider.dart';

part 'create_state.dart';

class NotesCubit extends Cubit<NotesState> {

  final DBProvider _dbHelper = DBProvider();

  NotesCubit() : super(NotesState(indexOfSelectIcon: 0, noteList: []));

  void init(Note? note, List<Note>? noteList) =>
      emit(state.copyWith(noteList: noteList, note: note, isWriting: false));

  void setWritingState(bool isWriting) =>
      emit(state.copyWith(isWriting: isWriting));

  void setIndexOfIcon(int indexOfSelectIcon) =>
      emit(state.copyWith(indexOfSelectIcon: indexOfSelectIcon));

  void addNote(String text) async {
    final noteId = state.noteList.length;
    final note = Note(
      noteName: text,
      subTitleEvent: 'Add event',
      indexOfCircleAvatar: state.indexOfSelectIcon,
      date:  DateFormat.yMMMd('en_US').format(
        DateTime.now(),
      ),
      isSelected: false, id: noteId+1,
    );
    var newNoteList = state.noteList;
    newNoteList.insert(0, note);
    note.id = await _dbHelper.insertNote(note);
    emit(state.copyWith(noteList: newNoteList, isWriting: state.isWriting));
  }
}