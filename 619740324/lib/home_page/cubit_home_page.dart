import 'package:flutter_bloc/flutter_bloc.dart';

import 'states_home_page.dart';

class CubitHomePage extends Cubit<StatesHomePage> {
  CubitHomePage(state) : super(state);

  void redrawingList() =>
      emit(state.copyWith(noteList: state.noteList));

}