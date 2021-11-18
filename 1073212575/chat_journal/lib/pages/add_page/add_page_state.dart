class AddPageState {
  final int selectedIconIndex;
  final List eventPages;
  final bool isColorChanged;

  AddPageState({
    required this.eventPages,
    required this.selectedIconIndex,
    required this.isColorChanged,
  });

  AddPageState copyWith({
    List? eventPages,
    int? selectedIconIndex,
    bool? isColorChanged,
  }) {
    return AddPageState(
      eventPages: eventPages ?? this.eventPages,
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
      isColorChanged: isColorChanged ?? this.isColorChanged,
    );
  }
}
