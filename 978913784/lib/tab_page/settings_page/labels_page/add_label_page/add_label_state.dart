class AddLabelState {
  final int selectedIconIndex;
  final bool isAllowedToSave;

  AddLabelState(this.selectedIconIndex, this.isAllowedToSave);

  AddLabelState copyWith({
    int selectedIconIndex,
    bool isAllowedToSave,
  }) =>
      AddLabelState(
        selectedIconIndex ?? this.selectedIconIndex,
        isAllowedToSave ?? this.isAllowedToSave,
      );
}
