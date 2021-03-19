import 'package:flutter/material.dart';
import 'event.dart';

class NotePage {
  Text title;
  Text subtitle;
  CircleAvatar icon;
  final List<Event> eventList = <Event>[];

  NotePage(this.title, this.subtitle, this.icon);
}
