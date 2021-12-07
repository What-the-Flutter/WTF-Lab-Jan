import 'package:flutter/material.dart';

import 'event_element.dart';

/// The element that is created on the home page
class Event {
  int? id;
  int iconIndex;
  String title;
  String createDate;
  String lastEditDate;
  String lastMessage;
  bool isPinned;
  Icon icon;
  List<EventElement> eventElements;

  Event({
    this.id,
    this.iconIndex = 0,
    this.title = '',
    this.icon = const Icon(Icons.favorite, color: Colors.white),
    this.isPinned = false,
    this.lastMessage = 'No Events. Click to create one.',
    this.createDate = '',
    this.lastEditDate = '',
    this.eventElements = const <EventElement>[],
  });

  ///createDate = lastEditDate = '${DateFormat('yyyyy.MMMMM.dd GGG hh:mm aaa').format(DateTime.now())}';

  /// Creating event from event
  Event.from(Event event)
      : id = event.id,
        iconIndex = event.iconIndex,
        eventElements = event.eventElements,
        lastMessage = event.lastMessage,
        title = event.title,
        lastEditDate = event.lastEditDate,
        createDate = event.createDate,
        isPinned = event.isPinned,
        icon = event.icon;

  List<EventElement> sortEvents() {
    eventElements.sort((a, b) => a.compareTo(b));
    return eventElements;
  }

  Event copyWith({
    int? id,
    int? iconIndex,
    String? title,
    String? lastMessage,
    String? lastEditDate,
    String? createDate,
    bool? isPinned,
    Icon? icon,
    List<EventElement>? eventElements,
  }) {
    return Event(
      id: id ?? this.id,
      iconIndex: iconIndex ?? this.iconIndex,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      lastEditDate: lastEditDate ?? this.lastEditDate,
      createDate: createDate ?? this.createDate,
      isPinned: isPinned ?? this.isPinned,
      icon: icon ?? this.icon,
      eventElements: eventElements ?? this.eventElements,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iconIndex': iconIndex,
      'title': title,
      'lastMessage': lastMessage,
      'lastEditDate': lastEditDate,
      'createDate': createDate,
      'isPinned': isPinned ? 1 : 0,
    };
  }

  @override
  String toString() {
    return '{$title id: $id, iconIndex: $iconIndex, isPinned: $isPinned}';
  }
}
