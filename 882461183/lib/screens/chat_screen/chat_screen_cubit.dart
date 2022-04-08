import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';

import '/data/repository/chat_repository.dart';
import '/models/chat_model.dart';

part 'chat_screen_state.dart';

class ChatScreenCubit extends Cubit<ChatScreenState> {
  final ChatRepository chatRepository;

  ChatScreenCubit(this.chatRepository)
      : super(
          ChatScreenState(
            chatList: [],
          ),
        );

  void initCubit(DatabaseReference chatRef) {
    showChats();
    chatRef.onValue.listen(
      (event) {
        final chatList = <Chat>[];
        final result = event.snapshot.value as Map;
        final list = result.values;
        final finalList = list.toList();
        for (var i = 0; i < finalList.length; i++) {
          final map = Map<String, dynamic>.from(finalList[i]);
          chatList.insert(0, Chat.fromJson(map));
        }
        showChatsFromListen(chatList);
      },
    );
  }

  Future<void> showChats() async {
    final chatList = await chatRepository.fetchChatList();
    emit(state.copyWith(chatList: chatList));
  }

  void showChatsFromListen(List<Chat> chatList) =>
      emit(state.copyWith(chatList: chatList));

  void removeElement(Chat chatElement) {
    chatRepository.deleteChat(chatElement);
    emit(state.copyWith(chatList: state.chatList));
  }

  void sortList(List<Chat> chat) => chat.sort((a, b) => b.isPinned ? 1 : -1);

  void pinUnpinChat(Chat chat) {
    final chatList = state.chatList;
    for (var i = 0; i < chatList.length; i++) {
      if (chat.id == chatList[i].id) {
        chat = chatList[i].copyWith(isPinned: !state.chatList[i].isPinned);
        chatList[i] = chat;
        break;
      }
    }

    emit(state.copyWith(chatList: chatList));
    chatRepository.updateChat(chat);
  }

  void newSubname(int i, String newSubName) {
    state.chatList[i] = state.chatList[i].copyWith(elementSubname: newSubName);
    emit(state.copyWith(chatList: state.chatList));
    chatRepository.updateChat(state.chatList[i]);
  }
}
