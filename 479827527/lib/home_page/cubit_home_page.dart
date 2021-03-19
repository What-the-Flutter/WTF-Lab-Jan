import 'package:flutter_bloc/flutter_bloc.dart';
import 'states_home_page.dart';

class CubitHomePage extends Cubit<StatesHomePage> {
  CubitHomePage(StatesHomePage state) : super(state);

  void changeTheme() => emit(state.copyWith(isLightTheme: !state.isLightTheme));

  void removeNote(int index) {
    state.noteList.removeAt(index);
    noteListRedrawing();
  }

  void noteListRedrawing() => emit(state.copyWith(noteList: state.noteList));
}
