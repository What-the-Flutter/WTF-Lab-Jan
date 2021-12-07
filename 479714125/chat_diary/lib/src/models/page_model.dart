import 'package:flutter/material.dart';

import 'event_model.dart';

class PageModel {
  final String name;
  final IconData icon;
  late final Key key;
  final List<EventModel> events;

  PageModel({
    required this.name,
    required this.icon,
  })  : key = UniqueKey(),
        events = [];

  PageModel.withKeyAndList({
    required this.name,
    required this.icon,
    required this.key,
    required this.events,
  });

  @override
  String toString() => '$name $icon $key ${events.length}';

  PageModel copyWith({
    String? name,
    IconData? icon,
    Key? key,
    List<EventModel>? events,
  }) {
    return PageModel.withKeyAndList(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      key: key ?? this.key,
      events: events ?? this.events,
    );
  }
}
