class AddPageState {
  final int selectedIconIndex;
  final List eventPages;

  AddPageState({
    required this.eventPages,
    required this.selectedIconIndex,
  });

  AddPageState copyWith({
    List? eventPages,
    int? selectedIconIndex,
  }) {
    return AddPageState(
      eventPages: eventPages ?? this.eventPages,
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
    );
  }
}
