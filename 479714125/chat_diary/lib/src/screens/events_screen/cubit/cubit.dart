import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../models/event_model.dart';

import '../../../models/page_model.dart';

part 'state.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  EventScreenCubit(PageModel page)
      : super(EventScreenState(
          page: page,
          countOfSelected: 0,
          isEditing: false,
          isImageSelected: false,
          isCategory: false,
          currentCategory: null,
        ));

  void addEvent(EventModel model) {
    state.page.events.insert(0, model);
    emit(state.copyWith(page: state.page));
  }

  void addCurrentCategory(IconData iconData) {
    emit(state.copyWith(currentCategory: iconData));
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

  void toggleAppBar(int indexOfEvent, bool isSelected) {
    isSelected = !isSelected;
    state.page.events[indexOfEvent].isSelected = isSelected;
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
    for (final event in events) {
      if (event.isSelected) {
        count += 1;
      }
    }
    return count;
  }

  void toggleAllSelected() {
    for (final event in state.page.events) {
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

  void deleteSelectedEvents() {
    state.page.events.removeWhere(
      (element) => element.isSelected,
    );
    emit(state.copyWith(
      page: state.page,
      countOfSelected: 0,
      isImageSelected: false,
    ));
  }

  Iterable<EventModel> popSelectedEvents() {
    var selectedEvents = state.page.events
        .where(
          (element) => element.isSelected,
        )
        .toList();
    state.page.events.removeWhere(
      (element) => element.isSelected,
    );
    for (var event in selectedEvents) {
      if (event.isSelected) {
        event.isSelected = !event.isSelected;
      }
    }
    emit(state.copyWith(
      page: state.page,
      countOfSelected: 0,
      isImageSelected: false,
    ));
    return selectedEvents;
  }

  String copySelectedEvents() {
    final selectedEvents =
        state.page.events.where((element) => element.isSelected);
    var eventsToCopy = '';
    var isEveryEventImage = true;
    for (final event in selectedEvents) {
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

  void editEvent(String newEventText) {
    final index = findSelectedEventIndex();
    state.page.events[index].text = newEventText;
    state.page.events[index].isSelected = false;
    emit(state.copyWith(page: state.page));
  }
}
