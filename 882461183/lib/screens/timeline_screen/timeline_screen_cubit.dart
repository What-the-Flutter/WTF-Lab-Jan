import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import '/data/repository/timeline_repository.dart';
import '/models/chat_model.dart';
import '/models/event_model.dart';

part 'timeline_screen_state.dart';

class TimelineScreenCubit extends Cubit<TimelineScreenState> {
  final TimelineRepository timelineRepository;

  TimelineScreenCubit(this.timelineRepository) : super(TimelineScreenState());

  Future<void> fetchAllEventLists() async {
    final eventList = await timelineRepository.fetchAllEventLists();
    emit(state.copyWith(eventList: eventList));
    unselectElements();
  }

  void filterEventList(
    String searchText,
    List<Chat> chatList,
    List<int> categoryList,
  ) async {
    await fetchAllEventLists();
    var eventList = state.eventList;
    if (searchText != '') {
      eventList = eventList.where(
        (element) {
          return element.text.toLowerCase().contains(searchText.toLowerCase());
        },
      ).toList();
    }
    if (chatList.isNotEmpty) {
      eventList = filterByChats(eventList, chatList);
    }
    if (categoryList.isNotEmpty) {
      eventList = filterByCategories(eventList, categoryList);
    }
    emit(state.copyWith(eventList: eventList));
  }

  List<Event> filterByChats(List<Event> eventList, List<Chat> chatList) {
    final eventByChatsList = <Event>[];
    for (var i = 0; i < chatList.length; i++) {
      final tempChatsList =
          eventList.where((event) => event.chatId == chatList[i].id).toList();
      eventByChatsList.addAll(tempChatsList);
    }
    return eventByChatsList;
  }

  List<Event> filterByCategories(
    List<Event> eventList,
    List<int> categoryList,
  ) {
    final eventByCategoriesList = <Event>[];
    for (var i = 0; i < categoryList.length; i++) {
      final tempCategoryList =
          eventList.where((event) => event.categoryIndex == categoryList[i]);
      eventByCategoriesList.addAll(tempCategoryList);
    }
    return eventByCategoriesList;
  }

  void onTap(int eventIndex) {
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
    timelineRepository.updateEvent(state.eventList[eventIndex]);
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
    timelineRepository.updateEvent(state.eventList[eventIndex]);
  }

  Future<void> showFavorites() async {
    var eventList = await timelineRepository.fetchAllEventLists();
    if (!state.isShowFavorites) {
      eventList = eventList.where((element) => element.isFavorite).toList();
    }
    emit(
      state.copyWith(
        eventList: eventList,
        isShowFavorites: !state.isShowFavorites,
      ),
    );
  }

  void unselectElements() {
    for (var i = 0; i <= state.eventList.length - 1; i++) {
      if (state.eventList[i].isSelected) {
        state.eventList[i] = state.eventList[i].copyWith(isSelected: false);
        timelineRepository.updateEvent(state.eventList[i]);
      }
    }

    emit(
      state.copyWith(
        selectedItemsCount: 0,
        eventList: state.eventList,
      ),
    );
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

  void deleteElement() {
    var _messagessList = [];
    for (final element in state.eventList) {
      if (element.isSelected) {
        _messagessList.add(element);

        if (element.imagePath != '') {
          final imagePath = basename(element.imagePath);
          final destination = 'images/$imagePath';
          timelineRepository.deleteFile(destination);
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
      timelineRepository.deleteEvent(element);
    }
  }
}
