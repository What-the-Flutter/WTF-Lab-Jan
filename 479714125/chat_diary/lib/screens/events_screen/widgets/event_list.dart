import 'package:flutter/material.dart';

import '../models/event_model.dart';
import 'event_message.dart';

class EventList extends StatelessWidget {
  final List<EventModel> events;
  final void Function(int, bool) toggleAppBar;

  const EventList({
    Key? key,
    required this.events,
    required this.toggleAppBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: events.length,
      itemBuilder: (context, index) => EventMessage(
        isSelected: events[index].isSelected,
        text: events[index].text,
        date: events[index].date,
        index: index,
        toggleAppBar: toggleAppBar,
      ),
    );
  }

  List<EventMessage> mapToEventMessage(List<EventModel> events) {
    final eventMessages = <EventMessage>[];
    for (var i = 0; i < events.length; i += 1) {
      final element = events[i];
      eventMessages.add(
        EventMessage(
          isSelected: element.isSelected,
          text: element.text,
          date: element.date,
          index: i,
          toggleAppBar: toggleAppBar,
        ),
      );
    }

    return eventMessages;
  }
}
