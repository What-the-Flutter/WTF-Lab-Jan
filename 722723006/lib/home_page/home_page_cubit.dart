import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/db_provider.dart';
import '../data/shared_preferences_provider.dart';
import '../note_page/note.dart';

part 'home_page_states.dart';

class HomePageCubit extends Cubit<HomePageStates> {
  HomePageCubit(HomePageStates state) : super(state);
  final DBProvider _dbProvider = DBProvider();

  void init() async {
    await _dbProvider.dbNotesList(state.noteList);
    emit(state.copyWith(noteList: state.noteList));
  }

  void setThemeChangeState(bool isThemeChange) {
    SharedPreferencesProvider().changeTheme(isThemeChange);
    emit(state.copyWith(isThemeChange: isThemeChange));
  }

  void updateNote(Note note) {
    emit(state.copyWith(note: note));
    _dbProvider.updateNote(note);
  }

  void updateList(List<Note> noteList) =>
      emit(state.copyWith(noteList: noteList));

  void deleteNote(List<Note> noteList, int index) {
    _dbProvider.deleteNote(noteList[index]);
    noteList.removeAt(index);
    emit(state.copyWith(noteList: noteList));
  }
}
