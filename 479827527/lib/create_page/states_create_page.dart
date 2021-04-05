class StatesCreatePage {
  final int selectedIconIndex;

  const StatesCreatePage({this.selectedIconIndex});

  StatesCreatePage updateSelectedIconIndex(final int selectedIconIndex) =>
      StatesCreatePage(selectedIconIndex: selectedIconIndex);
}
