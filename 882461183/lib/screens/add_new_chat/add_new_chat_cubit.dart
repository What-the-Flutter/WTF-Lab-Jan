import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '/data/services/firebase_database.dart';
import '/icons.dart';
import '/models/chat_model.dart';

part 'add_new_chat_state.dart';

class AddNewChatCubit extends Cubit<AddNewChatState> {
  AddNewChatCubit() : super(AddNewChatState(selectedIconIndex: 0));
  final FBDatabase db = FBDatabase();

  void init({
    required int selectedIconIndex,
    required bool isTextFieldEmpty,
  }) async =>
      emit(
        AddNewChatState(
          selectedIconIndex: selectedIconIndex,
          isTextFieldEmpty: isTextFieldEmpty,
          chatList: await db.fetchChatList(),
        ),
      );

  void selectIcon(int index) => emit(state.copyWith(selectedIconIndex: index));

  void isTextFieldEmpty(String value, TextEditingController controller) {
    if (controller.text.isEmpty) {
      emit(
        state.copyWith(isTextFieldEmpty: true),
      );
    } else {
      emit(
        state.copyWith(isTextFieldEmpty: false),
      );
    }
  }

  void addCategory(String text) {
    if (!categoriesMap.containsKey(text)) {
      categoriesMap[text] = iconsData[state.selectedIconIndex];
    }
  }

  Future<void> addChat(String text) async {
    final chat = Chat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      elementName: text,
      creationDate: DateTime.now(),
      iconIndex: state.selectedIconIndex,
    );
    await db.insertChat(chat);
  }

  Future<void> editChat(Chat elementChat, String text) async {
    late final Chat chat;
    for (var element in state.chatList) {
      if (element.id == elementChat.id) {
        chat = element.copyWith(
          elementName: text,
          iconIndex: state.selectedIconIndex,
        );
      }
    }

    await db.updateChat(chat);
  }
}
