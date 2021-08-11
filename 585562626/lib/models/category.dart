import 'package:flutter/material.dart';

enum CategoryPriority { high, normal }

class NoteCategory {
  final int id;
  final Color color;
  final String? name;
  final String image;
  CategoryPriority priority;

  NoteCategory({
    this.name,
    required this.color,
    required this.image,
    this.priority = CategoryPriority.normal,
  }) : id = name.hashCode;

  NoteCategory copyWith({String? name, CategoryPriority? priority}) {
    return NoteCategory(
      color: color,
      image: image,
      name: name ?? this.name,
      priority: priority ?? this.priority,
    );
  }
}
