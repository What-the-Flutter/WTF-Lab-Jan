import 'package:flutter/material.dart';

class CategoryIcon {
  final IconData icon;
  final String title;

  CategoryIcon({this.icon, this.title});
}

final List<CategoryIcon> listIconCategory = <CategoryIcon>[
  CategoryIcon(icon: Icons.sports_baseball, title: 'Sport'),
  CategoryIcon(icon: Icons.local_movies, title: 'Movie'),
  CategoryIcon(icon: Icons.music_note, title: 'Music'),
  CategoryIcon(icon: Icons.fastfood, title: 'Fastfood'),
  CategoryIcon(icon: Icons.local_laundry_service, title: 'Laundry'),
  CategoryIcon(icon: Icons.directions_run, title: 'Running'),
];
