import 'dart:io';

class Record {
  String message;
  File image;

  bool isSelected = false;
  bool isFavorite = false;

  Record(this.message, {this.image});

  void select() => isSelected = true;
  void unselect() => isSelected = false;

  void favorite() => isFavorite = true;
  void unfavorite() => isFavorite = false;

  @override
  String toString() {
    return message;
  }
}
