import 'package:flutter/material.dart';
import 'message_model.dart';

class Chat {
  final IconData icon;
  final String title;
  String? subtitle;
  String? time;
  List<Message>? messageBase;

  Chat({required this.icon, required this.title, List<Message>? messageBase}) {
    // ignore: prefer_initializing_formals
    this.messageBase = messageBase;

    if (messageBase != null) {
      subtitle = messageBase.last.message;
      time = messageBase.last.time.fromNow();
    } else {
     subtitle = 'No events. Click to create one';
      time = '';
    }
  }
}

List<Chat> chats = [
  Chat(
    icon: Icons.airplanemode_active,
    title: 'Travel',
    messageBase: travel,
  ),
  Chat(
    icon: Icons.book_rounded,
    title: 'Journal',
    messageBase: null,
  ),
  Chat(
    icon: Icons.nature_people,
    title: 'Communication',
    messageBase: null,
  ),
];
