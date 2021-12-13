import 'dart:io';

import 'package:flutter/material.dart';

class EventModel {
  int id;
  int pageId;
  String? text;
  File? image;
  bool isSelected;
  IconData? category;

  final String date;

  EventModel({
    required this.pageId,
    required this.id,
    required this.date,
    this.text,
    this.image,
    this.category,
    this.isSelected = false,
  });

  @override
  String toString() => '$id $text $isSelected ${image?.path}';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageId': pageId,
      'text': text,
      'image': image != null ? image!.path : 'null',
      'date': date,
      'isSelected': isSelected ? 1 : 0,
      'category': category != null ? category!.codePoint : 0,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> eventMap) {
    return EventModel(
      pageId: eventMap['pageId'] as int,
      id: eventMap['id'] as int,
      date: eventMap['date'] as String,
      text: eventMap['text'] as String,
      image: eventMap['image'] != 'null'
          ? File(eventMap['image'].toString())
          : null,
      isSelected: eventMap['isSelected'] == 1 ? true : false,
      category: eventMap['category'] != 0
          ? IconData(int.parse(eventMap['category']))
          : null,
    );
  }
}
