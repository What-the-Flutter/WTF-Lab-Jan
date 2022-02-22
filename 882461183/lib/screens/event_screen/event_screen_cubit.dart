import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '/data/repository/chat_repository.dart';
import '/data/repository/event_repository.dart';
import '/icons.dart';
import '/models/chat_model.dart';
import '/models/event_model.dart';
part 'event_screen_state.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  final EventRepository eventRepository;
  final ChatRepository chatRepository;

  EventScreenCubit({
    required this.chatRepository,
    required this.eventRepository,
  }) : super(EventScreenState());

  void initCubit(String id) {
    showEvents(id);
  }

  Future<void> showEvents(String chatId, {String text = ''}) async {
    var eventList = await eventRepository.fetchEventList(chatId);
    List<Chat>? chatList;
    if (state.isTextFieldEmpty && state.isSearching) {
      eventList = [];
    } else if (state.isSearching) {
      eventList = eventList
          .where(
            (element) => element.text.toLowerCase().contains(
                  text.toLowerCase(),
                ),
          )
          .toList();
    }
    if (text == '') {
      chatList = await chatRepository.fetchChatList();
    }
    emit(
      state.copyWith(
        eventList: eventList,
        chatList: chatList,
      ),
    );
    unselectElements();
  }

  void showEventsFromListen(List<Event> eventList) {
    emit(state.copyWith(eventList: eventList));
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

  Future<void> addImage(String chatId, String chatName) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final file = File(image.path);
    final imageName = basename(image.path);
    await eventRepository.uploadFile('images/$imageName', file);

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      chatName: chatName,
      text: 'Image Entry',
      imagePath: imageName,
      date: DateTime.now(),
    );
    eventRepository.insertEvent(event);
    showEvents(chatId);
  }

  void onTap(int eventIndex, String chatId) {
    var _itemsCount = state.selectedItemsCount;
    if (state.eventList[eventIndex].isSelected ||
        state.selectedItemsCount > 0) {
      state.eventList[eventIndex] = state.eventList[eventIndex]
          .copyWith(isSelected: !state.eventList[eventIndex].isSelected);
      state.eventList[eventIndex].isSelected
          ? emit(
              state.copyWith(
                selectedItemsCount: ++_itemsCount,
                eventList: state.eventList,
              ),
            )
          : emit(
              state.copyWith(
                selectedItemsCount: --_itemsCount,
                eventList: state.eventList,
              ),
            );
    } else {
      state.eventList[eventIndex] = state.eventList[eventIndex]
          .copyWith(isFavorite: !state.eventList[eventIndex].isFavorite);
      emit(state.copyWith(eventList: state.eventList));
    }
    eventRepository.updateEvent(state.eventList[eventIndex]);
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
    eventRepository.updateEvent(state.eventList[eventIndex]);
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

  void addNewEvent(String text, String chatId, String chatName) {
    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      chatName: chatName,
      text: text
          .split(RegExp(r'(?:\r?\n|\r)'))
          .where((s) => s.trim().isNotEmpty)
          .join('\n'),
      date: DateTime.now(),
    );

    eventRepository.insertEvent(event);
    emit(state.copyWith(isTextFieldEmpty: true));
    showEvents(chatId);
  }

  void deleteElement() {
    var _messagessList = [];
    for (final element in state.eventList) {
      if (element.isSelected) {
        _messagessList.add(element);

        if (element.imagePath != '') {
          final imagePath = basename(element.imagePath);
          final destination = 'images/$imagePath';
          eventRepository.deleteFile(destination);
        }
      }
    }

    state.eventList.removeWhere((e) => _messagessList.contains(e));
    emit(
      state.copyWith(
        selectedItemsCount: 0,
        eventList: state.eventList,
      ),
    );
    for (final element in _messagessList) {
      eventRepository.deleteEvent(element);
    }
  }

  void deleteFromDismiss(int index, String chatId) {
    if (state.eventList[index].imagePath != '') {
      final imagePath = basename(state.eventList[index].imagePath);
      final destination = 'images/$imagePath';
      eventRepository.deleteFile(destination);
    }
    eventRepository.deleteEvent(state.eventList[index]);
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
        eventRepository.updateEvent(state.eventList[i]);
      }
    }

    emit(
      state.copyWith(
        selectedItemsCount: 0,
        eventList: state.eventList,
      ),
    );
  }

  void showAllFavorites(String chatId) async {
    var eventList = await eventRepository.fetchEventList(chatId);
    if (!state.isShowFavorites) {
      eventList = eventList.where((element) => element.isFavorite).toList();
    }
    emit(
      state.copyWith(
        isShowFavorites: !state.isShowFavorites,
        eventList: eventList,
      ),
    );
  }

  void moveMessageToAnotherChat(int newChatIndex) {
    late final Event tempEvent;
    for (var i = 0; i <= state.eventList.length - 1; i++) {
      if (state.eventList[i].isSelected) {
        tempEvent = state.eventList[i].copyWith(
          chatId: state.chatList[newChatIndex].id,
          chatName: state.chatList[newChatIndex].elementName,
        );
        break;
      }
    }
    deleteElement();
    eventRepository.insertEvent(tempEvent);
  }

  String editMessageText() {
    for (final element in state.eventList) {
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
    eventRepository.insertEvent(event as Event);
  }

  void setCategory(int categoryIndex) {
    if (categoryIndex == 0) {
      emit(
        state.copyWith(
          isCategoriesOpened: false,
          categoryIndex: 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isCategoriesOpened: false,
          categoryIndex: categoryIndex,
        ),
      );
    }
  }

  void addEventWithCategory(
    String chatId,
    String text,
    String chatName,
  ) {
    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      chatName: chatName,
      text:
          text == '' ? categoriesMap.keys.elementAt(state.categoryIndex) : text,
      date: DateTime.now(),
      categoryIndex: state.categoryIndex,
    );

    state.eventList.insert(0, event);
    eventRepository.insertEvent(event);
    emit(
      state.copyWith(
        eventList: state.eventList,
        isTextFieldEmpty: true,
        categoryIndex: 0,
      ),
    );
  }

  void isTextFieldEmpty(String value, String chatId) {
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
