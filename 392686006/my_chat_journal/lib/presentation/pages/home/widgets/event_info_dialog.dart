import 'package:flutter/material.dart';
import '../../../../domain/entities/event.dart';

class EventInfoDialog extends StatelessWidget {
  const EventInfoDialog({
    Key? key,
    required this.events,
    required this.index,
  }) : super(key: key);

  final List<Event> events;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: events[index].icon,
              radius: 32,
              backgroundColor: Theme.of(context).cardColor,
            ),
            title: Text(
              events[index].title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Created'),
                Text(events[index].createDate),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Latest Event'),
                Text(events[index].lastEditDate),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: ElevatedButton(
            child: Text(
              'OK',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).scaffoldBackgroundColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
