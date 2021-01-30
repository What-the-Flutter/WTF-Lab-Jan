import 'package:flutter/material.dart';

class JournalPage {
  String title;
  IconData icon;
  List<Event> _events = <Event>[];

  JournalPage(this.title, this.icon);

  addEvent(Event event) => _events.add(event);

  int get eventCount => _events.length;

  Event get lastEvent => _events[_events.length - 1];

  List<Event> get events => _events;
}

class Event {
  String description;

  Event(this.description);
}
