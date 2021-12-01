import 'package:flutter/material.dart';

class Event {
  final String id;
  final String eventData;
  final String imagePath;
  final DateTime creationDate;
  final IconData? categoryIcon;
  final String? categoryName;
  final String pageId;
  final bool isSelected;
  final bool isMarked;

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
    String? id,
    String? eventData,
    String? imagePath,
    IconData? categoryIcon,
    String? categoryName,
    DateTime? creationDate,
    String? pageId,
    bool? isSelected,
    bool? isMarked,
  }) {
    return Event(
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

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      eventData: map['event_data'],
      imagePath: map['image_path'],
      categoryIcon: map['category_icon'] != null
          ? IconData(int.parse(map['category_icon']),
          fontFamily: 'MaterialIcons')
          : null,
      categoryName: map['category_name'],
      creationDate: DateTime.parse(map['creation_date']),
      pageId: map['page_id'],
      isSelected: map['is_selected'] == 1 ? true : false,
      isMarked: map['is_marked'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_data': eventData,
      'image_path': imagePath,
      'category_icon': categoryIcon != null ? categoryIcon!.codePoint : null,
      'category_name': categoryName,
      'creation_date': creationDate.toString(),
      'page_id': pageId,
      'is_selected': isSelected ? 1 : 0,
      'is_marked': isMarked ? 1 : 0,
    };
  }
}
