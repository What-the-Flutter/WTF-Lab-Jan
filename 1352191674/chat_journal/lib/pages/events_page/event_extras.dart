import 'dart:io';
import 'package:chat_journal/models/event_model.dart';
import 'package:flutter/material.dart';

abstract class EventPageEvent {}

class EventImageEvent extends EventPageEvent {
  final File image;

  EventImageEvent(this.image);
}

class AddEventEvent extends EventPageEvent {
  final Event event;
  final List<Event> events;

  AddEventEvent(this.event, this.events);
}

class EditEventEvent extends EventPageEvent {
  final Event event;
  final String text;
  final List<Event> events;
  final int index;

  EditEventEvent(this.event, this.events, this.text, this.index);
}

class DeleteEventEvent extends EventPageEvent {
  final Event event;
  final List<Event> events;

  DeleteEventEvent(this.event, this.events);
}

class SearchEventEvent extends EventPageEvent {
  final Event event;
  final List<Event> searchEvents;

  SearchEventEvent(this.event, this.searchEvents);
}

class AddIconEvent extends EventPageEvent{
  final IconData icon;

  AddIconEvent(this.icon);
}

class SwapEvent extends EventPageEvent{
  final Event event;

  SwapEvent(this.event);
}


class EventPageState {
  final int? currentIconIndex;
  File? image;
  IconData? icon;
  final List<Event> events;
  final List<Event> searchEvents;

  EventPageState(
      {this.image,
      required this.events,
      required this.searchEvents,
      this.icon,
      this.currentIconIndex});

  EventPageState copyWith(
      {File? image,
      List<Event>? events,
      List<Event>? searchEvents,
      IconData? icon,
      int? currentIconIndex}) {
    return EventPageState(
        image: image ?? this.image,
        events: events ?? this.events,
        searchEvents: searchEvents ?? this.searchEvents,
        icon: icon ?? this.icon,
        currentIconIndex:currentIconIndex ?? this.currentIconIndex);
  }
}
