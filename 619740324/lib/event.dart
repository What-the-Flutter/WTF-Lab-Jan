import 'package:flutter/material.dart';

class Event {
  CircleAvatar circleAvatar;
  String text;
  String time;
  bool isSelected;

  Event({this.text, this.time, this.isSelected,this.circleAvatar});
}
