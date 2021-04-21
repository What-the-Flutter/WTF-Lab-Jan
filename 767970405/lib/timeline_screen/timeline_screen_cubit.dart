import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/constants/constants.dart';
import '../data/extension.dart';
import '../data/model/model_message.dart';
import '../data/model/search_item_data.dart';
import '../data/repository/messages_repository.dart';

part 'timeline_screen_state.dart';

class TimelineScreenCubit extends Cubit<TimelineScreenState> {
  final MessagesRepository repository;

  TimelineScreenCubit({
    this.repository,
  }) : super(
    TimelineScreenState(
      list: <ModelMessage>[],
      modeFilter: ModeFilter.wait,
      isBookmark: false,
    ),
  );

  void configureList({
    List<SearchItemData> selectedPages,
    List<SearchItemData> selectedTags,
    List<SearchItemData> selectedLabel,
  }) async {
    var listMsg = await repository.messages();
    if (selectedPages.isNotEmpty) {
      listMsg = listMsg.where((element) {
        for (var i = 0; i < selectedPages.length; i++) {
          if (selectedPages[i].id == element.pageId) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    if (selectedTags.isNotEmpty) {
      listMsg = listMsg.where((element) {
        var words = element.text.split(' ');
        for (var i = 0; i < selectedTags.length; i++) {
          if (words.contains(selectedTags[i].name)) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    if (selectedLabel.isNotEmpty) {
      listMsg = listMsg.where((element) {
        for (var i = 0; i < selectedLabel.length; i++) {
          if (element.indexCategory == selectedLabel[i].id) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    emit(state.copyWith(list: listMsg, modeFilter: ModeFilter.complete));
  }

  void changeMode() {
    emit(state.copyWith(modeFilter: ModeFilter.wait));
  }

  void changeDisplayList() {
    emit(state.copyWith(isBookmark: !state.isBookmark));
  }

  List<List<ModelMessage>> get groupMsgByDate {
    var list = <List<ModelMessage>>[];
    var temp = <ModelMessage>[];
    if (state.list.length == 1) {
      temp.add(state.list[0]);
      list.add(List.from(temp));
      return list;
    }
    for (var i = 0; i < state.list.length - 1; i++) {
      temp.add(state.list[i]);
      if (!state.list[i].pubTime.isSameDateByDay(state.list[i + 1].pubTime)) {
        list.add(List.from(temp));
        temp = <ModelMessage>[];
      }
    }
    if (state.list.isNotEmpty) {
      temp.add(state.list[state.list.length - 1]);
      list.add(List.from(temp));
    }
    return list;
  }
}
