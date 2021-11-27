import 'package:flutter/material.dart';

class CategoryDbModel {
  final int? id;
  final String? title;
  final IconData icon;
  final int priority;
  final int isDefault;

  CategoryDbModel(
      {this.id,
      this.title,
      required this.icon,
      required this.priority,
      this.isDefault = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon.codePoint,
      'priority': priority,
      'is_default': isDefault,
    };
  }

  factory CategoryDbModel.fromMap(Map<String, dynamic> map) {
    return CategoryDbModel(
      id: map['id'],
      title: map['title'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      priority: map['priority'],
      isDefault: map['is_default'],
    );
  }
}
