import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../database.dart';
import '../../models/events_model.dart';
import 'event_page_state.dart';

class EventPageCubit extends Cubit<EventPageState> {
  EventPageCubit()
      : super(
          EventPageState(
            messages: [],
            onlyMarked: false,
            isSelected: false,
            isSearchGoing: false,
            isCategoryPanelOpened: false,
            needsEditing: false,
            selectedMessageIndex: -1,
            categoryIcon: Icons.remove_rounded,
            eventPages: [],
          ),
        );
  var _searchText;

  Stream<List> showMessages(
    String eventPageId,
  ) async* {
    final List messages;
    if (state.onlyMarked && !state.isSearchGoing) {
      messages = await DBProvider.db.markedMessagesList(eventPageId);
    } else if (state.isSearchGoing) {
      final tempMessages =
          await DBProvider.db.searchMessagesList(eventPageId, _searchText);
      messages = tempMessages
          .where((message) => !File(message.content).existsSync())
          .toList();
    } else if (!state.onlyMarked && !state.isSearchGoing) {
      messages = await DBProvider.db.messagesList(eventPageId);
    } else {
      messages = [];
    }
    final pages = await DBProvider.db.eventPagesList();
    emit(
      state.copyWith(
        messages: messages,
        eventPages: pages,
      ),
    );
    yield messages;
  }

  void startSearching() {
    emit(
      state.copyWith(
        isSearchGoing: true,
      ),
    );
  }

  void endSearching(
    String eventPageId,
  ) {
    emit(
      state.copyWith(
        isSearchGoing: false,
      ),
    );
    showMessages(eventPageId);
  }

  void searchMessages(String eventPageId, String text) {
    _searchText = text;
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
    DBProvider.db.updateMessage(message);
  }

  void showMarked(String eventPageId) {
    emit(
      state.copyWith(
        onlyMarked: !state.onlyMarked,
      ),
    );
    showMessages(eventPageId);
  }

  void delete([int messageIndex = -1]) {
    if (messageIndex == -1) {
      messageIndex = state.selectedMessageIndex;
    }
    DBProvider.db.deleteMessage(state.messages[messageIndex].id);
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  String edit(String eventPageId, [int messageIndex = -1]) {
    if (messageIndex == -1) {
      messageIndex = state.selectedMessageIndex;
    }
    emit(
      state.copyWith(
        needsEditing: true,
        selectedMessageIndex: messageIndex,
      ),
    );
    if (File(state.messages[messageIndex].content).existsSync()) {
      addImage(eventPageId);
      return '';
    } else {
      return state.messages[messageIndex].content;
    }
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

  Future<void> addImage(String eventPageId) async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (state.isSelected) {
      final message = state.messages[state.selectedMessageIndex].copyWith(
        content: image!.path,
      );
      DBProvider.db.updateMessage(message);
    } else {
      final message = EventMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pageId: eventPageId,
        content: image!.path,
        date: DateTime.now().millisecondsSinceEpoch,
        icon: state.categoryIcon,
        isMarked: false,
      );
      DBProvider.db.insertMessage(message);
    }
    showMessages(eventPageId);
  }

  Future<bool> isImage(String content) {
    return File(content).exists();
  }

  void _addEdited(
    String eventPageId,
    String text,
  ) {
    final message = state.messages[state.selectedMessageIndex].copyWith(
      content: text,
      icon: state.categoryIcon,
    );
    DBProvider.db.updateMessage(message);

    emit(
      state.copyWith(
        isSelected: false,
        categoryIcon: Icons.remove_rounded,
        needsEditing: false,
      ),
    );
  }

  void addMessage(String eventPageId, String text) {
    if (state.needsEditing) {
      _addEdited(
        eventPageId,
        text,
      );
    } else {
      final message = EventMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pageId: eventPageId,
        content: text,
        date: DateTime.now().millisecondsSinceEpoch,
        icon: state.categoryIcon,
        isMarked: false,
      );
      DBProvider.db.insertMessage(message);
      emit(
        state.copyWith(
          categoryIcon: null,
        ),
      );
    }
  }

  void moveMessage(
    String nextPageId,
  ) {
    final delMessage = state.messages[state.selectedMessageIndex];
    final message = state.messages[state.selectedMessageIndex].copyWith(
      pageId: nextPageId,
    );
    DBProvider.db.deleteMessage(delMessage.id);
    DBProvider.db.insertMessage(message);
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
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
