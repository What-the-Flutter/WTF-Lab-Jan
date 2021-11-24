import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/filter_parameters.dart';
import '../../repository/messages_repository.dart';
import '../../repository/pages_repository.dart';
import 'timeline_state.dart';

class TimelinePageCubit extends Cubit<TimelinePageState> {
  final MessagesRepository messagesRepository;
  final PagesRepository pagesRepository;

  TimelinePageCubit(this.messagesRepository, this.pagesRepository)
      : super(
          TimelinePageState(
            messages: [],
            onlyMarked: false,
            isSelected: false,
            isSearchGoing: false,
            isCategoryPanelOpened: false,
            needsEditing: false,
            isDateTimeSelected: false,
            isColorChanged: false,
            arePagesIgnored: false,
            selectedMessageIndex: -1,
            categoryIcon: Icons.remove_rounded,
            selectedImagePath: '',
            searchText: '',
            selectedTime: TimeOfDay.now(),
            selectedDate: DateTime.now(),
            parameters: FilterParameters(
              onlyCheckedMessages: false,
              isDateSelected: false,
              arePagesIgnored: true,
              selectedPages: [],
              selectedTags: [],
              selectedLabels: [],
              searchText: '',
              date: DateTime.now(),
            ),
          ),
        );

  void showMessages() async {
    var messages;
    if (state.onlyMarked && !state.isSearchGoing) {
      messages = await messagesRepository.allMarkedMessagesList();
    } else if (state.isSearchGoing) {
      final tempMessages = await messagesRepository.allSearchMessagesList(
        state.searchText,
      );
      messages = tempMessages
          .where((message) => !File(message.imagePath).existsSync())
          .toList();
    } else if (!state.onlyMarked && !state.isSearchGoing) {
      messages = await messagesRepository.allMessagesList();
    } else {
      messages = [];
    }
    messages = filterMessages(messages);
    emit(
      state.copyWith(
        messages: messages,
      ),
    );
  }

  void setFilterParameters(FilterParameters parameters) {
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
    showMessages();
  }

  List filterMessages(List messages) {
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = filterByPages(messages);
    }
    if (state.parameters.selectedTags.isNotEmpty) {
      messages = _filterByTags(messages);
    }
    if (state.parameters.selectedLabels.isNotEmpty) {
      messages = _filterByLabels(messages);
    }
    if (state.parameters.isDateSelected) {
      messages = _filterByDate(messages);
    }
    if (state.parameters.onlyCheckedMessages) {
      messages = _filterByCheck(messages);
    }
    if (state.parameters.searchText != '') {
      messages = _filterByQuery(messages);
    }
    return messages;
  }

  List filterByPages(List messages) {
    if (state.parameters.arePagesIgnored) {
      messages = messages
          .where(
            (message) =>
                !state.parameters.selectedPages.contains(message.pageId),
          )
          .toList();
    } else {
      messages = messages
          .where(
            (message) =>
                state.parameters.selectedPages.contains(message.pageId),
          )
          .toList();
    }
    return messages;
  }

  List _filterByTags(List messages) {
    messages = messages
        .where((message) => state.parameters.selectedTags
            .any((tag) => message.text.contains(tag)))
        .toList();
    return messages;
  }

  List _filterByLabels(List messages) {
    messages = messages
        .where(
            (message) => state.parameters.selectedLabels.contains(message.icon))
        .toList();
    return messages;
  }

  List _filterByDate(List messages) {
    messages = messages
        .where((message) => areDaysEqual(message.date, state.parameters.date))
        .toList();
    return messages;
  }

  List _filterByCheck(List messages) {
    messages = messages.where((message) => message.isChecked).toList();
    return messages;
  }

  List _filterByQuery(List messages) {
    messages = messages
        .where((message) => message.text
            .toLowerCase()
            .contains(state.parameters.searchText.toLowerCase()))
        .toList();
    return messages;
  }

  void unselect() {
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void delete([int messageIndex = -1]) {
    if (messageIndex == -1) {
      messageIndex = state.selectedMessageIndex;
    }
    messagesRepository.deleteMessage(state.messages[messageIndex].id);
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
    showMessages();
  }

  String edit([int messageIndex = -1]) {
    if (messageIndex == -1) {
      messageIndex = state.selectedMessageIndex;
    }
    emit(
      state.copyWith(
        needsEditing: true,
        selectedMessageIndex: messageIndex,
      ),
    );
    return state.messages[messageIndex].text;
  }

  void copy() {
    Clipboard.setData(
      ClipboardData(text: state.messages[state.selectedMessageIndex].content),
    );
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void addMessage(String text) {
    if (state.needsEditing) {
      _addEdited(
        text,
      );
    }
    showMessages();
  }

  void _addEdited(String text) {
    final message = state.messages[state.selectedMessageIndex].copyWith(
      text: text,
      icon: state.categoryIcon,
    );
    messagesRepository.updateMessage(message);

    emit(
      state.copyWith(
        isSelected: false,
        categoryIcon: Icons.remove_rounded,
        needsEditing: false,
      ),
    );
  }

  DateTime convertToDateTime(TimeOfDay time, DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  DateTime selectedDateTime() {
    return convertToDateTime(state.selectedTime, state.selectedDate);
  }

  void select(int i) {
    emit(
      state.copyWith(
        isSelected: true,
        selectedMessageIndex: i,
      ),
    );
  }

  void mark(int i) {
    final message = state.messages[i].copyWith(
      isMarked: !state.messages[i].isMarked,
    );
    messagesRepository.updateMessage(message);
    showMessages();
  }

  void showMarked() {
    emit(
      state.copyWith(
        onlyMarked: !state.onlyMarked,
      ),
    );
    showMessages();
  }

  void startSearching() {
    emit(
      state.copyWith(
        isSearchGoing: true,
      ),
    );
    showMessages();
  }

  void endSearching() {
    emit(
      state.copyWith(
        isSearchGoing: false,
      ),
    );
    showMessages();
  }

  void searchMessages(String text) {
    emit(
      state.copyWith(
        searchText: text,
      ),
    );
    showMessages();
  }

  bool isSeparatorVisible(int i) {
    if (i == 0) {
      return true;
    } else if ((!areDaysEqual(
      state.messages[i - 1].date,
      state.messages[i].date,
    ))) {
      return true;
    } else {
      return false;
    }
  }

  bool areDaysEqual(DateTime day1, DateTime day2) {
    if (day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day) {
      return true;
    } else {
      return false;
    }
  }

  IconData categoryIcon(bool isCategoryPanelVisible, int i) {
    return isCategoryPanelVisible
        ? state.messages[i].icon
        : Icons.remove_rounded;
  }

  void openCategoryPanel() {
    emit(
      state.copyWith(
        isCategoryPanelOpened: true,
      ),
    );
  }

  void moveMessage(
    String nextPageId,
  ) {
    final delMessage = state.messages[state.selectedMessageIndex];
    final message = state.messages[state.selectedMessageIndex].copyWith(
      pageId: nextPageId,
    );
    messagesRepository.deleteMessage(delMessage.id);
    messagesRepository.insertMessage(message);
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
    showMessages();
  }

  void gradientAnimation() async {
    emit(
      state.copyWith(isColorChanged: false),
    );
    await Future.delayed(
      const Duration(milliseconds: 30),
    );
    emit(
      state.copyWith(isColorChanged: true),
    );
  }
}
