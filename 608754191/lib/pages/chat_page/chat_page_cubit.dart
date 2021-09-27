import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wtf/pages/entity/message.dart';
import '../entity/category.dart';

import 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit(
    Category category,
  ) : super(
          ChatPageState(
            eventSelected: true,
            indexOfSelectedElement: 0,
            isEditing: false,
            category: category,
            isSending: false,
          ),
        );

  void changeIndexOfSelectedElement(int index) {
    emit(
      state.copyWith(indexOfSelectedElement: index),
    );
  }

  void swapAppBar() {
    emit(
      state.copyWith(eventSelected: !state.eventSelected),
    );
  }

  void deleteMessage(int index) {
    state.category.listMessages.removeAt(index);
    emit(
      state.copyWith(category: state.category),
    );
  }

  void copyMessages(int index) {
    Clipboard.setData(
      ClipboardData(text: state.category.listMessages[index].text),
    );
    emit(
      state.copyWith(category: state.category),
    );
  }

  void setEditMessage(bool isEditing) {
    emit(
      state.copyWith(isEditing: isEditing),
    );
  }

  void addMessage(Message message) {
    state.category.listMessages.insert(0, message);
    emit(
      state.copyWith(category: state.category),
    );
  }

  void editText(int index, String text) {
    state.category.listMessages[index].text = text;
    emit(
      state.copyWith(category: state.category),
    );
  }

  void setMessageText(int index, String text) {
    state.category.listMessages[index].text = text;
    emit(
      state.copyWith(category: state.category),
    );
  }

  void setSending(bool isSending) {
    emit(
      state.copyWith(isSending: isSending),
    );
  }
}
