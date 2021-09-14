import 'package:chat_journal/models/note_model.dart';
import 'package:chat_journal/services/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'create_state.dart';

class NotesCubit extends Cubit<NotesState> {

  NotesCubit() : super(NotesState(indexOfSelectIcon: 0, noteList: []));

  final DBProvider _dbHelper = DBProvider();

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
    //сделать олдстейт и сделать имитабельность
    state.noteList.insert(0, note);
    note.id = await _dbHelper.insertNote(note);
    emit(state.copyWith(noteList: state.noteList, isWriting: state.isWriting));
  }
}