import 'package:chat_diary/screens/events_screen/widgets/event_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final _events = <EventModel>[
    EventModel(
      text: 'Hello, I am Maks',
      date: DateFormat.Hm().format(
        DateTime.now(),
      ),
    ),
    EventModel(
      text: 'sakjash ahjjhsdjkjsd dsfkjhsfhsd  ',
      date: DateFormat.Hm().format(
        DateTime.now(),
      ),
    ),
    EventModel(
      text: ' djasjdfdsbb skfdsfn askjsdwdmdd djdjdjdjdjd jdjdjd ',
      date: DateFormat.Hm().format(
        DateTime.now(),
      ),
    ),
    EventModel(
      text: 'dmddmmw',
      date: DateFormat.Hm().format(
        DateTime.now(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (context, index) {
        return EventMessage(
          text: _events[index].text,
          date: _events[index].date,
        );
      },
    );
  }
}
