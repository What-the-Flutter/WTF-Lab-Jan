import 'package:flutter/material.dart';

class EventPage {
  int id;
  Icon icon;
  String title;
  String subtitle;

  EventPage({this.id, this.icon, this.title, this.subtitle});
}

List eventPages = [
  EventPage(
    id: 1,
    icon: Icon(
      Icons.flight_takeoff,
      color: Colors.white,
    ),
    title: 'Travel',
    subtitle: 'No Events. Click to create one.',
  ),
  EventPage(
    id: 2,
    icon: Icon(
      Icons.weekend,
      color: Colors.white,
    ),
    title: 'Family',
    subtitle: 'No Events. Click to create one.',
  ),
  EventPage(
    id: 3,
    icon: Icon(
      Icons.fitness_center,
      color: Colors.white,
    ),
    title: 'Sports',
    subtitle: 'No Events. Click to create one.',
  )
];
