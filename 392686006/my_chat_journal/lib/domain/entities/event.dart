import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'event_detail.dart';

/// The element that is created on the home page
class Event {
  String title;
  String createDate;
  String lastEditDate;
  String lastMessage;
  bool isPinned;
  Icon icon;
  List<EventDetail> events = <EventDetail>[];



  Event({
    required this.title,
    required this.icon,
    this.isPinned = false,
    this.lastMessage = 'No Events. Click to create one.',
    this.createDate = '',
    this.lastEditDate = '',
  }){
    createDate = lastEditDate = '${DateFormat('yyyyy.MMMMM.dd GGG hh:mm aaa').format(DateTime.now())}';
  }

  /// Creating event from event
  Event.from(Event event)
      : events = event.events,
        lastMessage = event.lastMessage,
        title = event.title,
        lastEditDate = event.lastEditDate,
        createDate = event.createDate,
        isPinned = event.isPinned,
        icon = event.icon;

  List<EventDetail> sortEvents() {
    events.sort((a, b) => a.compareTo(b));
    return events;
  }
}
