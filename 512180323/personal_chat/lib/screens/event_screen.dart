import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/event_screen_widgets/my_body_event.dart';

class EventScreen extends StatelessWidget {
  final String appBarTitle;

  EventScreen({@required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pinkBg,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: pinkBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: myBoxContainer(
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_outlined),
              color: blue,
            ),
            const Offset(2, 2),
          ),
        ),
        title: Text(
          appBarTitle,
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          myBoxContainer(
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              color: blue,
            ),
            const Offset(-2, 2),
          ),
          myBoxContainer(
            IconButton(
              icon: const Icon(Icons.bookmark_border_outlined),
              color: blue,
              onPressed: () {},
            ),
            const Offset(-2, 2),
          ),
        ],
      ),
      body: const MyBodyEvent(),
    );
  }

  Widget myBoxContainer(IconButton icon, Offset offset) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: pinkDecor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: Colors.grey,
            offset: offset,
          ),
        ],
      ),
      child: icon,
    );
  }
}
