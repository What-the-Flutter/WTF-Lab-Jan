import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CategoryPriority { high, normal }

class Category extends Equatable {
  final int? id;
  final Color color;
  final String? name;
  final String image;
  final CategoryPriority priority;

  Category({
    this.id,
    this.name,
    required this.color,
    required this.image,
    this.priority = CategoryPriority.normal,
  });

  Category copyWith({
    int? id,
    Color? color,
    String? image,
    String? name,
    CategoryPriority? priority,
  }) {
    return Category(
      id: id ?? this.id,
      color: color ?? this.color,
      image: image ?? this.image,
      name: name ?? this.name,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [id, color, name, image, priority];
}
