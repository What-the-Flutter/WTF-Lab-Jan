import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_new_screen_state.dart';

class AddNewChatCubit extends Cubit<AddNewChatState> {
  AddNewChatCubit() : super(AddNewChatState(selectedIconIndex: 0));

  void initState({
    required int selectedIconIndex,
    required bool isTextFieldEmpty,
  }) =>
      emit(
        AddNewChatState(
          selectedIconIndex: selectedIconIndex,
          isTextFieldEmpty: isTextFieldEmpty,
        ),
      );

  void selectIcon(int index) => emit(state.copyWith(selectedIconIndex: index));

  void isTextFieldEmpty(bool isTextFieldEmpty) => emit(
        state.copyWith(isTextFieldEmpty: isTextFieldEmpty),
      );
}
