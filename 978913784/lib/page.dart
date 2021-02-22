import 'package:flutter/material.dart';

class JournalPage {
  String title;
  IconData icon;
  bool isPinned = false;
  DateTime creationTime;
  final List<Event> _events = <Event>[];

  JournalPage(this.title, this.icon, {this.creationTime}) {
    creationTime ??= DateTime.now();
  }

  JournalPage copyWith({String title, IconData icon}) {
    var copy = JournalPage(title ?? this.title, icon ?? this.icon,
        creationTime: creationTime);
    copy.events.addAll(_events);
    copy.isPinned = isPinned;
    return copy;
  }

  @override
  String toString() {
    return '$title';
  }

  // JournalPage copyWith({String title, IconData icon}) =>
  //     JournalPage(title ?? this.title, icon ?? this.icon);

  void addEvent(Event event) => _events.insert(0, event);

  int get eventCount => _events.length;

  Event get lastEvent => eventCount == 0 ? null : _events[0];

  List<Event> get events => _events;
}

class Event {
  int selectedIconIndex = 0;

  bool isFavourite = false;
  String description;
  DateTime _creationTime;

  Event(this.description, this.selectedIconIndex) {
    _creationTime = DateTime.now();
  }

  DateTime get creationTime => _creationTime;
}
