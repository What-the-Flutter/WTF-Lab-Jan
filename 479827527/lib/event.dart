import 'package:flutter/material.dart';

class Event {
  CircleAvatar circleAvatar;
  String text;
  String time;
  bool isSelectedEvent;

  Event({this.text, this.time, this.isSelectedEvent, this.circleAvatar});
}
