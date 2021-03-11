import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../repository/messages_repository.dart';
import '../../repository/property_message.dart';
import '../../repository/property_page.dart';
import 'message_cubit.dart';

part 'list_message_state.dart';

class ListMessageCubit extends Cubit<ListMessageState> {
  final MessagesRepository repository;
  final List<MessageCubit> list;

  ListMessageCubit({
    this.repository,
    this.list,
  }) : super(ListMessageState());

  void addMessage(String text) {
    repository.addMessage(PropertyMessage(
      message: text,
      isSelected: false,
    ));
    emit(ListMessageState());
  }

  void addSearchingMessage(TextEditingController controller) {
    for (var i = 0; i < repository.messages.length; i++) {
      if (list[i].state.message == controller.text) {
        repository.addSearchingMessage(PropertyMessage(
          message: list[i].state.message,
          isSelected: false,
        ));
      }
    }
    emit(ListMessageState());
  }

  void addCategoryMessage(String text, String category, IconData icon) {
    var message = '$category\n\n$text';
    repository.addMessage(PropertyMessage(
      message: message,
      isSelected: false,
      icon: icon,
    ));
    emit(ListMessageState());
  }

  void updateMessage(String text) {
    var index = 0;
    for (var i = 0; i < repository.messages.length; i++) {
      if (list[i].state.isSelected) {
        index = i;
      }
    }
    repository.messages[index].message = text;
    emit(ListMessageState());
  }

  void removeMessage() {
    var index = 0;
    for (var i = 0; i < repository.messages.length; i++) {
      if (list[index].state.isSelected) {
        list[index].edit(repository.messages[i].message);
        repository.messages.removeAt(i);
        i--;
      }
      index++;
    }
    for (var cubit in list) {
      if (cubit.state.isSelected) {
        cubit.selected();
      }
    }
    emit(ListMessageState());
  }

  void moveMessageAnotherDialog(
      String dialogName, List<PropertyPage> repositoryPages) {
    for (var i = 0; i < repository.messages.length; i++) {
      if (list[i].state.isSelected) {
        for (var j = 0; j < repositoryPages.length; j++) {
          if (repositoryPages[j].title == dialogName) {
            repositoryPages[j]
                .messages
                .addMessage(PropertyMessage(message: list[i].state.message));
          }
        }
      }
    }
    emit(ListMessageState());
  }
}
