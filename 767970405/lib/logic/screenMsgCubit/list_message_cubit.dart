import 'package:bloc/bloc.dart';

import '../../repository/messages_repository.dart';
import '../../repository/property_message.dart';
import 'message_cubit.dart';

part 'list_message_state.dart';

class ListMessageCubit extends Cubit<ListMessageState> {
  final MessagesRepository repository;
  final List<MessageCubit> list;

  ListMessageCubit({
    this.repository,
    this.list,
  }) : super(ListMessageState(isBookmark: false));

  void onChangeList() {
    emit(ListMessageState(isBookmark: !state.isBookmark));
  }

  void addMessage(String text) {
    repository.addMessage(PropertyMessage(
      message: text,
      isFavor: false,
      isSelected: false,
    ));
    emit(ListMessageState(
      isBookmark: state.isBookmark,
    ));
  }

  void remove() {
    var index = 0;
    for (var i = 0; i < repository.messages.length; i++) {
      if (list[index].state.isSelected) {
        list[index].edit(repository.messages[i].message, false);
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
    emit(ListMessageState(isBookmark: state.isBookmark));
  }
}
