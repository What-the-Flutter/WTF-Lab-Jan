import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CategoryPriority { high, normal }

class Category extends Equatable {
  final int? id;
  final String? name;
  final IconData icon;
  final CategoryPriority priority;

  const Category({
    this.id,
    this.name,
    required this.icon,
    this.priority = CategoryPriority.normal,
  });

  @override
  List<Object?> get props => [id, name, icon, priority];

  Category copyWith({
    int? id,
    Color? color,
    String? name,
    IconData? icon,
    CategoryPriority? priority,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      priority: priority ?? this.priority,
    );
  }
}
