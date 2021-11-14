import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../domain/entities/event.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final focusNode = FocusNode();
  final events = <Event>[];
  TextEditingController messageController = TextEditingController();
  int selectedMessageIndex = -1;
  bool isCRUDMode = false;

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: isCRUDMode == false ? const Text('Test') : Container(),
          centerTitle: true,
          actions: _appBarActions,
        ),
        body: Column(
          children: [
            events.isEmpty ? _hintMessageBox() : _eventList(),
            _messageBar(),
          ],
        ),
      ),
    );
  }

  List<Widget> get _appBarActions {
    if (isCRUDMode) {
      return [
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
      return [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border),
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
    unfocus();
  }

  void unfocus() {
    isCRUDMode = false;
    selectedMessageIndex = -1;
    setState(() {});
  }

  void _bookmarkEvent() {
    // реализация переключения состояния (bookmarked/unbookmarked)
    // если true true или false false то 0
    // если true false или false ture то 1
    events[selectedMessageIndex].isBookmarked ^= true;
    unfocus();
  }

  void _deleteEvent() {
    events.removeAt(selectedMessageIndex);
    unfocus();
  }

  Widget _hintMessageBox() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'This is the Test page!',
                    ),
                    TextSpan(
                      text: '\n\nAdd you first event to "Test" page by '
                          'entering some text in the text box below '
                          'and hitting the send button. Long tap the '
                          'send button to align the event in the '
                          'opposite direction. Tap on the bookmark '
                          'icon on the top right corner to show the '
                          'bookmarked events only',
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
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
              isCRUDMode ^= true;
              setState(() {});
              selectedMessageIndex = isCRUDMode == true ? index : -1;
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      color: selectedMessageIndex != index
                          ? Theme.of(context).dialogBackgroundColor
                          : Theme.of(context).selectedRowColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        events[index].message != null
                            ? Text(
                                events[index].message!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              )
                            : Container(
                                width: 150,
                                height: 150,
                                child: Image.file(events[index].image!),
                              ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              events[index].sendTime,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(width: 4),
                            events[index].isBookmarked
                                ? Icon(
                              Icons.bookmark_add,
                              color: Colors.orange[800],
                            )
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
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
              Icons.event,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              color: Colors.black.withOpacity(0.1),
              child: TextField(
                focusNode: focusNode,
                controller: messageController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: InputBorder.none,
                  hintText: 'Enter Event',
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              //Icons.send,
              focusNode.hasFocus ? Icons.send : Icons.add_a_photo,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: focusNode.hasFocus ? _addMessageEvent : _addImageEvent,
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
    messageController.clear();
    setState(() {});
  }
}
