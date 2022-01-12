import 'package:flutter/material.dart';

class Event {
  String text;
  String imagePath;
  DateTime date;
  UniqueKey key;
  bool isSelected = false;
  bool isFavorite = false;

  Event({
    this.imagePath = '',
    required this.text,
    required this.date,
    required this.key,
  });
}
