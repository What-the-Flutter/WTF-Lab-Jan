import 'dart:convert';

import 'event.dart';

EventType eventTypeFromMap(String str) => EventType.fromMap(
      json.decode(str),
    );

String eventTypeToMap(EventType data) => json.encode(
      data.toMap(),
    );

class EventType {
  EventType({
    this.id,
    this.pin,
    this.title,
    this.icon,
    this.date,
    this.lastEvent,
  });

  int id;
  int pin;
  String title;
  String icon;
  DateTime date;
  Event lastEvent;

  factory EventType.fromMap(Map<String, dynamic> json) => EventType(
        id: json['id'],
        pin: json['pin'],
        title: json['title'],
        icon: json['icon'],
        date: json['date'] == null
            ? null
            : DateTime.parse(json['date'] as String),
      );

  Map toMap() {
    var map = <String, dynamic>{
      'title': title,
      'icon': icon,
      'date': date.toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    if (pin != null) {
      map['pin'] = pin;
    }
    return map;
  }
}
