class MainPageState {
  final List activityPageList;
  final bool isSelected;
  final bool isPinned;
  final int selectedPageIndex;

  MainPageState({
    required this.activityPageList,
    required this.isSelected,
    required this.selectedPageIndex,
    required this.isPinned,
  });

  MainPageState copyWith({
    List? activityPageList,
    bool? isColorChanged,
    bool? isSelected,
    bool? isPinned,
    int? selectedPageIndex,
  }) {
    return MainPageState(
      activityPageList: activityPageList ?? this.activityPageList,
      isSelected: isSelected ?? this.isSelected,
      isPinned: isPinned ?? this.isPinned,
      selectedPageIndex: selectedPageIndex ?? this.selectedPageIndex,
    );
  }
}