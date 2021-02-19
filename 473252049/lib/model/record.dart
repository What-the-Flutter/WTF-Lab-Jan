import 'dart:io';

class Record {
  String message;
  File image;

  bool isHighlighted = false;
  bool isFavorite = false;

  Record(this.message, {this.image});

  bool get isNotHighlighted => !isHighlighted;
  bool get isNotFavorite => !isFavorite;

  void changeIsFavorite() {
    isFavorite = !isFavorite;
  }
}
