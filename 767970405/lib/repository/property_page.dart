import 'package:flutter/material.dart';
import 'messages_repository.dart';

class PropertyPage implements Comparable<PropertyPage> {
  final bool isPin;
  final IconData icon;
  final String title;
  final MessagesRepository messages;
  final DateTime creationTime;
  final DateTime lastModifiedTime;

  PropertyPage(
      {this.isPin,
      this.icon,
      this.title,
      this.messages,
      this.creationTime,
      this.lastModifiedTime});

  PropertyPage copyWith({
    final bool isPin,
    final IconData icon,
    final String title,
    final MessagesRepository messages,
    final DateTime creationTime,
    final DateTime lastModifiedTime,
  }) {
    return PropertyPage(
      isPin: isPin ?? this.isPin,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      creationTime: creationTime ?? this.creationTime,
      lastModifiedTime: lastModifiedTime ?? this.lastModifiedTime,
    );
  }

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
