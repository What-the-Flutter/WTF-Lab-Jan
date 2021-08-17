import 'dart:io';

import 'package:flutter/material.dart';

class Event {
  String? message;
  File? image;
  bool isBookmarked;
  String sendTime;

  Event({this.message, this.image})
      : isBookmarked = false,
        sendTime = '${DateTime.now().hour}:${DateTime.now().minute}';

  void updateSendTime() {
    final now = DateTime.now();
    sendTime = 'edited ${now.hour}:${now.minute}';
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
}
