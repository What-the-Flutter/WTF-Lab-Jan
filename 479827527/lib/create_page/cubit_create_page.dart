import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'states_create_page.dart';

class CubitCreatePage extends Cubit<StatesCreatePage> {
  CubitCreatePage(StatesCreatePage state) : super(state);

  void setSelectedIcon(IconData selectedIcon) =>
      emit(state.copyWith(selectedIcon: selectedIcon));
}
