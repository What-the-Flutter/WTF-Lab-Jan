import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../data/database_config.dart';
import '../../../models/event_model.dart';
import '../../../models/page_model.dart';

part 'state.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  EventScreenCubit(PageModel page)
      : super(EventScreenState(
          newEventIndex: 0,
          page: page,
          countOfSelected: 0,
          isEditing: false,
          isImageSelected: false,
          isCategory: false,
          isSearch: false,
          currentCategory: null,
        ));

  void fetchAllEvents() async {
    final list = await databaseProvider.retrieveEvents(state.page.id);
    final reversedList = list.reversed.toList();
    emit(state.copyWith(
      page: state.page.copyWith(events: reversedList, nextEventId: list.length),
      newEventIndex: list.length,
    ));
  }

  void addEvent(EventModel model) async {
    await databaseProvider.insertEvent(model);
    state.page.events.insert(0, model);
    state.page.nextEventId += 1;
    emit(state.copyWith(
        page: state.page, newEventIndex: state.newEventIndex + 1));
  }

  void addCurrentCategory(IconData iconData) {
    emit(state.copyWith(currentCategory: iconData));
  }

  void toggleIsSearch() {
    emit(state.copyWith(isSearch: !state.isSearch));
  }

  void deleteCurrentCaregory() {
    emit(state.copyWith(currentCategory: null));
  }

  void toggleIsCategory() {
    emit(state.copyWith(isCategory: !state.isCategory));
  }

  void setIsCategoryFalse() {
    emit(state.copyWith(isCategory: false));
  }

  void toggleAppBar(int indexOfEvent, bool isSelected) async {
    isSelected = !isSelected;
    state.page.events[indexOfEvent].isSelected = isSelected;
    await databaseProvider
        .toggleEventSelection(state.page.events[indexOfEvent]);
    if (state.page.events[indexOfEvent].image == null) {
      emit(state.copyWith(
        page: state.page,
        countOfSelected: _countSelectedEvents(state.page.events),
      ));
    } else {
      emit(state.copyWith(
        isImageSelected: !state.isImageSelected,
        countOfSelected: _countSelectedEvents(state.page.events),
      ));
    }
  }

  int _countSelectedEvents(List<EventModel> events) {
    var count = 0;
    for (var event in events) {
      if (event.isSelected) {
        count += 1;
      }
    }
    return count;
  }

  void toggleAllSelected() {
    for (var event in state.page.events) {
      if (event.isSelected) {
        event.isSelected = false;
      }
    }
    toggleSelected();
  }

  void toggleSelected() {
    emit(state.copyWith(
      page: state.page,
      countOfSelected: 0,
      isImageSelected: false,
    ));
  }

  void deleteSelectedEvents() async {
    await databaseProvider.deleteSelectedEvents();
    fetchAllEvents();
    emit(state.copyWith(countOfSelected: 0, isImageSelected: false));
  }

  Future<Iterable<EventModel>> popSelectedEvents() async {
    var selectedEvents = await databaseProvider.fetchSelectedEvents();

    await databaseProvider.deleteSelectedEvents();
    for (var event in selectedEvents) {
      if (event.isSelected) {
        event.isSelected = !event.isSelected;
      }
    }
    final list = await databaseProvider.retrieveEvents(state.page.id);
    final reversedList = list.reversed.toList();

    emit(state.copyWith(
      page: state.page.copyWith(events: reversedList),
      countOfSelected: 0,
      isImageSelected: false,
    ));
    return selectedEvents;
  }

  Future<String> copySelectedEvents() async {
    final selectedEvents = await databaseProvider.fetchSelectedEvents();
    var eventsToCopy = '';
    var isEveryEventImage = true;
    for (var event in selectedEvents) {
      if (event.text != null) {
        isEveryEventImage = false;
        eventsToCopy += event.text!;
        if (event != selectedEvents.last && selectedEvents.last.text != null) {
          eventsToCopy += '\n';
        }
      }
    }
    if (isEveryEventImage) {
      return '';
    }
    return eventsToCopy;
  }

  int findSelectedEventIndex() {
    final index = state.page.events.indexWhere((element) => element.isSelected);
    return index;
  }

  void setIsEditing() => emit(state.copyWith(isEditing: !state.isEditing));

  void editEvent(String newEventText) async {
    final index = findSelectedEventIndex();
    state.page.events[index].text = newEventText;
    state.page.events[index].isSelected = false;
    await databaseProvider.updateEvent(state.page.events[index]);
    emit(state.copyWith(page: state.page));
  }
}
