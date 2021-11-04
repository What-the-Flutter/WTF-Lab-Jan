import 'package:flutter/material.dart';

class MessageData {
  String mText;
  TimeOfDay datetime;
  bool liked;
  bool deleted;

  MessageData(
      {required this.mText,
      required this.datetime,
      this.liked = false,
      this.deleted = false});
}
