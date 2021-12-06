import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/event.dart';
import '../../../../domain/entities/event_detail.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageState());

  final List<Event> _initialEvents = [
    Event(
      title: 'Journal',
      icon: const Icon(Icons.collections_bookmark),
    ),
    Event(
      title: 'Notes',
      icon: const Icon(Icons.menu_book_outlined),
    ),
    Event(
      icon: const Icon(Icons.thumb_up_alt_outlined),
      title: 'Gratitude',
    ),
  ];

  void init() {
    emit(state.copyWith(events: state.events.isEmpty ? _initialEvents : state.events));
  }

  void createEvent(Event event) {
    final events = List<Event>.from(state.events)..add(event);
    emit(state.copyWith(events: events));
  }

  void deleteEvent(int index) {
    final events = List<Event>.from(state.events)..removeAt(index);
    emit(state.copyWith(events: events));
  }

  /// This method fill an event object with eventDetails objects intended for it
  void fillEventWithEventElements(List<EventElement> eventDetailList, Event event) {
    final events = List<Event>.from(state.events);
    final index = events.indexOf(event);
    for (var current in eventDetailList) {
      events[index].events.add(current);
    }
    events[index].sortEvents();
    emit(state.copyWith(events: events));
  }

  void editEvent(int index, Event event) {
    final events = List<Event>.from(state.events)..[index] = Event.from(event);
    emit(state.copyWith(events: events));
  }

  void pinEvent(int index) {
    final pages = List<Event>.from(state.events);
    if (pages[index].isPinned) {
      var i = 0;
      while (i < pages.length && pages[i].isPinned) {
        i++;
      }
      pages[index].isPinned = pages[index].isPinned ? false : true;
      pages.insert(i - 1, Event.from(pages.removeAt(index)));
    } else {
      pages.insert(0, Event.from(pages.removeAt(index)));
      pages.first.isPinned = true;
    }
    emit(state.copyWith(events: pages));
  }
}
