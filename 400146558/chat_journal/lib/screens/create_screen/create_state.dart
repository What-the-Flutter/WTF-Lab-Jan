import 'package:chat_journal/models/chaticon_model.dart';

class CreatePageState {
  final List<ChatIcon> iconsList;
  final ChatIcon? selectedChatIcon;

  CreatePageState({
    this.iconsList = const [],
    this.selectedChatIcon,
  });

  CreatePageState copyWith({
    List<ChatIcon>? iconsList,
    ChatIcon? selectedChatIcon,
  }) {
    return CreatePageState(
      iconsList: iconsList ?? this.iconsList,
      selectedChatIcon: selectedChatIcon ?? this.selectedChatIcon,
    );
  }
}
