import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '/models/chat_model.dart';
import '../../database.dart';

part 'add_new_screen_state.dart';

class AddNewChatCubit extends Cubit<AddNewChatState> {
  AddNewChatCubit() : super(AddNewChatState(selectedIconIndex: 0));

  void initState({
    required int selectedIconIndex,
    required bool isTextFieldEmpty,
  }) async =>
      emit(
        AddNewChatState(
          selectedIconIndex: selectedIconIndex,
          isTextFieldEmpty: isTextFieldEmpty,
          chatList: await DatabaseHelper.db.fetchChatList(),
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

  Future<void> addChat(String text, List iconList) async {
    final chat = Chat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      elementName: text,
      creationDate: DateTime.now(),
      icon: iconList[state.selectedIconIndex],
    );
    await DatabaseHelper.db.insertChat(chat);
  }

  void editChat(Chat elementChat, String text, List iconList) {
    late final Chat chat;
    for (var element in state.chatList) {
      if (element.id == elementChat.id) {
        chat = element.copyWith(
          elementName: text,
          icon: iconList[state.selectedIconIndex],
        );
      }
    }

    DatabaseHelper.db.updateChat(chat);
  }
}
