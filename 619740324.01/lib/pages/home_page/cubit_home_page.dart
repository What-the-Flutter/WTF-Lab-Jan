import 'package:flutter_bloc/flutter_bloc.dart';
import '../../note.dart';
import 'states_home_page.dart';

class CubitHomePage extends Cubit<StatesHomePage> {
  CubitHomePage() : super(StatesHomePage());

  void init(List<Note> noteList) => setNoteList(noteList);

  void setNoteList(List<Note> noteList) =>
      emit(state.copyWith(noteList: noteList));

  void setNote(Note note) => emit(state.copyWith(note: note));

  void deleteNote(int index) {
    state.noteList.removeAt(index);
    setNoteList(state.noteList);
  }

  void addNote(String text, int indexOfCircleAvatar) {
    final note = Note(
      eventName: text,
      indexOfCircleAvatar: indexOfCircleAvatar,
      subTittleEvent: 'Add event',
    );
    state.noteList.add(note);
    setNoteList(state.noteList);
  }
}
