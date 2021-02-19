import 'package:flutter/cupertino.dart';
import 'category.dart';

class EventMessage {
  String time;
  String text;
  bool isFavorite;
  FileImage image;
  bool isImageMessage;
  Category category;

  EventMessage(this.time, this.text, this.isFavorite, this.isImageMessage,
      [this.image, this.category]);
}
