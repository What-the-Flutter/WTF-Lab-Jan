part of 'main_screen_cubit.dart';

class MainScreenState {
  final int selectedTab;
  final List<Chat> chatList;

  MainScreenState({
    required this.selectedTab,
    required this.chatList,
  });

  MainScreenState copyWith({
    int? selectedTab,
    List<Chat>? chatList,
  }) {
    return MainScreenState(
      selectedTab: selectedTab ?? this.selectedTab,
      chatList: chatList ?? this.chatList,
    );
  }
}
