import 'dart:io';

import 'package:flutter/material.dart';

class Event {
  final DateTime time;
  String text;
  bool isFavorite;
  bool isEdit;
  File? image;
  IconData? icon;
  Event(
      {required this.time,
      required this.text,
      required this.isFavorite,
      required this.isEdit,
      required this.image,
      required this.icon});
}
