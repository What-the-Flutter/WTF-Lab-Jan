import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/note_model.dart';
import '../../services/db_provider.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final DBProvider _dbProvider = DBProvider();

  HomePageCubit() : super(HomePageState([],null));

  void init() async {
    emit(state.copyWith(noteList: <Note>[]));
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