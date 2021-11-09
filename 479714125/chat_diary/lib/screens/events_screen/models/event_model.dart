import 'dart:io';

class EventModel {
  String? text;
  File? image;
  bool isSelected;

  final String date;

  EventModel({
    this.text,
    this.image,
    required this.date,
    this.isSelected = false,
  });

  @override
  String toString() => '$text $isSelected';
}
