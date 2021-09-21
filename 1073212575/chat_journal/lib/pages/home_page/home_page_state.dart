class HomePageState {
  final bool isSelected;
  final int selectedPageIndex;

  HomePageState({
    required this.isSelected,
    required this.selectedPageIndex,
  });

  HomePageState copyWith({bool? isSelected, int? selectedPageIndex}) {
    return HomePageState(
      isSelected: isSelected ?? this.isSelected,
      selectedPageIndex: selectedPageIndex ?? this.selectedPageIndex,
    );
  }
}
