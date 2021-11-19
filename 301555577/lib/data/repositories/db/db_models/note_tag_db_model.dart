import 'package:flutter/material.dart';

class CategoryDbModel {
  final int? id;
  final String title;
  final IconData icon;

  CategoryDbModel({
    this.id,
    required this.title,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon.codePoint,
    };
  }

  factory CategoryDbModel.fromMap(Map<String, dynamic> map) {
    return CategoryDbModel(
      id: map['id'],
      title: map['title'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
    );
  }
}
