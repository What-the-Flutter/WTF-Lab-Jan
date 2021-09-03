import 'dart:io';

class Event {
  String text;
  bool isBookmarked;
  bool isEdit;
  bool isSelected;
  File? image;

  Event({
    required this.text,
    required this.isBookmarked,
    required this.isEdit,
    required this.isSelected,
    required this.image,
  });
}
