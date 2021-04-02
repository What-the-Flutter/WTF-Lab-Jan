import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../properties/property_message.dart';
import '../../properties/property_page.dart';
import '../../repository/messages_repository.dart';

part 'searching_messages_state.dart';

class SearchMessageCubit extends Cubit<SearchMessageState> {
  final controller = TextEditingController();
  final MessagesRepository repository;

  SearchMessageCubit({this.repository})
      : super(
          SearchMessageScreenWait(),
        ) {
    controller.addListener(
      () {
        if (controller.text.isEmpty) {
          emit(SearchMessageScreenWait(page: state.page));
        } else {
          searchMessages();
        }
      },
    );
  }

  void searchMessages() async {
    var substring = controller.text;
    var list = <PropertyMessage>[];
    var repList = await repository.messages(state.page.id);
    for (var i = 0; i < repList.length; i++) {
      if (repList[i].data.contains(substring)) {
        list.add(repList[i]);
      }
    }
    if (list.isEmpty) {
      emit(
        SearchMessageScreenNotFound(page: state.page),
      );
    } else {
      emit(
        SearchMessageScreenFound(list: list, page: state.page),
      );
    }
  }

  void resetController() {
    controller.text = '';
  }

  void setting({PropertyPage page}) {
    emit(state.copyWith(page: page));
  }

  @override
  Future<Function> close() {
    controller.dispose();
    return super.close();
  }
}
