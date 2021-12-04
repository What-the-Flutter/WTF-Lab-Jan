import 'package:flutter/material.dart';
import '../../../../domain/entities/event.dart';

class EventListElement extends StatelessWidget {
  const EventListElement({
    Key? key,
    required this.context,
    required this.page,
  }) : super(key: key);

  final BuildContext context;
  final Event page;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                child: page.icon,
                radius: 28,
                backgroundColor: Theme.of(context).cardColor,
              ),
              if (page.isPinned)
                const Icon(
                  Icons.push_pin,
                  size: 15,
                  color: Colors.black54,
                ),
            ],
          ),
          title: Text(
            page.title,
            style: const TextStyle(fontSize: 25),
          ),
          subtitle: Text(page.lastMessage),
        ),
        const Divider(),
      ],
    );
  }
}
