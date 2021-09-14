import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/event_screen_widgets/body_event.dart';

class EventScreen extends StatelessWidget {
  final String appBarTitle;

  EventScreen({@required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: boxContainer(
            context,
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_outlined),
              color: Theme.of(context).accentColor,
            ),
            const Offset(2, 2),
          ),
        ),
        title: Text(
          appBarTitle,
          style: const TextStyle(color: appBarText),
        ),
        actions: [
          boxContainer(
            context,
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
            const Offset(-2, 2),
          ),
          boxContainer(
            context,
            IconButton(
              icon: const Icon(Icons.bookmark_border_outlined),
              color: Theme.of(context).accentColor,
              onPressed: () {},
            ),
            const Offset(-2, 2),
          ),
        ],
      ),
      body: const BodyEvent(),
    );
  }

  Widget boxContainer(BuildContext context, IconButton icon, Offset offset) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: shadowColor,
            offset: offset,
          ),
        ],
      ),
      child: icon,
    );
  }
}
