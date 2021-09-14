import 'dart:io';

import 'package:flutter/material.dart';

class Category {
  final String title;
  final IconData icon;

  const Category({
    required this.icon,
    required this.title,
  });
}

class Event {
  String? message;
  File? image;
  Category? category;
  bool isBookmarked;
  String formattedSendTime;
  DateTime sendTime;

  Event({this.message, this.image, this.category})
      : isBookmarked = false,
        sendTime = DateTime.now(),
        formattedSendTime = '${DateTime.now().hour}:${DateTime.now().minute}';

  int compareTo(Event other) {
    return sendTime.isAfter(other.sendTime) ? -1 : 1;
  }

  void updateSendTime() {
    final now = DateTime.now();
    sendTime = now;
    formattedSendTime = 'edited ${now.hour}:${now.minute}';
  }
}

class PageInfo {
  List<Event> events = <Event>[];
  String lastMessage;
  String title;
  String lastEditDate;
  String createDate;
  bool isPinned;
  Icon icon;

  PageInfo({required this.title, required this.icon})
      : lastMessage = 'No Events. Click to create one.',
        isPinned = false,
        lastEditDate = '${DateTime.now().day}/${DateTime.now().month}'
            '/${DateTime.now().year} at ${DateTime.now().hour}:'
            '${DateTime.now().minute}',
        createDate = '${DateTime.now().day}/${DateTime.now().month}'
            '/${DateTime.now().year} at ${DateTime.now().hour}:'
            '${DateTime.now().minute}';

  PageInfo.from(PageInfo page)
      : events = page.events,
        lastMessage = page.lastMessage,
        title = page.title,
        lastEditDate = page.lastEditDate,
        createDate = page.createDate,
        isPinned = page.isPinned,
        icon = page.icon;

  List<Event> sortEvents() {
    events.sort((a, b) => a.compareTo(b));
    return events;
  }
}
