import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/events_model.dart';
import '../../repository/messages_repository.dart';
import '../../repository/pages_repository.dart';
import 'event_page_state.dart';

class EventPageCubit extends Cubit<EventPageState> {
  final MessagesRepository messagesRepository;
  final PagesRepository pagesRepository;

  EventPageCubit(this.messagesRepository, this.pagesRepository)
      : super(
          EventPageState(
            messages: [],
            onlyMarked: false,
            isSelected: false,
            isSearchGoing: false,
            isCategoryPanelOpened: false,
            needsEditing: false,
            isDateTimeSelected: false,
            selectedMessageIndex: -1,
            categoryIcon: Icons.remove_rounded,
            eventPageId: '',
            selectedImagePath: '',
          ),
        );
  var _searchText;
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();

  void showMessages() async {
    final List messages;
    if (state.onlyMarked && !state.isSearchGoing) {
      messages = await messagesRepository.markedMessagesList(state.eventPageId);
    } else if (state.isSearchGoing) {
      final tempMessages = await messagesRepository.searchMessagesList(
          state.eventPageId, _searchText);
      messages = tempMessages
          .where((message) => !File(message.imagePath).existsSync())
          .toList();
    } else if (!state.onlyMarked && !state.isSearchGoing) {
      messages = await messagesRepository.messagesList(state.eventPageId);
    } else {
      messages = [];
    }
    //final pages = await pagesRepository.eventPagesList();
    emit(
      state.copyWith(
        messages: messages,
        //eventPages: pages,
      ),
    );
  }

  void setPageId(String eventPageId) {
    emit(
      state.copyWith(
        eventPageId: eventPageId,
      ),
    );
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
    _searchText = text;
    showMessages();
  }

  void unselect() {
    emit(
      state.copyWith(
        isSelected: false,
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
    // if (File(state.messages[messageIndex].imagePath).existsSync()) {
    //   addImage();
    // }
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

  void select(int i) {
    emit(
      state.copyWith(
        isSelected: true,
        selectedMessageIndex: i,
      ),
    );
  }

  Future<void> addImage() async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (state.isSelected) {
      final message = state.messages[state.selectedMessageIndex].copyWith(
        imagePath: image!.path,
      );
      messagesRepository.updateMessage(message);
    }
    emit(
      state.copyWith(
        selectedImagePath: image!.path,
      ),
    );
  }

  void _addEdited(String text) {
    var message;
    if (state.selectedImagePath == '') {
      message = state.messages[state.selectedMessageIndex].copyWith(
        text: text,
        icon: state.categoryIcon,
      );
    } else {
      message = state.messages[state.selectedMessageIndex].copyWith(
        text: text,
        icon: state.categoryIcon,
        imagePath: state.selectedImagePath,
      );
    }

    messagesRepository.updateMessage(message);

    emit(
      state.copyWith(
        isSelected: false,
        categoryIcon: Icons.remove_rounded,
        needsEditing: false,
      ),
    );
  }

  void addMessage(String text) {
    final dateTime = state.isDateTimeSelected
        ? convertToDateTime(_selectedTime, _selectedDate)
        : DateTime.now();
    if (state.needsEditing) {
      _addEdited(
        text,
      );
    } else {
      final message = EventMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pageId: state.eventPageId,
        text: text,
        imagePath: state.selectedImagePath,
        date: dateTime,
        icon: state.categoryIcon,
        isMarked: false,
      );
      messagesRepository.insertMessage(message);
      emit(
        state.copyWith(
          categoryIcon: null,
          selectedImagePath: '',
          isDateTimeSelected: false,
        ),
      );
    }
    showMessages();
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

  bool isSeparatorVisible(int i) {
    if (i == 0) {
      return true;
    } else if ((!areDaysEqual(
        state.messages[i - 1].date, state.messages[i].date))) {
      return true;
    } else {
      return false;
    }
  }

  void setTime(TimeOfDay? newTime) {
    if (newTime != null) {
      emit(
        state.copyWith(
          isDateTimeSelected: true,
        ),
      );
      _selectedTime = newTime;
    }
  }

  void setDate(DateTime? newDate) {
    if (newDate != null && newDate != _selectedDate) {
      emit(
        state.copyWith(
          isDateTimeSelected: true,
        ),
      );
      _selectedDate = newDate;
    }
  }

  DateTime selectedDateTime() {
    return convertToDateTime(_selectedTime, _selectedDate);
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

  void openCategoryPanel() {
    emit(
      state.copyWith(
        isCategoryPanelOpened: true,
      ),
    );
  }

  void closeCategoryPanel() {
    emit(
      state.copyWith(
        isCategoryPanelOpened: false,
        categoryIcon: Icons.remove_rounded,
      ),
    );
  }

  void setCategory(IconData categoryIcon) {
    emit(
      state.copyWith(
        categoryIcon: categoryIcon,
      ),
    );
  }

  void chooseCategory(int i, IconData icon) {
    i == 0 ? closeCategoryPanel() : setCategory(icon);
  }

  IconData categoryIcon(bool isCategoryPanelVisible, int i) {
    return isCategoryPanelVisible
        ? state.messages[i].icon
        : Icons.remove_rounded;
  }
}
