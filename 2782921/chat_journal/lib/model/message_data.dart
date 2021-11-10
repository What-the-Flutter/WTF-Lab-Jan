import 'package:flutter/material.dart';

class MessageData {
  late String mText;
  late TimeOfDay datetime;
  bool liked;
  bool deleted;

  MessageData({
    required this.mText,
    required this.datetime,
    this.liked = false,
    this.deleted = false,
  });
}
