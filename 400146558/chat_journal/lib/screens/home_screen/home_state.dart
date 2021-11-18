import 'dart:async';
import 'package:chat_journal/models/chat_model.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeState {
  final List<Chat> chatsList;
  final Stream<Event> streamChats;

  HomeState({
    this.chatsList = const [],
    required this.streamChats,
  });

  HomeState copyWith({
    List<Chat>? chatsList,
    Stream<Event>? streamChats,
    Query? chats,
  }) {
    return HomeState(
      chatsList: chatsList ?? this.chatsList,
      streamChats: streamChats ?? this.streamChats,
    );
  }
}
