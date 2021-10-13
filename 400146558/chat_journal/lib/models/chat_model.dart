import 'package:flutter/material.dart';

class Chat {
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final String? time;

  Chat({
    this.icon,
    this.title,
    this.subtitle,
    this.time,
  });
}

List<Chat> chats = [
  Chat(
    icon: Icons.airplanemode_active,
    title: 'Travel',
    subtitle: 'No events. Click to create one',
    time: '',
  ),
  Chat(
    icon: Icons.book_rounded,
    title: 'Journal',
    subtitle: 'No events. Click to create one',
    time: '',
  ),
  Chat(
    icon: Icons.nature_people,
    title: 'Travel',
    subtitle: 'No events. Click to create one',
    time: '',
  ),
];
