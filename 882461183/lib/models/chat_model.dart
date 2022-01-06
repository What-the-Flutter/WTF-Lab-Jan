import 'package:flutter/material.dart';

import 'event_model.dart';

class Chat {
  IconData icon;
  String elementName;
  String elementSubname = 'No events. Click to create one.';
  bool isPinned = false;
  final DateTime creationDate;
  List<Event> eventList = [];
  Key key;

  Chat({
    required this.creationDate,
    required this.icon,
    required this.elementName,
    required this.key,
  });
}
