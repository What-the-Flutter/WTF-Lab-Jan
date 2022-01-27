import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '/models/chat_model.dart';
import '/models/event_model.dart';
import '../../database.dart';
part 'chat_screen_state.dart';

class ChatScreenCubit extends Cubit<ChatScreenState> {
  ChatScreenCubit() : super(ChatScreenState());

  Future<void> showEvents(String chatId, {String text = ''}) async {
    List<Event> eventList;
    if (state.isShowFavorites && !state.isSearching) {
      eventList = await DatabaseHelper.db.fetchFavoritedEvents(chatId);
    } else if (state.isSearching) {
      eventList = await DatabaseHelper.db.fetchSearchedEvents(chatId, text);
    } else {
      eventList = await DatabaseHelper.db.fetchEventList(chatId);
    }
    final chatList = await DatabaseHelper.db.fetchChatList();
    emit(state.copyWith(eventList: eventList, chatList: chatList));
  }

  void changeParameters({
    bool? isEmpty,
    bool? isEdit,
    bool? isShowFavorites,
    bool? isSearching,
    bool? isCategoriesOpened,
    int? selectedItemsCount,
    List<Event>? eventList,
  }) =>
      emit(
        state.copyWith(
          isTextFieldEmpty: isEmpty,
          isEditing: isEdit,
          isShowFavorites: isShowFavorites,
          isSearching: isSearching,
          isCategoriesOpened: isCategoriesOpened,
          selectedItemsCount: selectedItemsCount,
          eventList: eventList,
        ),
      );

