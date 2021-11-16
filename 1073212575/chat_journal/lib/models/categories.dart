import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category{
  final IconData icon;
  final String name;
  Category(this.icon, this.name);
}
final List<Category> categories = [
  Category(Icons.highlight_remove_rounded,'Close',),
  Category(Icons.airplanemode_active_rounded,'Travel',),
  Category(Icons.shopping_cart_rounded,'Shopping',),
  Category(Icons.local_movies_rounded,'Movies',),
];
