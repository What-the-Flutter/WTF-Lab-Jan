import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../data/model/model_message.dart';
import '../data/model/model_page.dart';
import '../data/repository/messages_repository.dart';

part 'search_message_screen_state.dart';

class SearchMessageScreenCubit extends Cubit<SearchMessageScreenState> {
  final controller = TextEditingController();
  final MessagesRepository repository;

  SearchMessageScreenCubit({
    this.repository,
  }) : super(SearchMessageScreenWait()) {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        emit(SearchMessageScreenWait(page: state.page));
      } else {
        searchMessages();
      }
    });
  }

  @override
  Future<Function> close() async {
    controller.dispose();
    super.close();
  }

  void searchMessages() async {
    var substring = controller.text;
    var list = <ModelMessage>[];
    var repList = await repository.messages(state.page.id);
    for (var i = 0; i < repList.length; i++) {
      if (repList[i].data.contains(substring)) {
        list.add(repList[i]);
      }
    }
    if (list.isEmpty) {
      emit(SearchMessageScreenNotFound(page: state.page));
    } else {
      emit(SearchMessageScreenFound(list: list, page: state.page));
    }
  }

  void resetController() {
    controller.text = '';
  }

  void setting({ModelPage page}) {
    emit(state.copyWith(page: page));
  }
}
