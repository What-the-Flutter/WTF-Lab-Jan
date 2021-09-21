import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

List<EventPages> eventPages = [
  EventPages('Journal', Icons.book_rounded, [],
      Jiffy(DateTime.now()).format('d/M/y h:mm a')),
  EventPages('Gratitude', Icons.people_alt_rounded, [],
      Jiffy(DateTime.now()).format('d/M/y h:mm a')),
  EventPages('Notes', Icons.sticky_note_2_sharp, [],
      Jiffy(DateTime.now()).format('d/M/y h:mm a')),
];

class EventMessage extends Equatable {
  final dynamic content;
  final dynamic date;
  final IconData? icon;
  bool isMarked;

  EventMessage(
    this.content,
    this.date, {
    this.isMarked = false,
    this.icon = null,
  });

  EventMessage copyWith(
      {dynamic content, dynamic date, IconData? icon, required bool isMarked}) {
    return EventMessage(
      content ?? this.content,
      date ?? this.date,
      icon: icon ?? this.icon,
      isMarked: isMarked = this.isMarked,
    );
  }

  @override
  List<Object?> get props => [
        content,
        date,
        isMarked,
      ];
}

class EventPages extends Equatable {
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

  EventPages copyWith({
    required String name,
    required IconData icon,
    required dynamic date,
    required List<EventMessage> eventMessages,
    required bool isFixed,
  }) {
    return EventPages(
      this.name,
      this.icon,
      date ?? this.date,
      this.eventMessages,
      isFixed: this.isFixed,
    );
  }

  @override
  List<Object?> get props => [
        name,
        icon,
        eventMessages,
        date,
        isFixed,
      ];
}
