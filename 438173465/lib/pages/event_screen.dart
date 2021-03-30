import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../db/db_helper.dart';
import '../models/event.dart';
import '../models/event_type.dart';
import '../theme_changer.dart';

class EventScreen extends StatefulWidget {
  static const routeName = '/EventScreen';

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  DateTime today;
  DateTime yesterday;
  DateTime tomorrow;
  int selectedIndex = -1;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    final EventType eventType = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(eventType.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                child: FutureBuilder<List<Event>>(
                  future: DBProvider.db.fetchEventsList(eventType),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GroupedListView(
                        elements: snapshot.data,
                        reverse: true,
                        itemBuilder: (context, element) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 5, bottom: 5),
                            child: PopupMenuButton(
                              onSelected: (index) {
                                switch (index) {
                                  case 1:
                                    {
                                      Clipboard.setData(
                                          ClipboardData(text: element.message));
                                      break;
                                    }
                                  case 2:
                                    {
                                      DBProvider.db.deleteEvent(element.id);
                                      break;
                                    }
                                }
                              },
                              initialValue: element.id,
                              itemBuilder: (context) => <PopupMenuItem>[
                                PopupMenuItem(
                                  value: 1,
                                  child: Text('Copy'),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Text('Delete'),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  child: Text('Edit'),
                                ),
                              ],
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ThemeBuilder.of(context)
                                                .getCurrentTheme() ==
                                            Brightness.light
                                        ? Colors.grey.shade200
                                        : Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.all(9),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(element.message),
                                      Text(
                                        ' ${DateFormat.jm().format(element.date)}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 8),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        groupBy: (element) => DateTime(element.date.year,
                            element.date.month, element.date.day),
                        groupComparator: (value1, value2) =>
                            value2.compareTo(value1),
                        order: GroupedListOrder.ASC,
                        groupHeaderBuilder: (element) => Container(
                          padding: EdgeInsets.only(
                              left: 14, right: 14, top: 5, bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              padding: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(7),
                                  bottomLeft: Radius.circular(7),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: dateFormatter(element.date),
                            ),
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 300),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.orange[100],
                                ),
                                padding: EdgeInsets.all(20.0),
                                alignment: Alignment.center,
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text:
                                          'This is the page where you can track everything about "${eventType.title}"\n\n',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                'Add you first event to "${eventType.title}" page by entering some text in the text box below and hitting the send button. Long tap he send button to align the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookmarked events only',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    ))),
                          ),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: (Icon(
                        Icons.add,
                        size: 30,
                      )),
                      onPressed: () {
                        print('tap');
                        getImage();
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                            hintText: 'Write message...',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        DBProvider.db.upsertEvent(
                          Event(
                            typeId: eventType.id,
                            message: myController.text,
                            date: DateTime.now(),
                          ),
                        );
                        setState(() {});
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Text dateFormatter(DateTime date) {
    final now = DateTime.now();
    final dif = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    switch (dif) {
      case -1:
        return Text('Yesterday');
      case 0:
        return Text('Today');
      default:
        return Text(
          '${DateFormat.MMMd().format(date)}',
        );
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
