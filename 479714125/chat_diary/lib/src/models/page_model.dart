import 'package:flutter/material.dart';

import 'event_model.dart';

class PageModel {
  String name;
  IconData icon;
  final Key key;
  final List<EventModel> events;

  PageModel({
    required this.name,
    required this.icon,
  })  : events = <EventModel>[],
        key = UniqueKey();
}
