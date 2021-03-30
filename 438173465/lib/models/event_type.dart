import 'dart:convert';

EventType eventTypeFromMap(String str) => EventType.fromMap(json.decode(str));

String eventTypeToMap(EventType data) => json.encode(data.toMap());

class EventType {
  EventType({
    this.id,
    this.title,
    this.icon,
  });

  int id;
  String title;
  String icon;

  factory EventType.fromMap(Map<String, dynamic> json) => EventType(
        id: json['id'],
        title: json['title'],
        icon: json['icon'],
      );

  Map toMap() {
    var map = <String,dynamic>{
      'title': title,
      'icon': icon,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
