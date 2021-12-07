import 'package:flutter/material.dart';

class ActivityPage {
  final String id;
  final String name;
  final IconData icon;
  final String creationDate;
  final bool isPinned;

  ActivityPage({
    required this.id,
    required this.name,
    required this.icon,
    required this.creationDate,
    required this.isPinned,
  });

  ActivityPage copyWith({
    String? id,
    String? name,
    IconData? icon,
    String? creationDate,
    bool? isPinned,
  }) {
    return ActivityPage(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      creationDate: creationDate ?? this.creationDate,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  factory ActivityPage.fromMap(Map<String, dynamic> map) {
    return ActivityPage(
      id: map['id'],
      name: map['name'],
      icon: IconData(int.parse(map['icon']), fontFamily: 'MaterialIcons'),
      creationDate: map['creation_date'],
      isPinned: map['is_pinned'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint,
      'creation_date': creationDate,
      'is_pinned': isPinned ? 1 : 0,
    };
  }
}
