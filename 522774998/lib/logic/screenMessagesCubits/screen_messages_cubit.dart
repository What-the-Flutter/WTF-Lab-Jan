import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../repository/messages_repository.dart';
import 'message_cubit.dart';

part 'screen_messages_state.dart';

class ScreenMessagesCubit extends Cubit<ScreenMessagesState> {
  final MessagesRepository repository;
  final String title;
  final List<MessageCubit> list = <MessageCubit>[];

  ScreenMessagesCubit({
    this.repository,
    this.title,
  }) : super(ScreenMessagesState());

  void unSelectionMsg() {
    for (var cubit in list) {
      if (cubit.state.isSelected) {
        cubit.selected();
      }
    }
  }

  void updateList() {
    var index = 0;
    for (var i = repository.messages.length - 1; i > 0; i--) {
      list[index].edit(repository.messages[i].message);
      index++;
    }
  }

  void updateOnTap(bool isNull) {
    for (var i = 0; i < list.length; i++) {
      list[i].update(isNull);
    }
  }

  void copy() {
    var clipBoard = '';
    for (var i = 0; i < repository.messages.length; i++) {
      if (list[i].state.isSelected) {
        clipBoard += list[i].state.message;
        clipBoard += ' ';
      }
    }
    Clipboard.setData(ClipboardData(text: clipBoard));
    unSelectionMsg();
  }

  void edit(TextEditingController controller) {
    var index = 0;
    for (var i = 0; i < repository.messages.length; i++) {
      if (list[i].state.isSelected) {
        index = i;
      }
    }
    controller.text = repository.messages[index].message;
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }

  void update(TextEditingController controller) {
    var index = 0;
    for (var i = 0; i < repository.messages.length; i++) {
      if (list[i].state.isSelected) {
        index = i;
      }
    }
    repository.messages[index].message = controller.text;
  }
}
