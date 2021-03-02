import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import '../repository/property_message.dart';

part 'screen_messages_state.dart';

class ScreenMessagesCubit extends Cubit<ScreenMessagesState> {
  final List<PropertyMessage> messages;
  final controller = TextEditingController();

  ScreenMessagesCubit({this.messages}) : super(ScreenMessagesInput());

  void addMessage() {
    messages.add(
      PropertyMessage(
        message: controller.text,
      ),
    );
    controller.text = '';
    emit(ScreenMessagesInput());
  }

  void updateMsg() {
    var index = -1;
    for (var i = 0; i < messages.length; i++) {
      if (messages[i].isSelected) {
        index = i;
        break;
      }
    }
    messages[index] = messages[index].copyWith(
      message: controller.text,
      isSelected: false,
    );
    controller.text = '';
    emit(ScreenMessagesInput());
  }

  void removeMsg() {
    for (var i = 0; i < messages.length; i++) {
      if (messages[i].isSelected) {
        messages.removeAt(i);
        i--;
      }
    }
    emit(ScreenMessagesInput());
  }

  void changeBookmarkMessage(int index) {
    messages[index] = messages[index].copyWith(isFavor: !messages[index].isFavor);
    emit(ScreenMessagesInput());
  }

  void changeStateListItem(int index) {
    if (messages[index].isSelected) {
      messages[index] = messages[index].copyWith(isSelected: false);
      if (state.countDeletedMsg - 1 == 0) {
        emit(ScreenMessagesInput());
      } else {
        emit(
            ScreenMessagesSelected(countDeletedMsg: state.countDeletedMsg - 1));
      }
    } else {
      messages[index] = messages[index].copyWith(isSelected: true);
      emit(ScreenMessagesSelected(countDeletedMsg: state.countDeletedMsg + 1));
    }
  }

  void changeState(int index) {
    messages[index] = messages[index].copyWith(isSelected: true);
    emit(ScreenMessagesSelected(
        isBookmark: false, countDeletedMsg: state.countDeletedMsg + 1));
  }

  void changePresentationList(bool isBookmark) {
    emit(ScreenMessagesInput(isBookmark: isBookmark));
  }

  void changeMode() {
    emit(ScreenMessagesSelected(countDeletedMsg: state.countDeletedMsg));
  }

  void changeModeForEdit() {
    var index = -1;
    for (var i = 0; i < messages.length; i++) {
      if (messages[i].isSelected) {
        index = i;
        break;
      }
    }
    controller.text = messages[index].message;
    emit(ScreenMessagesEdit());
  }

  void createBuffer() {
    var clipBoard = '';
    for (var i = 0; i < messages.length; i++) {
      if (messages[i].isSelected) {
        clipBoard += messages[i].message;
        messages[i] = messages[i].copyWith(isSelected: false);
      }
    }
    Clipboard.setData(ClipboardData(text: clipBoard));
    emit(ScreenMessagesInput());
  }

  void removeMessages() {
    for (var i = 0; i < messages.length; i++) {
      if (messages[i].isSelected) {
        messages.removeAt(i);
        i--;
      }
    }
    emit(ScreenMessagesInput());
  }

  void resetMode() {
    for (var i = 0; i < messages.length; i++) {
      if (messages[i].isSelected) {
        messages[i] = messages[i].copyWith(isSelected: false);
      }
    }
    emit(ScreenMessagesInput());
  }
}
