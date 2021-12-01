class AddPageState {
  final List pageList;
  final int selectedIconIndex;

  AddPageState({
    required this.pageList,
    required this.selectedIconIndex,
  });

  AddPageState copyWith({
    List? pageList,
    int? selectedIconIndex,
  }) {
    return AddPageState(
      pageList: pageList ?? this.pageList,
      selectedIconIndex: selectedIconIndex ?? this.selectedIconIndex,
    );
  }
}
