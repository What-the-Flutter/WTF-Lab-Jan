import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../../../database/database.dart';

import '../../../../repository/messages_repository.dart';
import '../../../../repository/property_message.dart';
import '../../../../repository/property_page.dart';
import '../message/message_cubit.dart';

part 'list_message_state.dart';

class ListMessageCubit extends Cubit<ListMessageState> {
  final MessagesRepository repository;
  List<MessageCubit> list;
  final DBHelper _dbHelper = DBHelper();

  ListMessageCubit({this.repository, this.list}) : super(ListMessageState());

  void addMessage(int id, String text, DateTime time) {
    repository.addMessage(
      PropertyMessage(
        idMessagePage: id,
        message: text,
        time: time,
        isSelected: false,
      ),
    );
    _dbHelper.insertMessage(
      PropertyMessage(
        message: text,
        time: time,
        isSelected: false,
        idMessagePage: id,
      ),
    );
    emit(ListMessageState());
  }

  void addSearchingMessage(TextEditingController controller) {
    for (var i = 0; i < repository.messages.length; i++) {
      if (list[i].state.message == controller.text) {
        repository.addSearchingMessage(
          PropertyMessage(
            message: list[i].state.message,
            isSelected: false,
          ),
        );
      }
    }
    emit(ListMessageState());
  }

  void addCategoryMessage(
      int id, String text, DateTime time, String category, IconData icon) {
    var message = '$category\n\n$text';
    repository.addMessage(
      PropertyMessage(
        idMessagePage: id,
        message: message,
        time: time,
        isSelected: false,
        icon: icon,
      ),
    );
    _dbHelper.insertMessage(
      PropertyMessage(
        message: message,
        time: DateTime.now(),
        isSelected: false,
        icon: icon,
        idMessagePage: id,
      ),
    );
    emit(ListMessageState());
  }

  void updateMessage(String text) {
    var index = 0;
    for (var i = repository.messages.length - 1; i >= 0; i--) {
      if (list[index].state.isSelected) {
        repository.messages[i].message = text;
        _dbHelper.updateMessage(repository.messages[i]);
      }
      index++;
    }
    emit(ListMessageState());
    for (var cubit in list) {
      if (cubit.state.isSelected) {
        cubit.selected();
      }
    }
  }

  void removeMessage() {
    var index = 0;
    var listMessage = <PropertyMessage>[];
    for (var i = repository.messages.length - 1; i >= 0; i--) {
      if (list[index].state.isSelected) {
        _dbHelper.deleteMessage(repository.messages[i]);
      } else {
        listMessage.add(repository.messages[i]);
      }
      index++;
    }
    repository.messages = listMessage;
    emit(ListMessageState());
    for (var cubit in list) {
      if (cubit.state.isSelected) {
        cubit.selected();
      }
    }
  }

  void edit(TextEditingController controller) {
    var index = 0;
    for (var i = repository.messages.length - 1; i >= 0; i--) {
      if (list[index].state.isSelected) {
        controller.text = repository.messages[i].message;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
      }
      index++;
    }
    emit(ListMessageState());
  }

  void moveMessageAnotherDialog(String dialogName,
      List<PropertyPage> repositoryPages, List<PropertyMessage> listMess) {
    var index = 0;
    for (var i = listMess.length - 1; i >= 0; i--) {
      if (list[index].state.isSelected) {
        for (var j = 0; j < repositoryPages.length; j++) {
          if (repositoryPages[j].title == dialogName) {
            if (list[index].state.icon != null) {
              _dbHelper.deleteMessage(listMess[i]);
              _dbHelper.insertMessage(listMess[i].copyWith(idMessagePage: j));
              listMess.removeAt(i);
            } else {
              _dbHelper.deleteMessage(listMess[i]);
              _dbHelper.insertMessage(listMess[i].copyWith(idMessagePage: j));
              listMess.removeAt(i);
            }
          }
        }
      }
      index++;
    }
    emit(ListMessageState());
  }
}
