import 'package:flutter/material.dart';

import 'item_message.dart';

class ChatPage {
  final String id;
  String title;
  IconData icon;
  final DateTime createdTime;
  DateTime lastUpdate;

  bool fixed;
  List<ItemMessage> messages = List.empty(growable: true);

  ChatPage({
    required this.id,
    required this.title,
    required this.icon,
    required this.createdTime,
    required this.lastUpdate,
    this.fixed = false,
  });
}
