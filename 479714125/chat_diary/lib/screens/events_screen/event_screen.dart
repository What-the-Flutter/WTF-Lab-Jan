import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'models/event_model.dart';
import 'widgets/event_input_field.dart';
import 'widgets/event_list.dart';

class EventScreen extends StatefulWidget {
  final String title;

  const EventScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _events = <EventModel>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppColors.bluePurple,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: EventList(
              events: _events,
            ),
          ),
          EventInputField(
            addEvent: addEvent,
          ),
        ],
      ),
    );
  }

  void addEvent(EventModel model) {
    _events.insert(0, model);
    setState(() {});
  }
}
