import 'package:flutter_bloc/flutter_bloc.dart';

import '../note.dart';
import '../utils/database.dart';
import '../utils/shared_preferences_provider.dart';
import 'states_home_page.dart';

class CubitHomePage extends Cubit<StatesHomePage> {
  CubitHomePage() : super(StatesHomePage());
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    setNoteList(<Note>[]);
    initSharedPreferences();
    await _databaseProvider.initDB();
    setNoteList(await _databaseProvider.fetchNotesList());
  }


  void initSharedPreferences() => emit(
      state.copyWith(isLightTheme: SharedPreferencesProvider().fetchTheme()));

  void setNoteList(List<Note> noteList) =>
      emit(state.copyWith(noteList: noteList));

  void changeTheme() {
    SharedPreferencesProvider().changeTheme(!state.isLightTheme);
    emit(state.copyWith(isLightTheme: !state.isLightTheme));
  }

  void removeNote(int index) {
    _databaseProvider.deleteNote(state.noteList[index]);
    state.noteList.removeAt(index);
    noteListRedrawing();
  }

  void noteListRedrawing() => emit(state.copyWith(noteList: state.noteList));
}
