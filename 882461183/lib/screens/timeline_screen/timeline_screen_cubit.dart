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

  void onTap(int i) {
    final eventList = state.eventList;
    var itemsCount = state.selectedItemsCount;
    if (itemsCount > 0) {
      eventList[i] =
          eventList[i].copyWith(isSelected: !eventList[i].isSelected);

      emit(
        state.copyWith(
          selectedItemsCount:
              eventList[i].isSelected ? ++itemsCount : --itemsCount,
          eventList: eventList,
        ),
      );
    } else {
      eventList[i] =
          eventList[i].copyWith(isFavorite: !eventList[i].isFavorite);
      emit(state.copyWith(eventList: eventList));
    }
    timelineRepository.updateEvent(eventList[i]);
  }

  void onLongPress(int i) {
    var itemsCount = state.selectedItemsCount;
    var eventList = state.eventList;
    eventList[i] = eventList[i].copyWith(isSelected: !eventList[i].isSelected);
    emit(
      state.copyWith(
        selectedItemsCount:
            eventList[i].isSelected ? ++itemsCount : --itemsCount,
        eventList: eventList,
      ),
    );

    timelineRepository.updateEvent(eventList[i]);
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
    final eventList = state.eventList;
    for (var i = 0; i <= state.eventList.length - 1; i++) {
      if (state.eventList[i].isSelected) {
        eventList[i] = eventList[i].copyWith(isSelected: false);
        timelineRepository.updateEvent(eventList[i]);
      }
    }

    emit(
      state.copyWith(
        selectedItemsCount: 0,
        eventList: eventList,
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
    final eventList = state.eventList;
    for (var i = 0; i < eventList.length; i++) {
      if (eventList[i].isSelected) {
        eventList[i] = eventList[i].copyWith(
          isFavorite: !eventList[i].isFavorite,
        );
      }
    }
    emit(state.copyWith(eventList: eventList));
    unselectElements();
  }

  void deleteElement() {
    final messagessList = [];
    final finalList = state.eventList;
    for (final element in finalList) {
      if (element.isSelected) {
        messagessList.add(element);
        timelineRepository.deleteEvent(element);
        if (element.imagePath != '') {
          final imagePath = basename(element.imagePath);
          final destination = 'images/$imagePath';
          timelineRepository.deleteFile(destination);
        }
      }
    }

    finalList.removeWhere(messagessList.contains);
    emit(
      state.copyWith(
        selectedItemsCount: 0,
        eventList: finalList,
      ),
    );
  }
}
