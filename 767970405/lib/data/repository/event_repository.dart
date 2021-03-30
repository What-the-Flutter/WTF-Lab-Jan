import 'package:flutter/material.dart';

class EventRepository {
  final List<Event> events = <Event>[
    Event(
      iconData: Icons.directions_run,
      label: 'Running',
    ),
    Event(
      iconData: Icons.sports_basketball,
      label: 'Sports',
    ),
    Event(
      iconData: Icons.local_movies,
      label: 'Movie',
    ),
    Event(
      iconData: Icons.fastfood,
      label: 'FastFood',
    ),
    Event(
      iconData: Icons.fitness_center,
      label: 'Workout',
    ),
    Event(
      iconData: Icons.local_laundry_service,
      label: 'Laundry',
    ),
  ];
}

class Event {
  final IconData iconData;
  final String label;

  Event({
    this.iconData,
    this.label,
  });
}
