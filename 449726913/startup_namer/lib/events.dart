import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'event_page.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  TextEditingController textEditingController = TextEditingController();
   final FocusNode focusNode = FocusNode();
  int selectedIndex = 0;
  bool isSelected = false;
  final events = <Event>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSelected ? appBarMenu() : defaultAppMenu(),
      body: Column(
        children: [
          events.isEmpty ? _defaultMessageBox() : _eventList(), _messageBar(),
        ],
      ),
    );
  }

  AppBar defaultAppMenu() {
    {
      return AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: const Center(
          child: Text(
            'Travel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: _editEvent,
            color: Colors.black,
          ),
        ],
      );
    }
  }

  AppBar appBarMenu() {
    {
      return AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: const Center(
          child: Text(
            'Travel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editEvent,
            color: Colors.black,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {_copyEvent(); changeSelect();},
            color: Colors.black,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: (){ _deleteEvent(); changeSelect();},
            color: Colors.black,
          ),
        ],
      );
    }
  }
  void changeSelect() {
    setState(() {
      isSelected = false;
      selectedIndex = -1;
    });
  }
  void _addMessageEvent() {
    events.insert(
      0,
      Event(
        message: textEditingController.text,
        time: DateFormat('kk:mm').format(DateTime.now()),
      ),
    );
    textEditingController.clear();
    setState(() {});
  }

  void _editEvent() {
    isSelected = true;
    textEditingController.text = events[selectedIndex].message!;

  }

  void _copyEvent() {
    Clipboard.setData(
      ClipboardData(text: events[selectedIndex].message),
    );
    setState(() {});
  }

  void _deleteEvent() {
    events.removeAt(selectedIndex);
    setState(() {});
  }

  // ignore: non_constant_identifier_names
  Widget _defaultMessageBox() {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25,),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20,),
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
              isSelected = true;
              setState(() {});
              selectedIndex = index;
            },
            child: Row(
              children: [_eventListElement(index, context)],
            ),
          );
        },
      ),
    );
  }

  Container _eventListElement(int index, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: selectedIndex != index
            ? Theme.of(context).dialogBackgroundColor
            : Theme.of(context).buttonColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10,),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          events[index].message != null
              ? Row(
                  children: [
                    Text(
                      events[index].message!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      child: Image.file(events[index].image!),
                    ),
                  ],
                ),
          const SizedBox(width: 5),
          Text(events[index].time!,
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ],
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
                controller: textEditingController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                  hintText: 'Type something...',
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
    final imagePicker = ImagePicker();
    final xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      File? imageFile = File(xFile.path);
      events.insert(0, Event(image: imageFile));
      setState(() {});
    }
  }


}
