import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../modules/event_page.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  TextEditingController messageController = TextEditingController();
  int selectedMessageIndex = -1;
  bool isCRUDMode = false;
  final events = <Event>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Center(
          child: Text('Travel'),
        ),
        actions: _appBarActions,
      ),
      body: Column(
        children: [
          events.isEmpty ? _hintMessageBox() : _eventList(),
          _messageBar(),
        ],
      ),
    );
  }

  List<Widget> get _appBarActions {
    if (isCRUDMode) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _editEvent,
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: _copyEvent,
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: _bookmarkEvent,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _deleteEvent,
        ),
      ];
    } else {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
      ];
    }
  }

  void _editEvent() {
    if (events[selectedMessageIndex].message == null) {
      selectedMessageIndex = -1;
    } else {
      messageController.text = events[selectedMessageIndex].message!;
    }
    isCRUDMode = false;
  }

  void _copyEvent() {
    if (events[selectedMessageIndex].message != null) {
      Clipboard.setData(
        ClipboardData(text: events[selectedMessageIndex].message),
      );
    }
    isCRUDMode = false;
    selectedMessageIndex = -1;
    setState(() {});
  }

  void _bookmarkEvent() {
    events[selectedMessageIndex].isBookmarked ^= true;
    isCRUDMode = false;
    selectedMessageIndex = -1;
    setState(() {});
  }

  void _deleteEvent() {
    events.removeAt(selectedMessageIndex);
    isCRUDMode = false;
    selectedMessageIndex = -1;
    setState(() {});
  }

  Widget _hintMessageBox() {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'This is the page where yo can track '
                        'everything about "Travel"!\n\n',
                  ),
                  TextSpan(
                    text: 'Add you first event to "Travel" page by '
                        'entering some text in the text box below '
                        'and hitting the send button. Long tap the '
                        'send button to align the event in the '
                        'opposite direction. Tap on the bookmark '
                        'icon on the top right corner to show the '
                        'bookmarked events only',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventList() {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: events.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              isCRUDMode = true;
              setState(() {});
              selectedMessageIndex = index;
            },
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: selectedMessageIndex != index
                        ? Theme.of(context).dialogBackgroundColor
                        : Theme.of(context).selectedRowColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      events[index].isBookmarked
                          ? Icon(
                              Icons.star,
                              color: Colors.orange[700],
                            )
                          : const SizedBox(),
                      events[index].message != null
                          ? Text(
                              events[index].message!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            )
                          : Container(
                              width: 150,
                              height: 150,
                              child: Image.file(events[index].image!),
                            ),
                      const SizedBox(width: 5),
                      Text(
                        events[index].sendTime,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _messageBar() {
    return Container(
      margin: const EdgeInsets.all(7),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _addImageEvent,
          ),
          Expanded(
            child: Container(
              color: Colors.black.withOpacity(0.07),
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                  hintText: 'Enter Event',
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _addMessageEvent,
          ),
        ],
      ),
    );
  }

  Future<void> _addImageEvent() async {
    final ip = ImagePicker();
    final xFile = await ip.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      File? imageFile = File(xFile.path);
      events.insert(0, Event(image: imageFile));
      setState(() {});
    }
  }

  void _addMessageEvent() {
    if (selectedMessageIndex != -1) {
      if (messageController.text.isEmpty) {
        events.removeAt(selectedMessageIndex);
      } else {
        events[selectedMessageIndex].message = messageController.text;
        events[selectedMessageIndex].updateSendTime();
      }
      selectedMessageIndex = -1;
    } else if (messageController.text.isNotEmpty) {
      events.insert(
        0,
        Event(
          message: messageController.text,
        ),
      );
    }
    selectedMessageIndex = -1;
    messageController.clear();
    setState(() {});
  }
}
