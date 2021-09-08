class CreatePageState{
  int? selectedIcon;

  CreatePageState({this.selectedIcon});

  CreatePageState copyWith({int? index}) {
    return CreatePageState(
      selectedIcon: index ?? selectedIcon,
    );
  }
}