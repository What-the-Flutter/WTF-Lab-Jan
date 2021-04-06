import '../../../../entity/label.dart';

class AddLabelState {
  final int selectedIconIndex;
  final bool isAllowedToSave;
  final Label label;

  AddLabelState(this.selectedIconIndex, this.isAllowedToSave, this.label);

  AddLabelState copyWith({
    int selectedIconIndex,
    bool isAllowedToSave,
    Label label,
  }) {
   return AddLabelState(
      selectedIconIndex ?? this.selectedIconIndex,
      isAllowedToSave ?? this.isAllowedToSave,
      label ?? this.label,
    );
  }
}
