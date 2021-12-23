import 'package:flutter/cupertino.dart';

class NoteModel {
  final String heading;
  late String data;
  late bool isFavorite;
  late bool isSearched;
  bool isChecked = false;
  late IconData icon;

  NoteModel({
    required this.heading,
    required this.data,
    required this.icon,
  }) {
    isFavorite = false;
    isSearched = false;
  }
}
