class CreatePageState {
  final List<String> iconsList;
  final String? selectedChatIcon;

  CreatePageState({
    this.iconsList = const [],
    this.selectedChatIcon,
  });

  CreatePageState copyWith({
    List<String>? iconsList,
    String? selectedChatIcon,
  }) {
    return CreatePageState(
      iconsList: iconsList ?? this.iconsList,
      selectedChatIcon: selectedChatIcon ?? this.selectedChatIcon,
    );
  }
}
