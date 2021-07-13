import 'package:bloc/bloc.dart';

part 'add_page_state.dart';

class AddPageCubit extends Cubit<AddPageState> {
  AddPageCubit() : super(AddPageState(selectedIconIndex: 0));

  void init(int index) {
    setSelectedIconIndex(index);
  }

  void setSelectedIconIndex(int selectedIconIndex) =>
      emit(state.updateSelectedIconIndex(selectedIconIndex));
}