  Future<void> addImage(String chatId) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      text: 'Image Entry',
      imagePath: image.path,
      date: DateTime.now(),
    );
    DatabaseHelper.db.insertEvent(event);
    showEvents(chatId);
  }

  void onTap(int eventIndex, String chatId) {
    var _itemsCount = state.selectedItemsCount;
    if (state.eventList[eventIndex].isSelected ||
        state.selectedItemsCount > 0) {
      state.eventList[eventIndex] = state.eventList[eventIndex]
          .copyWith(isSelected: !state.eventList[eventIndex].isSelected);
      state.eventList[eventIndex].isSelected
          ? emit(state.copyWith(
              selectedItemsCount: ++_itemsCount,
              eventList: state.eventList,
            ))
          : emit(state.copyWith(
              selectedItemsCount: --_itemsCount,
              eventList: state.eventList,
            ));
    } else {
      state.eventList[eventIndex] = state.eventList[eventIndex]
          .copyWith(isFavorite: !state.eventList[eventIndex].isFavorite);
      emit(state.copyWith(eventList: state.eventList));
    }
    DatabaseHelper.db.updateEvent(state.eventList[eventIndex]);
  }

  void onLongPress(int eventIndex) {
    state.eventList[eventIndex] = state.eventList[eventIndex]
        .copyWith(isSelected: !state.eventList[eventIndex].isSelected);
    state.eventList[eventIndex].isSelected
        ? emit(
            state.copyWith(
              selectedItemsCount: state.selectedItemsCount + 1,
              eventList: state.eventList,
            ),
          )
        : emit(
            state.copyWith(
              selectedItemsCount: state.selectedItemsCount - 1,
              eventList: state.eventList,
            ),
          );
    DatabaseHelper.db.updateEvent(state.eventList[eventIndex]);
  }

  void copyText() {
    var selectedStringElements = '';
    for (var i = state.eventList.length; i > 0; i--) {
      if (state.eventList[i - 1].isSelected) {
        selectedStringElements += '${state.eventList[i - 1].text}\n';
      }
    }
    selectedStringElements =
        selectedStringElements.substring(0, selectedStringElements.length - 1);
    Clipboard.setData(ClipboardData(text: selectedStringElements));
    emit(state.copyWith(selectedItemsCount: 0));
    unselectElements();
  }

  void addNewEvent(String text, String chatId) {
    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      text: text
          .split(RegExp(r'(?:\r?\n|\r)'))
          .where((s) => s.trim().isNotEmpty)
          .join('\n'),
      date: DateTime.now(),
    );

    DatabaseHelper.db.insertEvent(event);
    emit(
      state.copyWith(
        isTextFieldEmpty: true,
      ),
    );
    showEvents(chatId);
  }

  void deleteElement() {
    var _messagessList = [];
    for (var element in state.eventList) {
      if (element.isSelected) {
        _messagessList.add(element);
      }
    }

    state.eventList.removeWhere((e) => _messagessList.contains(e));
    emit(
      state.copyWith(
        selectedItemsCount: 0,
        eventList: state.eventList,
      ),
    );
    for (var element in _messagessList) {
      DatabaseHelper.db.deleteEvent(element);
    }
  }

  void deleteFromDismiss(int index, String chatId) {
    DatabaseHelper.db.deleteEvent(state.eventList[index]);
    showEvents(chatId);
  }

  void addSelectedToFavorites() {
    for (var i = 0; i <= state.eventList.length - 1; i++) {
      if (state.eventList[i].isSelected) {
        state.eventList[i] = state.eventList[i].copyWith(
          isFavorite: !state.eventList[i].isFavorite,
        );
      }
    }
    unselectElements();
  }

  void unselectElements() {
    for (var i = 0; i <= state.eventList.length - 1; i++) {
      if (state.eventList[i].isSelected) {
        state.eventList[i] = state.eventList[i].copyWith(isSelected: false);
        DatabaseHelper.db.updateEvent(state.eventList[i]);
      }
    }

    emit(
      state.copyWith(
        selectedItemsCount: 0,
        eventList: state.eventList,
      ),
    );
  }

  void showAllFavorites(String chatId) {
    emit(state.copyWith(isShowFavorites: !state.isShowFavorites));
    showEvents(chatId);
  }

  void moveMessageToAnotherChat(int newChatIndex) {
    late final Event tempEvent;
    for (var i = 0; i <= state.eventList.length - 1; i++) {
      if (state.eventList[i].isSelected) {
        unselectElements();
        tempEvent = state.eventList[i]
            .copyWith(chatId: state.chatList[newChatIndex].id);
        break;
      }
    }
    deleteElement();
    DatabaseHelper.db.insertEvent(tempEvent);
  }

  String editMessageText() {
    for (var element in state.eventList) {
      if (element.isSelected) {
        emit(
          state.copyWith(
            editingEvent: element.copyWith(isSelected: false),
            isEditing: true,
            selectedItemsCount: 0,
          ),
        );
        unselectElements();
        return element.text;
      }
    }
    return '';
  }

  void confirmEditing(String text) {
    final event = state.editingEvent?.copyWith(text: text);
    for (var i = 0; i < state.eventList.length; i++) {
      if (event!.id == state.eventList[i].id) {
        state.eventList[i] = event;
      }
    }

    emit(
      state.copyWith(
        eventList: state.eventList,
        isEditing: false,
        isTextFieldEmpty: true,
      ),
    );
    DatabaseHelper.db.insertEvent(event as Event);
  }

  void setCategory(String text, IconData icon) {
    if (text == 'Cansel') {
      emit(
        state.copyWith(
          isCategoriesOpened: false,
          categoryIcon: Icons.close,
          categoryName: 'Close',
        ),
      );
    } else {
      emit(
        state.copyWith(
          isCategoriesOpened: false,
          categoryName: text,
          categoryIcon: icon,
        ),
      );
    }
  }

  void addEventWithCategory(
    String chatId,
    String text,
  ) {
    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      text: text == '' ? state.categoryName : text,
      date: DateTime.now(),
      categoryName: state.categoryName,
      categoryIcon: state.categoryIcon,
    );

    state.eventList.insert(0, event);
    DatabaseHelper.db.insertEvent(event);
    emit(
      state.copyWith(
        eventList: state.eventList,
        isTextFieldEmpty: true,
        categoryIcon: Icons.close,
        categoryName: 'Close',
      ),
    );
  }

  void isTextFiedEmpty(String value, String chatId) {
    if (value.isEmpty) {
      changeParameters(isEmpty: true);
    } else {
      changeParameters(isEmpty: false);
    }
    if (state.isSearching) {
      showEvents(chatId, text: value);
    }
  }
}
