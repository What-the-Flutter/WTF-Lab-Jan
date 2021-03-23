import 'package:flutter_bloc/flutter_bloc.dart';
import 'states_create_page.dart';

class CubitCreatePage extends Cubit<StatesCreatePage> {
  CubitCreatePage(StatesCreatePage state) : super(state);

  void setSelectedIconIndex(int selectedIconIndex) =>
      emit(state.copyWith(selectedIconIndex: selectedIconIndex));
}
