import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/event_type.dart';

class EventTypeAdd extends StatefulWidget {
  @override
  _EventTypeAddState createState() => _EventTypeAddState();
}

class _EventTypeAddState extends State<EventTypeAdd> {
  final myController = TextEditingController();
  final myController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add event type'),
      ),
      body: Column(
        children: [
          TextField(
            controller: myController,
            decoration: const InputDecoration(
              hintText: 'Enter your Title',
            ),
          ),
          TextField(
            controller: myController2,
            decoration: const InputDecoration(
              hintText: 'Enter your icon',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          DBProvider.db.upsertEventType(
            EventType(
              title: myController.text,
              icon: myController2.text,
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
