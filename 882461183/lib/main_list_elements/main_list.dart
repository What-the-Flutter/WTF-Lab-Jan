import 'package:flutter/material.dart';

import '/main_list_elements/list_elements.dart';
import 'chat_bot_list_element.dart';

class MainList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 10),
        ChatBotListElement(),
        MainListElement(
          icon: Icons.flight_takeoff,
          elementName: 'Travel',
          elementSubname: 'No events. Click to create one.',
        ),
        MainListElement(
          icon: Icons.weekend,
          elementName: 'Family',
          elementSubname: 'No events. Click to create one.',
        ),
        MainListElement(
          icon: Icons.fitness_center,
          elementName: 'Sports',
          elementSubname: 'No events. Click to create one.',
        ),
      ],
    );
  }
}
