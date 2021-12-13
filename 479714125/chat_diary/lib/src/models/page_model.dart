import 'package:flutter/material.dart';

import 'event_model.dart';

class PageModel {
  final String name;
  final IconData icon;
  final int id;

  final List<EventModel> events;

  PageModel({
    required this.id,
    required this.name,
    required this.icon,
  }) : events = [];

  PageModel.withIdAndList({
    required this.id,
    required this.name,
    required this.icon,
    required this.events,
  });

  @override
  String toString() => '$name $icon $id ${events.length}';

  PageModel copyWith({
    String? name,
    IconData? icon,
    int? id,
    List<EventModel>? events,
  }) {
    return PageModel.withIdAndList(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      events: events ?? this.events,
    );
  }
}
