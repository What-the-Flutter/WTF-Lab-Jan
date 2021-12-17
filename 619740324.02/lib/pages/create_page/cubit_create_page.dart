import 'package:flutter_bloc/flutter_bloc.dart';
import 'states_create_page.dart';

class CubitCreatePage extends Cubit<StatesCreatePage> {
  CubitCreatePage() : super(StatesCreatePage());

  void setSelectedIndex(int selectedIndex) =>
      emit(state.copyWith(selectedIndex: selectedIndex));

  void setWriting(bool isWriting) => emit(state.copyWith(isWriting: isWriting));

  void setEditing(bool isEditing) => emit(state.copyWith(isEditing: isEditing));
}
