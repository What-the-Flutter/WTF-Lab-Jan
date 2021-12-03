import 'package:flutter_bloc/flutter_bloc.dart';
import '../../note.dart';
import 'states_home_page.dart';

class CubitHomePage extends Cubit<StatesHomePage> {
  CubitHomePage() : super(StatesHomePage());

  void init(List<Note> noteList) => setNoteList(noteList);

  void setNoteList(List<Note> noteList) =>
      emit(state.copyWith(noteList: noteList));
}
