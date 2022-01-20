import 'package:bloc/bloc.dart';

import '/models/chat_model.dart';

part 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit()
      : super(
          MainScreenState(
            selectedTab: 0,
            chatList: chatList,
          ),
        );

  void removeElement(Chat chatElement) {
    chatList.remove(chatElement);
    emit(state.copyWith(chatList: chatList));
  }

  void addElement(Chat chatElement) {
    chatList.insert(0, chatElement);
    emit(state.copyWith(chatList: chatList));
  }

  void sortList(List<Chat> chat) {
    chat.sort((a, b) => b.isPinned ? 1 : -1);
  }

  void pinUnpinChat(int index) {
    chatList[index] =
        chatList[index].copyWith(isPinned: !chatList[index].isPinned);
    var chat = chatList;
    sortList(chat);

    if (chatList[index].isPinned) {
      emit(state.copyWith(chatList: chat));
    } else {
      emit(state.copyWith(chatList: chat));
    }
  }

  void newSubname(int i, String newSubName) {
    chatList[i] = chatList[i].copyWith(elementSubname: newSubName);
    emit(state.copyWith(chatList: chatList));
  }

  void selectTab(int i) {
    if (state.selectedTab == i) {
      emit(state);
    } else {
      emit(state.copyWith(selectedTab: i));
    }
  }

  void editChat(Chat result) {
    for (var i = 0; i <= chatList.length - 1; i++) {
      if (chatList[i].key == result.key) {
        chatList[i] = result;
        emit(state.copyWith(chatList: chatList));
        break;
      }
    }
  }
}
