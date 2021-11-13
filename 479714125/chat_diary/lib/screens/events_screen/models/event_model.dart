import 'dart:io';

class EventModel {
  String? text;
  File? image;
  bool isSelected;

  final String date;

  EventModel({
    required this.date,
    this.text,
    this.image,
    this.isSelected = false,
  });

  @override
  String toString() => '$text $isSelected';
}
