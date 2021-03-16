import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_repository.dart';

class PropertyPage implements Comparable<PropertyPage> {
  int id;
  final bool isPin;
  final IconData icon;
  final String title;
  final MessagesRepository messages;
  final DateTime creationTime;
  final DateTime lastModifiedTime;

  PropertyPage(
      {this.id,
      this.isPin = false,
      this.icon,
      this.title,
      this.messages,
      this.creationTime,
      this.lastModifiedTime});

  PropertyPage copyWith({
    int id,
    final bool isPin,
    final IconData icon,
    final String title,
    final MessagesRepository messages,
    final DateTime creationTime,
    final DateTime lastModifiedTime,
  }) {
    return PropertyPage(
      id: id ?? this.id,
      isPin: isPin ?? this.isPin,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      creationTime: creationTime ?? this.creationTime,
      lastModifiedTime: lastModifiedTime ?? this.lastModifiedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconCodePoint': icon.codePoint,
      'creationTime': DateFormat('yyyy-MM-dd hh:mm:ss').format(creationTime),
      'lastModifiedTime':
          DateFormat('yyyy-MM-dd hh:mm:ss').format(lastModifiedTime),
      'isPin': isPin ? 1 : 0,
    };
  }

  factory PropertyPage.fromMap(Map<String, dynamic> map) => PropertyPage(
        id: map['id'],
        title: map['title'],
        icon: IconData(map['iconCodePoint'], fontFamily: 'MaterialIcons'),
        creationTime:
            DateFormat('yyyy-MM-dd hh:mm:ss').parse(map['creationTime']),
        lastModifiedTime:
            DateFormat('yyyy-MM-dd hh:mm:ss').parse(map['lastModifiedTime']),
        isPin: map['isPin'] == 1 ? true : false,
      );

  @override
  String toString() {
    return 'PropertyPage{isPin: $isPin, icon: $icon, title: $title}';
  }

  @override
  int compareTo(PropertyPage other) {
    if (isPin && !other.isPin) {
      return -1;
    } else if (!isPin && other.isPin) {
      return 1;
    } else {
      if (creationTime.isBefore(other.creationTime)) {
        return -1;
      } else {
        return 1;
      }
    }
  }
}
