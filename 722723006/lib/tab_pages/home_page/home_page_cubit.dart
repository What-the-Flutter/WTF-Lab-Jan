import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/db_provider.dart';
import '../../note_page/note.dart';


part 'home_page_states.dart';

class HomePageCubit extends Cubit<HomePageStates> {
  HomePageCubit() : super(HomePageStates());
  final DBProvider _dbProvider = DBProvider();

  void init() async {
    emit(state.copyWith(noteList: <Note>[]));
    _dbProvider.initDatabase();
    emit(state.copyWith(noteList: await _dbProvider.dbNotesList()));
  }

  void updateNote(Note note) {
    emit(state.copyWith(note: note));
    _dbProvider.updateNote(note);
  }

  void updateList(List<Note> noteList) =>
      emit(state.copyWith(noteList: noteList));

  void deleteNote(List<Note> noteList, int index) {
    _dbProvider.deleteNote(noteList[index]);
    _dbProvider.deleteAllEventFromNote(noteList[index].id);
    noteList.removeAt(index);
    emit(state.copyWith(noteList: noteList));
  }
}
