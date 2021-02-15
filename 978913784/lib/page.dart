import 'package:flutter/material.dart';

class JournalPage {
  String title;
  IconData icon;
  bool isPinned = false;
  final List<Event> _events = <Event>[];

  JournalPage(this.title, this.icon);

  void addEvent(Event event) => _events.insert(0,event);
  int get eventCount => _events.length;
  Event get lastEvent => eventCount==0?null:_events[0];
  List<Event> get events => _events;
}

class Event {
  bool isFavourite = false;
  String description;
  DateTime _creationTime;

  Event(this.description) {
    _creationTime = DateTime.now();
  }


  DateTime get creationTime => _creationTime;
}
