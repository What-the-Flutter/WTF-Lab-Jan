import 'package:flutter/material.dart';

class Journal {
  String title;
  List<Note> note;
  int iconIndex;

  Journal({
    required this.title,
    required this.iconIndex,
    required this.note,
  });
}

class Note {
  String time;
  bool isBookmarked;
  String description;
  IconData? icon;

  Note({
    required this.time,
    required this.isBookmarked,
    required this.description,
    this.icon
  });
}
