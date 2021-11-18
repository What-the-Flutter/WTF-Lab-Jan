class AddLabelState {
  final int selectedIconIndex;
  final List labels;
  final bool isColorChanged;

  AddLabelState({
    required this.labels,
    required this.selectedIconIndex,
    required this.isColorChanged,
  });

  AddLabelState copyWith({
    List? labels,
    int? selectedIconIndex,
    bool? isColorChanged,
  }) {
    return AddLabelState(
      labels: labels ?? this.labels,
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
      isColorChanged: isColorChanged ?? this.isColorChanged,
    );
  }
}
