import 'package:flutter/cupertino.dart';

class EventMessage {
  final String id;
  final String pageId;
  final String text;
  final String imagePath;
  final DateTime date;
  final IconData icon;
  final bool isMarked;
  final bool isChecked;

  EventMessage({
    required this.id,
    required this.pageId,
    required this.text,
    required this.imagePath,
    required this.date,
    required this.icon,
    required this.isMarked,
    required this.isChecked,
  });

  EventMessage copyWith({
    String? id,
    String? pageId,
    String? text,
    String? imagePath,
    DateTime? date,
    IconData? icon,
    bool? isMarked,
    bool? isChecked,
  }) =>
      EventMessage(
        id: id ?? this.id,
        pageId: pageId ?? this.pageId,
        text: text ?? this.text,
        imagePath: imagePath ?? this.imagePath,
        date: date ?? this.date,
        icon: icon ?? this.icon,
        isMarked: isMarked ?? this.isMarked,
        isChecked: isChecked ?? this.isChecked,
      );

  factory EventMessage.fromMap(Map<String, dynamic> map) => EventMessage(
        id: map['message_id'],
        pageId: map['page_id'],
        text: map['text'],
        imagePath: map['image_path'],
        date: DateTime.parse(map['date']),
        icon: IconData(int.parse(map['icon']), fontFamily: 'MaterialIcons'),
    isMarked: map['is_marked'] == 1 ? true : false,
    isChecked: map['is_checked'] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() => {
        'message_id': id,
        'page_id': pageId,
        'text': text,
        'image_path': imagePath,
        'date': date.toString(),
        'icon': icon.codePoint,
    'is_marked': isMarked ? 1 : 0,
        'is_checked': isChecked ? 1 : 0,
      };
}

class EventPages {
  final String id;
  final String name;
  final DateTime date;
  final IconData icon;
  final bool isFixed;


  EventPages({
    required this.id,
    required this.name,
    required this.date,
    required this.icon,
    required this.isFixed,
  });

  EventPages copyWith({
    String? id,
    String? name,
    DateTime? date,
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
        date: DateTime.parse(map['date']),
        icon: IconData(int.parse(map['icon']), fontFamily: 'MaterialIcons'),
        isFixed: map['is_fixed'] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() => {
        'page_id': id,
        'name': name,
        'date': date.toString(),
        'icon': icon.codePoint,
        'is_fixed': isFixed ? 1 : 0,
      };
}
