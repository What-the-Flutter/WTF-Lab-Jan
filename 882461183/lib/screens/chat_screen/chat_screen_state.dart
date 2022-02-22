part of 'chat_screen_cubit.dart';

class ChatScreenState {
  final List<Chat> chatList;

  ChatScreenState({
    required this.chatList,
  });

  ChatScreenState copyWith({
    List<Chat>? chatList,
  }) {
    return ChatScreenState(
      chatList: chatList ?? this.chatList,
    );
  }
}
