class HomePageState {
  final bool isSelected;
  final int selectedPageIndex;
  final List eventPages;

  HomePageState({
    required this.isSelected,
    required this.selectedPageIndex,
    required this.eventPages,
  });

  HomePageState copyWith({
    bool? isSelected,
    int? selectedPageIndex,
    List? eventPages,
  }) {
    return HomePageState(
      isSelected: isSelected ?? this.isSelected,
      selectedPageIndex: selectedPageIndex ?? this.selectedPageIndex,
      eventPages: eventPages ?? this.eventPages,
    );
  }
}
