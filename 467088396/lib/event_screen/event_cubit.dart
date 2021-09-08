import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_screen/home_cubit.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../models/section.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final _defaultSection = Section(title: '', iconData: Icons.bubble_chart);

  EventCubit() : super(EventState());
  void init(Category category) {
    emit(state.copyWith(
      category: category,
      selectedEvent: [],
      isEditMode: false,
      isSearchMode: false,
      isWriting: false,
      selectedSection: _defaultSection,
    ));
  }

  void setDefaultSection() {
    emit(state.copyWith(selectedSection: _defaultSection));
  }

  void selectEvent(int index) {
    var updateSelectedEvents = List<int>.from(state.selectedEvent);
    if (state.selectedEvent.contains(index)) {
      updateSelectedEvents.removeAt(index);
      if (updateSelectedEvents.isEmpty) {
        setEditMode(false);
      }
    } else {
      updateSelectedEvents.add(index);
    }
    emit(state.copyWith(
      selectedEvent: updateSelectedEvents,
    ));
  }

  void addMessageEvent(String text) {
    var event = Event(
      text: text,
      isBookmarked: false,
      image: null,
    );
    Category? updatedCategory;
    if (state.selectedEvent.length == 1 && state.isMessageEdit) {
      if (text.isEmpty) {
        updatedCategory = state.category!
          ..eventList.removeAt(state.selectedEvent[0]);
      } else {
        updatedCategory = state.category!
          ..eventList[state.selectedEvent[0]].text = text
          ..eventList[state.selectedEvent[0]];
      }
      emit(state.copyWith(selectedEvent: []));
    } else if (text.isNotEmpty) {
      updatedCategory = state.category!..eventList.insert(0, event);
      if (state.selectedSection != _defaultSection) {
        updatedCategory.eventList[0].section = state.selectedSection;
        setDefaultSection();
      }
    }
    emit(state.copyWith(category: updatedCategory));
  }

  void deleteEvent() {
    var selectedEvents = List<int>.from(state.selectedEvent);
    for (var i = 0; i < selectedEvents.length; i++) {
      state.category!.eventList.removeAt(selectedEvents[i]);
    }
    setEditMode(false);
    unselectEvents();
    emit(state.copyWith(category: state.category));
  }

  void setSearchMode(bool isSearchMode) {
    emit(state.copyWith(isSearchMode: isSearchMode));
  }

  void setWritingState(bool isWriting) {
    emit(state.copyWith(isWriting: isWriting));
  }

  void setSection(Section section) {
    emit(state.copyWith(selectedSection: section));
  }

  void setEditMode(bool isEditMode) {
    emit(state.copyWith(isEditMode: isEditMode));
  }

  void unselectEvents() {
    emit(state.copyWith(selectedEvent: []));
  }

  void copyEvent() {
    final text = state.category!.eventList[state.selectedEvent[0]].text;
    Clipboard.setData(ClipboardData(text: text));
    setEditMode(false);
    unselectEvents();
  }

  void bookmarkEvent() {
    var selectedEvents = List<int>.from(state.selectedEvent);
    var events = state.category!.eventList;
    for (var index in selectedEvents) {
      events[index].isBookmarked = !events[index].isBookmarked;
    }
    state.category!.eventList = events;
    emit(state.copyWith(category: state.category));
    setEditMode(false);
    unselectEvents();
  }

  void setMessageEdit(bool isMessageEdit) {
    emit(state.copyWith(isMessageEdit: isMessageEdit));
  }

  void setReplyCategory(BuildContext context, int index) {
    final category = context.read<HomeCubit>().state.categoryList[index];
    emit(state.copyWith(
      replyCategory: category,
      replyCategoryIndex: index,
    ));
  }

  void replyEvents(BuildContext context) {
    final category = state.replyCategory;
    var eventsToReply = <Event>[];
    for (var i in state.selectedEvent) {
      eventsToReply.add(state.category!.eventList[i]);
    }
    deleteEvent();
    context.read<HomeCubit>().addEvents(eventsToReply, category!);
  }
}
