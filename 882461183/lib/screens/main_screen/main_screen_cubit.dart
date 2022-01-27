import 'package:bloc/bloc.dart';

import '/models/chat_model.dart';
import '../../database.dart';

part 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit()
      : super(
          MainScreenState(
            selectedTab: 0,
            chatList: [],
          ),
        );

  Stream<List> showChats() async* {
    final chatList = await DatabaseHelper.db.fetchChatList();
    emit(state.copyWith(chatList: chatList));

    yield chatList;
  }

  void removeElement(Chat chatElement) {
    DatabaseHelper.db.deleteChat(chatElement);

    state.chatList.remove(chatElement);
    emit(state.copyWith(chatList: state.chatList));
  }

  void sortList(List<Chat> chat) {
    chat.sort((a, b) => b.isPinned ? 1 : -1);
  }

  void pinUnpinChat(Chat chat) {
    for (var i = 0; i < state.chatList.length; i++) {
      if (chat.id == state.chatList[i].id) {
        chat =
            state.chatList[i].copyWith(isPinned: !state.chatList[i].isPinned);
        state.chatList[i] = chat;
      }
    }

    emit(state.copyWith(chatList: state.chatList));
    DatabaseHelper.db.updateChat(chat);
  }

  void newSubname(int i, String newSubName) {
    state.chatList[i] = state.chatList[i].copyWith(elementSubname: newSubName);
    emit(state.copyWith(chatList: state.chatList));

    DatabaseHelper.db.updateChat(state.chatList[i]);
  }

  void selectTab(int i) {
    if (state.selectedTab == i) {
      emit(state);
    } else {
      emit(state.copyWith(selectedTab: i));
    }
  }
}
