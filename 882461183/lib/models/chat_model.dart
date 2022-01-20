import 'package:flutter/material.dart';

import 'event_model.dart';

List<Chat> chatList = [
  Chat(
    icon: Icons.flight_takeoff,
    elementName: 'Travel',
    creationDate: DateTime.now(),
    key: UniqueKey(),
    eventList: [],
  ),
  Chat(
    icon: Icons.weekend,
    elementName: 'Family',
    creationDate: DateTime.now(),
    key: UniqueKey(),
    eventList: [],
  ),
  Chat(
    icon: Icons.fitness_center,
    elementName: 'Sports',
    creationDate: DateTime.now(),
    key: UniqueKey(),
    eventList: [],
  ),
];

class Chat {
  final IconData icon;
  final String elementName;
  final String elementSubname;
  final bool isPinned;
  final DateTime creationDate;
  final List<Event> eventList;
  final Key key;

  Chat({
    required this.creationDate,
    required this.icon,
    required this.elementName,
    required this.eventList,
    required this.key,
    this.isPinned = false,
    this.elementSubname = 'No events. Click to create one.',
  });

  Chat copyWith({
    IconData? icon,
    String? elementName,
    String? elementSubname,
    bool? isPinned,
  }) {
    return Chat(
      icon: icon ?? this.icon,
      creationDate: creationDate,
      elementName: elementName ?? this.elementName,
      key: key,
      elementSubname: elementSubname ?? this.elementSubname,
      eventList: eventList,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
