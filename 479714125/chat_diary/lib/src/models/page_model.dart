import 'package:flutter/material.dart';

import 'event_model.dart';

class PageModel {
  final String name;
  final IconData icon;
  final int id;
  int nextEventId;
  final List<EventModel> events;

  PageModel({
    required this.nextEventId,
    required this.id,
    required this.name,
    required this.icon,
  }) : events = [];

  PageModel.withIdAndList({
    required this.nextEventId,
    required this.id,
    required this.name,
    required this.icon,
    required this.events,
  });

  @override
  String toString() => '$name $icon $id ${events.length} $nextEventId';

  PageModel copyWith({
    String? name,
    IconData? icon,
    int? id,
    int? nextEventId,
    List<EventModel>? events,
  }) {
    return PageModel.withIdAndList(
      nextEventId: nextEventId ?? this.nextEventId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint,
      'nextEventId': nextEventId,
    };
  }

  factory PageModel.fromMap(Map<String, dynamic> pageMap) {
    return PageModel(
      id: pageMap['id'] as int,
      nextEventId: pageMap['nextEventId'] as int,
      name: pageMap['name'] as String,
      icon: IconData(pageMap['icon'], fontFamily: 'MaterialIcons'),
    );
  }
}
