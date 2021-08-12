import 'package:flutter/material.dart';

enum CategoryPriority { high, normal }

class NoteCategory {
  final int? id;
  final Color color;
  final String? name;
  final String image;
  CategoryPriority priority;

  NoteCategory({
    this.id,
    this.name,
    required this.color,
    required this.image,
    this.priority = CategoryPriority.normal,
  });

  NoteCategory copyWith({Color? color, String? image, String? name, CategoryPriority? priority}) {
    return NoteCategory(
      id: id,
      color: color ?? this.color,
      image: image ?? this.image,
      name: name ?? this.name,
      priority: priority ?? this.priority,
    );
  }
}
