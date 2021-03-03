import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_state.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit(EditState state) : super(state);

 void changeIcon(int iconIndex) {
    final updatedState = state.copyWith(page: state.page.copyWith(iconIndex: iconIndex));
    emit(updatedState);
  }

  void updateAllowance(bool isAllowedToSave) {
    final updatedState = state.copyWith(isAllowedToSave: isAllowedToSave);
    emit(updatedState);
  }

  void renamePage(String name) {
   emit(state.copyWith(page: state.page.copyWith(title: name)));
  }
}