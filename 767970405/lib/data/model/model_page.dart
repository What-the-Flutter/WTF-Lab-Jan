import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../repository/messages_repository.dart';

class ModelPage extends Equatable implements Comparable<ModelPage> {
  final bool isPin;
  final IconData icon;
  final String title;
  final MessagesRepository messages;
  final DateTime creationTime;
  final DateTime lastModifiedTime;

  ModelPage(
      {this.isPin,
      this.icon,
      this.title,
      this.messages,
      this.creationTime,
      this.lastModifiedTime});

  ModelPage copyWith({
    final bool isPin,
    final IconData icon,
    final String title,
    final MessagesRepository messages,
    final DateTime creationTime,
    final DateTime lastModifiedTime,
  }) {
    return ModelPage(
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
  int compareTo(ModelPage other) {
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

  @override
  List<Object> get props =>
      [isPin, icon, title, lastModifiedTime, creationTime, messages];
}
