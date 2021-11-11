class HomePageState {
  final bool isColorChanged;
  final bool isSelected;
  final int selectedPageIndex;
  final List eventPages;

  HomePageState({
    required this.isColorChanged,
    required this.isSelected,
    required this.selectedPageIndex,
    required this.eventPages,
  });

  HomePageState copyWith({
    bool? isColorChanged,
    bool? isSelected,
    int? selectedPageIndex,
    List? eventPages,
  }) {
    return HomePageState(
      isColorChanged: isColorChanged ?? this.isColorChanged,
      isSelected: isSelected ?? this.isSelected,
      selectedPageIndex: selectedPageIndex ?? this.selectedPageIndex,
      eventPages: eventPages ?? this.eventPages,
    );
  }
}
