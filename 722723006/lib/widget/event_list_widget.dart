import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';

import '../event_page/event.dart';
import '../icon_list.dart';

class EventListWidget extends StatefulWidget {
  final Event event;
  final dynamic state;
  final Function(dynamic) onDismissed;
  final Function(String) onTap;
  final Function() onLongPressed;
  @override
  _EventListWidgetState createState() => _EventListWidgetState();

  EventListWidget(
    this.event,
    this.state, {
    this.onDismissed,
    this.onTap,
    this.onLongPressed,
  });
}

class _EventListWidgetState extends State<EventListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: Column(
        children: [
          _dateListTile(widget.event),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              elevation: 3,
              color: Theme.of(context).primaryColor,
              child: Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.green,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Icon(
                        Icons.edit,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onDismissed: widget.onDismissed,
                child: _eventListTile(widget.event),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventListTile(Event event) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      color: event.isSelected ? Colors.grey : Theme.of(context).primaryColor,
      child: ListTile(
        leading: event.indexOfCircleAvatar != null
            ? CircleAvatar(child: listOfIcons[event.indexOfCircleAvatar])
            : null,
        title: event.imagePath != null
            ? Image.file(File(event.imagePath))
            : HashTagText(
                text: event.text,
                basicStyle: TextStyle(color: Colors.white),
                decoratedStyle: TextStyle(color: Colors.yellow),
                onTap: widget.onTap,
              ),
        subtitle: Text(
          event.time,
          style: TextStyle(color: Colors.white54),
        ),
        trailing: event.isBookmarked ? Icon(Icons.bookmark) : null,
        onLongPress: widget.onLongPressed,
      ),
    );
  }

  Widget _dateListTile(Event event) {
    return ListTile(
      title: widget.state.isCenterDateBubble
          ? Center(child: Text(event.date))
          : Text(event.date),
    );
  }
}
