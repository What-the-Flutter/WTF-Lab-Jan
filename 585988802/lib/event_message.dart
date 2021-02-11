import 'package:flutter/cupertino.dart';

class EventMessage {
  // String nameOfSuggestion;
  String time;
  String text;
  bool isFavorite;
  FileImage image;
  bool isImageMessage;

  EventMessage(this.time, this.text, this.isFavorite,
      this.isImageMessage,
      [this.image]);
}
