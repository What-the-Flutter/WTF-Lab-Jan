import 'package:flutter/material.dart';

class Category {
  final int id;
  final Color color;
  final String name;
  final String image;

  Category(this.name, this.color, this.image): id = name.hashCode;
}
