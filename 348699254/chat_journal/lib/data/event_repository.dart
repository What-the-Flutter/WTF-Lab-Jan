import 'package:flutter/material.dart';

class Event {
  int id;
  String eventData;
  String imagePath;
  DateTime creationDate;
  IconData? categoryIcon;
  String? categoryName;
  int pageId;
  bool isSelected;
  bool isMarked;

  Event({
    required this.id,
    required this.eventData,
    required this.imagePath,
    required this.categoryIcon,
    required this.categoryName,
    required this.creationDate,
    required this.pageId,
    required this.isSelected,
    required this.isMarked,
  });

  Event copyWith({
    int? id,
    String? eventData,
    String? imagePath,
    IconData? categoryIcon,
    String? categoryName,
    DateTime? creationDate,
    int? pageId,
    bool? isSelected,
    bool? isMarked,
  }) =>
      Event(
        id: id ?? this.id,
        eventData: eventData ?? this.eventData,
        imagePath: imagePath ?? this.imagePath,
        categoryIcon: categoryIcon ?? this.categoryIcon,
        categoryName: categoryName ?? this.categoryName,
        creationDate: creationDate ?? this.creationDate,
        pageId: pageId ?? this.pageId,
        isSelected: isSelected ?? this.isSelected,
        isMarked: isMarked ?? this.isMarked,
      );
}