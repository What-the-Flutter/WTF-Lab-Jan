import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_label_state.dart';

class AddLabelCubit extends Cubit<AddLabelState> {
  AddLabelCubit(AddLabelState state) : super(state);

  void updateAllowance(String text) =>
    emit(state.copyWith(isAllowedToSave: text.isNotEmpty));

  void changeIcon(int iconIndex) =>
    emit(state.copyWith(selectedIconIndex: iconIndex));
}