import 'package:flutter/material.dart';

class CategoryRepository {
  final List<Category> events = <Category>[
    Category(
      iconData: Icons.directions_run,
      label: 'Running',
    ),
    Category(
      iconData: Icons.sports_basketball,
      label: 'Sports',
    ),
    Category(
      iconData: Icons.local_movies,
      label: 'Movie',
    ),
    Category(
      iconData: Icons.fastfood,
      label: 'FastFood',
    ),
    Category(
      iconData: Icons.fitness_center,
      label: 'Workout',
    ),
    Category(
      iconData: Icons.local_laundry_service,
      label: 'Laundry',
    ),
  ];
}

class Category {
  final IconData iconData;
  final String label;

  Category({
    this.iconData,
    this.label,
  });
}
