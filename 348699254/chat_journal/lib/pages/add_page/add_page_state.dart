class PageState {
  final List pageList;
  final int selectedIconIndex;

  PageState({
    required this.pageList,
    required this.selectedIconIndex,
  });

  PageState copyWith({
    List? pageList,
    int? selectedIconIndex,
  }) {
    return PageState(
      pageList: pageList ?? this.pageList,
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
    );
  }
}