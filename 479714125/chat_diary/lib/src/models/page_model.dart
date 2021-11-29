import 'package:flutter/material.dart';

import 'event_model.dart';

class PageModel {
  String name;
  IconData icon;
  Key key;
  List<EventModel> events;

  PageModel({
    required this.name,
    required this.icon,
  })  : events = <EventModel>[],
        key = UniqueKey();

  @override
  String toString() => '$name $icon $key ${events.length}';
}
