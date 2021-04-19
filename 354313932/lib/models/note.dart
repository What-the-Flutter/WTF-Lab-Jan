import 'package:flutter/material.dart';

import 'event.dart';

class Note {
  int id;
  Icon icon;
  String title;
  String subtitle;
  final List<Event> events = <Event>[];

  Note({this.id, this.icon, this.title, this.subtitle});
}

List notes = [
  Note(
    id: 1,
    icon: Icon(
      Icons.flight_takeoff,
      color: Colors.white,
    ),
    title: 'Travel',
    subtitle: 'No Events. Click to create one.',
  ),
  Note(
    id: 2,
    icon: Icon(
      Icons.weekend,
      color: Colors.white,
    ),
    title: 'Family',
    subtitle: 'No Events. Click to create one.',
  ),
  Note(
    id: 3,
    icon: Icon(
      Icons.fitness_center,
      color: Colors.white,
    ),
    title: 'Sports',
    subtitle: 'No Events. Click to create one.',
  )
];
