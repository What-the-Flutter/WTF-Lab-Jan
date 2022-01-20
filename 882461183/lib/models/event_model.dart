import 'package:flutter/material.dart';

class Event {
  final String text;
  final String imagePath;
  final DateTime date;
  final UniqueKey key;
  final bool isSelected;
  final bool isFavorite;
  final String? categoryName;
  final IconData? categoryIcon;

  Event({
    required this.text,
    required this.date,
    required this.key,
    this.imagePath = '',
    this.isFavorite = false,
    this.isSelected = false,
    this.categoryName,
    this.categoryIcon,
  });

  Event copyWith({
    bool? isSelected,
    bool? isFavorite,
    String? text,
  }) {
    return Event(
      key: key,
      date: date,
      text: text ?? this.text,
      isFavorite: isFavorite ?? this.isFavorite,
      isSelected: isSelected ?? this.isSelected,
      imagePath: imagePath,
      categoryIcon: categoryIcon,
      categoryName: categoryName,
    );
  }
}
