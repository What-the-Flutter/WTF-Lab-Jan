import 'dart:io';

class Record implements Comparable {
  String message;
  File image;
  final DateTime createDateTime;

  bool isSelected = false;
  bool isFavorite = false;

  Record(this.message, {this.image}) : createDateTime = DateTime.now();

  void select() => isSelected = true;
  void unselect() => isSelected = false;

  void favorite() => isFavorite = true;
  void unfavorite() => isFavorite = false;

  @override
  String toString() {
    return message;
  }

  @override
  int compareTo(Object other) {
    if (other is Record) {
      // comparision is reversed because records
      // are being inserted into the begin of records list in
      // categories
      return other.createDateTime.compareTo(createDateTime);
    }
    return 0;
  }
}
