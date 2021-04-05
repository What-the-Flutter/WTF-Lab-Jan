import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/database_provider.dart';
import '../data/shared_preferences_provider.dart';
import '../note.dart';
import 'states_home_page.dart';

class CubitHomePage extends Cubit<StatesHomePage> {
  CubitHomePage(state) : super(state);
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    _databaseProvider.initDatabase();
    state.noteList = await _databaseProvider.dbNotesList();
    redrawingList();
  }

  void changeTheme() {
    SharedPreferencesProvider().changeTheme(!state.isLightTheme);
    emit(state.copyWith(isLightTheme: !state.isLightTheme));
  }

  void updateNote(Note note) {
    emit(state.copyWith(note: note));
    _databaseProvider.updateNote(note);
  }

  void deleteNote(List<Note> noteList, int index) {
    _databaseProvider.deleteNote(noteList[index]);
    noteList.removeAt(index);
    redrawingList();
  }

  void redrawingList() => emit(state.copyWith(noteList: state.noteList));
}
