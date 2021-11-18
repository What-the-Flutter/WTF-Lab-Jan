import 'dart:async';

import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/util/db_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(HomeState(
          streamChats: DBProvider.db.databaseRef.child('chats').onValue,
        ));

  Future<void> init() async {
    setChatList(<Chat>[]);
  }

  void setChatList(List<Chat> chats) => emit(state.copyWith(chatsList: chats));


  Future<void> updateChatsList(Map<dynamic, dynamic> map) async {
    final Map<dynamic, dynamic> values = map;
    final chatsList = <Chat>[];
    values.forEach((key, value) async {
      final chat = Chat.fromMap(key, value);
      if (chat.isPinned == true) {
        chatsList.insert(0, chat);
      } else {
        chatsList.add(chat);
      }
    });
    setChatList(chatsList);
  }

  Future<void> pinChat(Chat chat) async {
    final curChat = chat;
    curChat.isPinned = !curChat.isPinned!;
    await DBProvider.db.updateChat(curChat);
  }

  Future<void> addChat(Chat chat) async {
    await DBProvider.db.insertChat(chat);
  }

  Future<void> deleteChat(Chat chat) async {
    if(state.chatsList.length == 1) {
      await DBProvider.db.deleteChat(chat);
      await DBProvider.db.deleteAllMessages(chat.id!);
      emit(state.copyWith(chatsList: <Chat>[]));
    } else {
      await DBProvider.db.deleteChat(chat);
      await DBProvider.db.deleteAllMessages(chat.id!);
    }
  }

  Future<void> editChat(Chat chat) async {
    await DBProvider.db.updateChat(chat);
  }
}
