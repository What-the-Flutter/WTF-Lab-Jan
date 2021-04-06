import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../properties/property_message.dart';
import '../../properties/property_page.dart';
import '../../repository/messages_repository.dart';
import '../messages/screen_messages.dart';
import 'timeline_screen.dart';
import 'timeline_screen_state.dart';

class TimelineScreenCubit extends Cubit<TimelineScreenState> {
  final MessagesRepository repository;

  TimelineScreenCubit({
    this.repository,
  }) : super(
          TimelineScreenAwait(
            appBar: TimelineMainAppBar(),
            counter: 0,
            list: <PropertyMessage>[],
          ),
  );

  void downloadDataFromAllPages(
    Widget appBar,
  ) async {
    emit(
      TimelineScreenMain(
        appBar: appBar,
        list: await repository.messagesFromAllPages(),
        counter: 0,
      ),
    );
    sortMessagesByDate();
  }

  void showBookmarks() async {
    for (var i = 0; i < state.list.length; i++) {
      if (!state.list[i].isBookmark) {
        repository.editMessage(
          state.list[i].copyWith(
            isVisible: false,
          ),
        );
      }
    }
    emit(
      state.copyWith(
        list: await repository.messagesFromAllPages(),
      ),
    );
    sortMessagesByDate();
  }

  void showAll() async {
    for (var i = 0; i < state.list.length; i++) {
      repository.editMessage(
        state.list[i].copyWith(
          isVisible: true,
        ),
      );
    }

    emit(
      state.copyWith(
        list: await repository.messagesFromAllPages(),
      ),
    );
    sortMessagesByDate();
  }

  void editMessage(String data) {
    int index;
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        index = i;
        break;
      }
    }
    repository.editMessage(
      state.list[index].copyWith(
        data: data,
        isSelected: false,
      ),
    );
    toMainAppBar();
  }

  void remove(int id) {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.removeMessage(state.list[i].id);
      }
    }
  }

  void toSelectionAppBar() {
    emit(
      TimelineScreenSelection(
        appBar: TimelineSelectionAppBar(),
        list: state.list,
        counter: state.counter,
      ),
    );
  }

  void toMainAppBar() async {
    emit(
      TimelineScreenMain(
        appBar: TimelineMainAppBar(),
        list: await repository.messagesFromAllPages(),
        counter: 0,
      ),
    );
    sortMessagesByDate();
  }

  void selection(int index) async {
    var isSelected = state.list[index].isSelected;
    repository.editMessage(state.list[index].copyWith(isSelected: !isSelected));
    if (isSelected) {
      emit(
        state.copyWith(
          list: await repository.messagesFromAllPages(),
          counter: state.counter - 1,
        ),
      );
    } else {
      emit(
        state.copyWith(
          list: await repository.messagesFromAllPages(),
          counter: state.counter + 1,
        ),
      );
    }
    sortMessagesByDate();
  }

  void backToMainAppBar() async {
    controller.text = '';
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        selection(i);
      }
    }
    emit(
      TimelineScreenMain(
        appBar: TimelineMainAppBar(),
        list: await repository.messagesFromAllPages(),
        counter: 0,
      ),
    );
    sortMessagesByDate();
  }

  void sortMessagesByDate() {
    state.list.sort((a, b) => a.time.compareTo(b.time));
  }

  int checkDate(DateTime time) {
    var timeOfSending = DateFormat('yyyy-MM-dd').format(time);
    for (var i = 0; i < state.list.length; i++) {
      if (DateFormat('yyyy-MM-dd').format(state.list[i].time) ==
          timeOfSending) {
        return state.list[i].id;
      }
    }
    return 0;
  }

  String calculateDate(DateTime dateOfSending) {
    final dateToday = DateTime.now();
    final difference = dateToday.difference(dateOfSending).inDays;
    switch (difference) {
      case 0:
        return 'Today';
        break;
      case 1:
        return 'Yesterday';
        break;
      case 7:
        return 'Week ago';
        break;
      default:
        if (difference > 7) {
          return DateFormat.yMMMMd('en_US').format(dateOfSending);
        } else {
          return '$difference days ago';
        }
    }
  }

  void delete() async {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.removeMessage(state.list[i].id);
      }
    }
    emit(
      state.copyWith(
        counter: 0,
        list: await repository.messagesFromAllPages(),
      ),
    );
    toMainAppBar();
  }

  void copy() {
    var clipBoard = '';
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        clipBoard += state.list[i].data;
        selection(i);
      }
    }
    Clipboard.setData(ClipboardData(text: clipBoard));
  }

  void listSelected(int idMessagePage) {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        repository.editMessage(
          state.list[i].copyWith(
            idMessagePage: idMessagePage,
            isSelected: false,
          ),
        );
      }
    }
    toMainAppBar();
  }

  void makeBookmark(int index) async {
    var isBookmark = state.list[index].isBookmark;
    repository.editMessage(
      state.list[index].copyWith(
        isBookmark: !isBookmark,
      ),
    );
    emit(
      state.copyWith(
        list: await repository.messagesFromAllPages(),
      ),
    );
    sortMessagesByDate();
  }

  void makeBookmarkSelected() async {
    for (var i = 0; i < state.list.length; i++) {
      if (state.list[i].isSelected) {
        makeBookmark(i);
      }
    }
    emit(
      state.copyWith(
        list: await repository.messagesFromAllPages(),
      ),
    );
    sortMessagesByDate();
  }

  String getTitle(int id, List<PropertyPage> list) {
    for (var i = 0; i < list.length; i++) {
      if (id == list[i].id) {
        return list[i].title;
      }
    }
    return 'title';
  }
}
