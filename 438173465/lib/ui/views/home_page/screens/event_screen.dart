import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/models/event.dart';
import '../../../../core/models/event_type.dart';
import '../../../../core/services/db/db_helper.dart';
import '../../../shared/utils/edit_notification.dart';
import '../widgets/event_list.dart';
import '../widgets/message_textfield.dart';

class EventScreen extends StatefulWidget {
  static const routeName = '/EventScreen';

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final picker = ImagePicker();
  Event event = Event();
  File image;
  bool favorite;

  @override
  void initState() {
    super.initState();
    favorite = false;
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
            icon: Icon(
              favorite == true ? Icons.favorite : Icons.favorite_outline,
            ),
            onPressed: () {
              setState(() {
                favorite = !favorite;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          NotificationListener<EditNotification>(
            onNotification: (notification) {
              event.id = notification.id;
              event.date = notification.date;
              return;
            },
            child: Column(
              children: [
                eventList(
                  favorite: favorite,
                  eventType: eventType,
                  textController: myController,
                ),
                messageTextField(
                  onPressedButton: () {
                    event
                      ..typeId = eventType.id
                      ..message = myController.text
                      ..favorite = 0;
                    event.date ??= DateTime.now();
                    DBProvider.db.upsertEvent(event);
                    event = Event();
                    setState(() {});
                  },
                  image: image,
                  picker: picker,
                  controller: myController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
