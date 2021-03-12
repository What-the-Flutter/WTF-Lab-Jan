import 'package:flutter_bloc/flutter_bloc.dart';

import '../note_page/note.dart';

part 'home_page_states.dart';

class HomePageCubit extends Cubit<HomePageStates> {
  HomePageCubit(HomePageStates state) : super(state);

  void setThemeChangeState(bool isThemeChange) =>
      emit(state.copyWith(isThemeChange: isThemeChange));

  void updateList(List<Note> noteList) =>
      emit(state.copyWith(noteList: noteList));

  void deleteNote(List<Note> noteList, int index) {
    noteList.removeAt(index);
    emit(state.copyWith(noteList: noteList));
  }
}
