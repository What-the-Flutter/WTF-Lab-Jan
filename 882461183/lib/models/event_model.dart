import 'package:flutter/material.dart';

class Event {
  final String id;
  final String chatId;
  final String text;
  final String imagePath;
  final DateTime date;
  final bool isSelected;
  final bool isFavorite;
  final String? categoryName;
  final IconData? categoryIcon;

  Event({
    required this.id,
    required this.chatId,
    required this.text,
    required this.date,
    this.imagePath = '',
    this.isFavorite = false,
    this.isSelected = false,
    this.categoryName,
    this.categoryIcon,
  });

  Event copyWith({
    String? id,
    String? chatId,
    bool? isSelected,
    bool? isFavorite,
    String? text,
  }) {
    return Event(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      date: date,
      text: text ?? this.text,
      isFavorite: isFavorite ?? this.isFavorite,
      isSelected: isSelected ?? this.isSelected,
      imagePath: imagePath,
      categoryIcon: categoryIcon,
      categoryName: categoryName,
    );
  }

  factory Event.fromMap(Map<String, dynamic> map) => Event(
        id: map['id'],
        chatId: map['chat_id'],
        date: DateTime.parse(map['date']),
        text: map['text'],
        imagePath: map['image_path'],
        categoryIcon: map['category_icon'] != null
            ? IconData(
                int.parse(map['category_icon']),
                fontFamily: 'MaterialIcons',
              )
            : null,
        isFavorite: map['is_favorite'] == 1 ? true : false,
        isSelected: map['is_selected'] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat_id': chatId,
      'date': date.toString(),
      'text': text,
      'image_path': imagePath,
      'category_icon': categoryIcon?.codePoint,
      'category_name': categoryName,
      'is_selected': isSelected ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }
}
