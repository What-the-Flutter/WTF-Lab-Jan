import 'package:flutter/material.dart';

import '../models/event_model.dart';
import 'event_message.dart';

class EventList extends StatefulWidget {
  final List<EventModel> events;
  final void Function(int, bool) toggleAppBar;

  const EventList({
    Key? key,
    required this.events,
    required this.toggleAppBar,
  }) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: widget.events.length,
      itemBuilder: (context, index) {
        return EventMessage(
          index: index,
          text: widget.events[index].text,
          date: widget.events[index].date,
          toggleAppBar: widget.toggleAppBar,
        );
      },
    );
  }
}
