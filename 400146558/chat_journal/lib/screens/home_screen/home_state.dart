import 'package:chat_journal/models/chat_model.dart';

class HomeState {
  final List<Chat> chatsList;

  HomeState({
    this.chatsList = const [],
  });

  HomeState copyWith({
    List<Chat>? chatsList,
  }) {
    return HomeState(
      chatsList: chatsList ?? this.chatsList,
    );
  }
}
