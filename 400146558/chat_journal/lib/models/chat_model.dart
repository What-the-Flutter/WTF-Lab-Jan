import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'message_model.dart';

class Chat {
  IconData icon;
  String title;
  final int myIndex;
  bool isPinned = false;
  Jiffy? time;
  List<Message>? messageBase;

  Chat(
      {required this.icon,
      required this.time,
      required this.title,
      required this.myIndex,
      required this.messageBase});
}
