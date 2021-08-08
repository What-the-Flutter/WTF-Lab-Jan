import 'package:flutter/material.dart';

class NoteCategory {
  final int id;
  final Color color;
  final String? name;
  final String image;

  NoteCategory({this.name, required this.color, required this.image}): id = name.hashCode;
}
