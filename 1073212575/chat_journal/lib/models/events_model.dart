
import 'package:flutter/cupertino.dart';

class EventMessage {
  final String id;
  final String pageId;
  final dynamic content;
  final int date;
  final IconData icon;
  final bool isMarked;

  EventMessage({
    required this.id,
    required this.pageId,
    required this.content,
    required this.date,
    required this.icon,
    required this.isMarked,
  });

  EventMessage copyWith({
    String? id,
    String? pageId,
    dynamic content,
    int? date,
    IconData? icon,
    bool? isMarked,
  }) =>
      EventMessage(
        id: id ?? this.id,
        pageId: pageId ?? this.pageId,
        content: content ?? this.content,
        date: date ?? this.date,
        icon: icon ?? this.icon,
        isMarked: isMarked ?? this.isMarked,
      );

  factory EventMessage.fromMap(Map<String, dynamic> map) => EventMessage(
        id: map['message_id'],
        pageId: map['page_id'],
        content: map['content'],
        date: map['date'],
        icon: IconData(int.parse(map['icon']), fontFamily: 'MaterialIcons'),
        isMarked: map['is_marked'] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() => {
        'message_id': id,
        'page_id': pageId,
        'content': content,
        'date': date,
        'icon': icon.codePoint,
        'is_marked': isMarked ? 1 : 0,
      };
}

class EventPages {
  final String id;
  final String name;
  final int date;
  final IconData icon;
  final bool isFixed;

  //final List<EventMessage> eventMessages;

  EventPages({
    required this.id,
    required this.name,
    required this.date,
    required this.icon,
    required this.isFixed,
    //required this.eventMessages,
  });

  EventPages copyWith({
    String? id,
    String? name,
    int? date,
    IconData? icon,
    bool? isFixed,
  }) =>
      EventPages(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        icon: icon ?? this.icon,
        isFixed: isFixed ?? this.isFixed,
      );

  factory EventPages.fromMap(Map<String, dynamic> map) => EventPages(
        id: map['page_id'],
        name: map['name'],
        date: map['date'],
        icon: IconData(int.parse(map['icon']), fontFamily: 'MaterialIcons'),
        isFixed: map['is_fixed'] == 1 ? true : false,
        //eventMessages: map['event_message'],
      );

  Map<String, dynamic> toMap() => {
        'page_id': id,
        'name': name,
        'date': date,
        'icon': icon.codePoint,
        'is_fixed': isFixed ? 1 : 0,
        //'event_messages': eventMessages,
      };
}
