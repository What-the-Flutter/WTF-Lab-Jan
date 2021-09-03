import 'package:flutter/material.dart';
import 'event.dart';

class Category{
  String name;
  IconData iconData;
  DateTime createdTime;
  List<Event> eventList;

  Category({
    required this.name,
    required this.iconData,
    required this.createdTime,
  }) : eventList = <Event>[];
}