import 'dart:io';

import 'section.dart';

class Event {
  String text;
  bool isBookmarked;
  bool isSelected;
  File? image;
  Section? section;

  Event({
    required this.text,
    required this.isBookmarked,
    required this.image,
    this.isSelected = false,
    this.section,
  });
}
