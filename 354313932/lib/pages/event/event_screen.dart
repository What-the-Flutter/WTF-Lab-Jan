import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../models/event.dart';
import '../../models/note.dart';

class EventScreen extends StatefulWidget {
  final Note note;
  final String title;

  const EventScreen({Key key, this.note, this.title}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState(note);
}

class _EventScreenState extends State<EventScreen> {
  final Note note;
  final TextEditingController eventController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final bool isEditingText = false;
  bool isEventSelected = true;
  bool isEditing = false;
  int selectedEventIndex = 0;

  _EventScreenState(this.note);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isEventSelected
          ? buildAppBar()
          : buildEditingAppBar(selectedEventIndex),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              reverse: true,
              itemCount: note.events.length,
              itemBuilder: (context, index) {
                selectedEventIndex = index;
                final event = note.events[index];
                return Container(
                  margin: EdgeInsets.only(left: kDefaultPadding * 2),
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  width: 100,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(kDefaultPadding),
                      topLeft: Radius.circular(kDefaultPadding),
                      bottomLeft: Radius.circular(kDefaultPadding),
                      bottomRight: Radius.circular(kDefaultPadding * 1.5),
                    ),
                    child: Card(
                      elevation: 2,
                      color: Color(0xFF05ffb4),
                      child: ListTile(
                        title: Text(event.text),
                        subtitle: Text(event.time),
                        onLongPress: () {
                          selectedEventIndex = index;
                          changeAppBar();
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: kDefaultPadding),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(15.0),
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3), blurRadius: 5, color: Colors.grey),
                ],
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.widgets_outlined),
                    color: Colors.blueGrey,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: eventController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          hintText: 'Type Something...',
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/attach_photo.svg',
                      width: 24,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      if (isEditing) {
                        setState(() {
                          editText(selectedEventIndex);
                        });
                      } else {
                        setState(sendEvent);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildEditingAppBar(int index, {int count}) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            changeAppBar();
          }),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              changeAppBar();
              editEvent(index);
            }),
        IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              changeAppBar();
              copyEvent(index);
            }),
        IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              changeAppBar();
            }),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              changeAppBar();
              deleteEvent(index);
            }),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color(0xFF5e1ef5),
      title: Text(widget.title),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.bookmark_border_outlined,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  void sendEvent() {
    note.events.insert(
      0,
      Event(
        text: eventController.text,
        time: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        isSelected: false,
      ),
    );
    eventController.clear();
  }

  void changeAppBar() {
    setState(() {
      isEventSelected = !isEventSelected;
    });
  }

  void editEvent(int index) {
    setState(() {
      isEditing = true;
      eventController.text = note.events[index].text;
      focusNode.requestFocus();
    });
  }

  void editText(int index) {
    note.events[index].text = eventController.text;
    eventController.clear();
    isEditing = false;
  }

  void copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: note.events[index].text));
  }

  void deleteEvent(int index) {
    note.events.removeAt(index);
  }
}
