import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class EventMessage {
  final dynamic content;
  final dynamic date;
  bool isMarked;
  EventMessage(
    this.content,
    this.date, {
    this.isMarked = false,
  });
}

class EventPages {
  final String name;
  final IconData icon;
  final dynamic date;
  bool isFixed;
  final List<EventMessage> eventMessages;
  EventPages(
    this.name,
    this.icon,
    this.eventMessages,
    this.date, {
    this.isFixed = false,
  });
}

List<EventPages> eventPages = [
  EventPages('Journal', Icons.book_rounded, [],
      Jiffy(DateTime.now()).format('d/M/y h:mm a')),
  EventPages('Gratitude', Icons.people_alt_rounded, [],
      Jiffy(DateTime.now()).format('d/M/y h:mm a')),
  EventPages('Notes', Icons.sticky_note_2_sharp, [],
      Jiffy(DateTime.now()).format('d/M/y h:mm a')),
];
