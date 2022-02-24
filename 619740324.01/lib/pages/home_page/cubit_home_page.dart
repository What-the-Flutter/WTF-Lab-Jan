import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/database_provider.dart';
import '../../note.dart';
import 'states_home_page.dart';

class CubitHomePage extends Cubit<StatesHomePage> {
  CubitHomePage() : super(StatesHomePage());

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  Future<void> init() async {
    final noteList = await _databaseProvider.dbNotesList();
    setNoteList(noteList);
  }

  void setNoteList(List<Note> noteList) =>
      emit(state.copyWith(noteList: noteList));

  void setNote(Note note) => emit(state.copyWith(note: note));

  void deleteNote(int index) {
    _databaseProvider.deleteNote(state.noteList[index]);
    state.noteList.removeAt(index);
    setNoteList(state.noteList);
  }

  void updateNote(Note note) {
    emit(state.copyWith(note: note));
    _databaseProvider.updateNote(note);
  }

  void addNote(String text, int indexOfCircleAvatar) async {
    final note = Note(
      eventName: text,
      indexOfCircleAvatar: indexOfCircleAvatar,
      date: DateFormat.yMMMd().format(DateTime.now()),
      subTittleEvent: 'Add event',
    );
    state.noteList.add(note);
    _databaseProvider.addNote(note);
    setNoteList(state.noteList);
  }
}
