import 'package:flutter/material.dart';

// List<Chat> chatList = [
//   Chat(
//     icon: Icons.flight_takeoff,
//     elementName: 'Travel',
//     creationDate: DateTime.now(),
//     eventList: [],
//   ),
//   Chat(
//     icon: Icons.weekend,
//     elementName: 'Family',
//     creationDate: DateTime.now(),
//     eventList: [],
//   ),
//   Chat(
//     icon: Icons.fitness_center,
//     elementName: 'Sports',
//     creationDate: DateTime.now(),
//     eventList: [],
//   ),
// ];

class Chat {
  final String id;
  final String elementName;
  final String elementSubname;
  final IconData icon;
  final DateTime creationDate;
  final bool isPinned;

  Chat({
    required this.id,
    required this.creationDate,
    required this.icon,
    required this.elementName,
    this.isPinned = false,
    this.elementSubname = 'No events. Click to create one.',
  });

  Chat copyWith({
    String? id,
    IconData? icon,
    String? elementName,
    String? elementSubname,
    bool? isPinned,
  }) {
    return Chat(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      creationDate: creationDate,
      elementName: elementName ?? this.elementName,
      elementSubname: elementSubname ?? this.elementSubname,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      elementName: map['name'],
      elementSubname: map['subname'],
      icon: IconData(int.parse(map['icon']), fontFamily: 'MaterialIcons'),
      creationDate: DateTime.parse(map['creation_date']),
      isPinned: map['is_pinned'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': elementName,
      'subname': elementSubname,
      'icon': icon.codePoint,
      'creation_date': creationDate.toString(),
      'is_pinned': isPinned ? 1 : 0,
    };
  }
}
