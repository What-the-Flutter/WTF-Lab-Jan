import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/util/db_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  Future<void> init() async {
    emit(
      state.copyWith(chatsList: <Chat>[]),
    );
    emit(
      state.copyWith(chatsList: await DBProvider.db.fetchChatsList()),
    );
  }

  Future<void> updateChatsList() async {
    emit(state.copyWith(chatsList: await DBProvider.db.fetchChatsList()));
  }

  Future<void> pinChat(Chat chat) async {
    final curChat = chat;
    curChat.isPinned = !curChat.isPinned!;
    await DBProvider.db.updateChat(curChat);
    updateChatsList();
  }

  Future<void> addChat(Chat chat) async {
    await DBProvider.db.insertChat(chat);
    updateChatsList();
  }

  Future<void> deleteChat(Chat chat) async {
    await DBProvider.db.deleteChat(chat);
    updateChatsList();
  }

  Future<void> editChat(Chat chat) async {
    await DBProvider.db.updateChat(chat);
    updateChatsList();
  }
}
