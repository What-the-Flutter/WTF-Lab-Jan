import 'package:bloc/bloc.dart';
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

  void makeFavor() {
    var index = repository.messages.length - 1;
    for (var cubit in list) {
      if (cubit.state.isSelected) {
        repository.messages[index] =
            repository.messages[index].copyWith(isFavor: !cubit.state.isFavor);
        cubit.makeFavor(!cubit.state.isFavor);
      }
      index--;
    }
    unSelectionMsg();
  }

  void updateList() {
    var index = 0;
    for (var i = repository.messages.length - 1; i > 0; i--) {
      list[index]
          .edit(repository.messages[i].message, repository.messages[i].isFavor);
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
      }
    }
    Clipboard.setData(ClipboardData(text: clipBoard));
    unSelectionMsg();
  }
}
