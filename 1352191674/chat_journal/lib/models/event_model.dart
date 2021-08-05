import 'dart:io';

class Event {
  final DateTime time;
  String text;
  bool isFavorite;
  bool isEdit;
  File? image;

  Event(
      {required this.time,
      required this.text,
      required this.isFavorite,
      required this.isEdit,
      required this.image});
}
