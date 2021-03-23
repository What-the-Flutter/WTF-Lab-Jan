class StatesCreatePage {
  int selectedIconIndex;

  StatesCreatePage(this.selectedIconIndex);

  StatesCreatePage copyWith({
    int selectedIconIndex,
  }) {
    var state = StatesCreatePage(selectedIconIndex ?? this.selectedIconIndex);
    return state;
  }
}
