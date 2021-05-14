import 'dart:core';

class Message{
  final DateTime time = DateTime.now();
  final String text;
  bool selected;
  Message({this.text="",this.selected = false});
  @override
  String toString() {
    return text;
  }
}