class AddPageState {
  final int selectedIconIndex;

  AddPageState({
    required this.selectedIconIndex,
  });

  AddPageState copyWith({
    int? selectedIconIndex,
  }) {
    return AddPageState(
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
    );
  }
}
