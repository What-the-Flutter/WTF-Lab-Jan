import 'package:flutter/material.dart';
import '../../../../constants/icon_map.dart';

import '../../../../core/models/event_type.dart';
import '../../../../core/services/db/db_helper.dart';

class EventTypeAdd extends StatefulWidget {
  static const routeName = '/EventTypeAddScreen';

  @override
  _EventTypeAddState createState() => _EventTypeAddState();
}

class _EventTypeAddState extends State<EventTypeAdd> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final EventType eventType = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    eventType.id == null ? 'Create a new Page' : 'Edit page',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: eventType.title ?? 'Name of the page ',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 5,
                children: [
                  for (var icon in iconMap.entries)
                    Ink(
                      decoration: ShapeDecoration(
                        color: eventType.icon == icon.key
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(
                          icon.value,
                        ),
                        disabledColor: Colors.amber,
                        iconSize: 40,
                        hoverColor: Colors.green,
                        autofocus: true,
                        onPressed: () {
                          setState(
                            () {
                              eventType.icon = icon.key;
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          eventType.id == null ? Icons.add : Icons.done,
        ),
        onPressed: () {
          eventType.title = myController.text;
          eventType.date ??= DateTime.now();
          DBProvider.db.upsertEventType(eventType);
          Navigator.pop(context);
        },
      ),
    );
  }
}
