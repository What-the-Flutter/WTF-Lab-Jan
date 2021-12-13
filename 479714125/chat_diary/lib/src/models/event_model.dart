import 'dart:io';

import 'package:flutter/material.dart';

class EventModel {
  final int id;
  String? text;
  File? image;
  bool isSelected;
  IconData? category;

  final String date;

  EventModel({
    required this.id,
    required this.date,
    this.text,
    this.image,
    this.category,
    this.isSelected = false,
  });

  @override
  String toString() => '$text $isSelected';
}
