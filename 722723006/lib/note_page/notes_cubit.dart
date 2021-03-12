import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note.dart';
part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit(NotesState state) : super(state);

  void setWritingState(bool isWriting) =>
      emit(state.copyWith(isWriting: isWriting));

  void setCircleIcon(CircleAvatar selectIcon) =>
      emit(state.copyWith(selectIcon: selectIcon));

  void addNote(String text) {
    state.noteList.insert(
      0,
      Note(
        text,
        CircleAvatar(
          child: state.selectIcon,
        ),
        'Add event',
      ),
    );
    emit(state.copyWith(noteList: state.noteList));
  }


}
