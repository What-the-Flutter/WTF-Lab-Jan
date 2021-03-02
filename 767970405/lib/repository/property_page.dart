import 'package:flutter/material.dart';
import 'property_message.dart';

class PropertyPage {
  final bool isPin;
  final IconData icon;
  final String title;
  final List<PropertyMessage> messages;
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
    final List<PropertyMessage> messages,
    final DateTime creationTime,
    final DateTime lastModifiedTime,
}) {
    return PropertyPage(
      isPin: isPin ?? this.isPin,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      creationTime: creationTime,
      lastModifiedTime: lastModifiedTime ?? this.lastModifiedTime,
    );
  }
}
