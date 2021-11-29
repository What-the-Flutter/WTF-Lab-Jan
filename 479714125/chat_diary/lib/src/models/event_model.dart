import 'dart:io';

import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
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

  @override
  List<Object?> get props => [text, image, isSelected];
}
