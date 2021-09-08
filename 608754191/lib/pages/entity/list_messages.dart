import 'package:flutter/material.dart';

class Message {
  int id;
  String text;
  DateTime time;

  @required
  Message(this.id, this.time, this.text);
}
