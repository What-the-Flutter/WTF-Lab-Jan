import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_chat_journal/data/repository/messages_repository.dart';
import '../data/model/model_message.dart';

part 'search_message_screen_state.dart';

class SearchMessageScreenCubit extends Cubit<SearchMessageScreenState> {
  final controller = TextEditingController();
  final MessagesRepository repository;

  SearchMessageScreenCubit({
    this.repository,
  }) : super(SearchMessageScreenWait()) {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        emit(SearchMessageScreenWait());
      } else {
        searchMessages();
      }
    });
  }

  @override
  Future<Function> close() {
    controller.dispose();
    return super.close();
  }

  void searchMessages() {
    var substring = controller.text;
    var list = <ModelMessage>[];
    // for (var i = 0; i < repository.messages.length; i++) {
    //   if (repository.messages[i].data.contains(substring)) {
    //     list.add(repository.messages[i]);
    //   }
    // }
    if (list.isEmpty) {
      emit(SearchMessageScreenNotFound());
    } else {
      emit(SearchMessageScreenFound(list: list));
    }
  }

  void resetController() {
    controller.text = '';
  }
}
