import 'package:flutter_bloc/flutter_bloc.dart';
import '../themes/shared_preferences_provider.dart';
import '../utils/database.dart';
import 'states_home_page.dart';

class CubitHomePage extends Cubit<StatesHomePage> {
  CubitHomePage(StatesHomePage state) : super(state);
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    await _databaseProvider.downloadNotesList(state.noteList);
    noteListRedrawing();
  }

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
