import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../entity/label.dart';
import 'add_label_state.dart';

class AddLabelCubit extends Cubit<AddLabelState> {
  AddLabelCubit(AddLabelState state) : super(state);

  void updateAllowance(bool isNotEmpty) =>
      emit(state.copyWith(isAllowedToSave: isNotEmpty));

  void changeIcon(int iconIndex) =>
      emit(state.copyWith(selectedIconIndex: iconIndex));

  void selectLabel(Label label) => emit(
        state.copyWith(
          selectedIconIndex: label.iconIndex,
          isAllowedToSave: label.description.isNotEmpty,
          label: state.label..id = label.id,
        ),
      );

  void updateLabel(String description, int iconId) => emit(state.copyWith(
        label: state.label
          ..description = description
          ..iconIndex = iconId,
      ));
}
