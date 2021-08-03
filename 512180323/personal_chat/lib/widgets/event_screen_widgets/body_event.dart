import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';

import '../../constants.dart';

class BodyEvent extends StatefulWidget {
  const BodyEvent({Key key}) : super(key: key);

  @override
  _BodyEventState createState() => _BodyEventState();
}

class _BodyEventState extends State<BodyEvent> {
  final _event = <Object>[];
  final _date = <String>[];
  final _controller = TextEditingController();
  int _eventIndex = 0;
  bool _editText = false;

  // This method for send our image.
  void _sendImg() async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (_editText) {
        _event.removeAt(_eventIndex);
        _date.removeAt(_eventIndex);
      }
      setState(() {
        _event.insert(_eventIndex, image);
        _date.insert(_eventIndex, Jiffy(DateTime.now()).format('h:mm a'));
      });
      _editText = false;
      _eventIndex = 0;
    }
  }

  // This method for send our message.
  void _sendMessage() {
    if (_editText) {
      _event.removeAt(_eventIndex);
      _date.removeAt(_eventIndex);
    }
    setState(() {
      _event.insert(_eventIndex, _controller.text);
      _date.insert(_eventIndex, Jiffy(DateTime.now()).format('h:mm a'));
    });
    _eventIndex = 0;
    _editText = false;
    _controller.clear();
  }

  // When we long press on event we call more functions: delete, edit, copy.
  void _moreFunctionsWithEvent(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.content_copy,
                color: Colors.red,
              ),
              title: const Text('Copy'),
              onTap: () {
                Clipboard.setData(
                  ClipboardData(
                    text: _event[index].toString(),
                  ),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.red,
              ),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                if (_event[index].toString() != "Instance of 'XFile'") {
                  _controller.text = _event[index].toString();
                  _editText = true;
                  _eventIndex = index;
                } else {
                  _editText = true;
                  _eventIndex = index;
                  _sendImg();
                }
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Delete'),
              onTap: () {
                _event.removeAt(index);
                _date.removeAt(index);
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Here we check - if Event is empty, we create a new body section.
        _event.isEmpty
            ? emptyBodyList()

            // Here is a list with different events.
            : bodyEventList(),

        // Here is the bottom section with textField widgets and various functions.
        bottomSection(context),
      ],
    );
  }

  Widget bottomSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Our first IconButton of bottomSection with more functions(get file in gallery).
          firstButtonOfSectionBottom(context),
          // Our TextField with decoration.
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, top: 4.0, right: 10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                minLines: 1,
                maxLines: 5,
                controller: _controller,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Enter Event...',
                  hintStyle: TextStyle(color: black),
                  border: InputBorder.none,
                ),
                cursorColor: white,
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ),
          // Here is the second button of BottomSection.
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                const BoxShadow(
                  blurRadius: 1,
                  color: shadowColor,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                _sendMessage();
              },
              icon: Icon(
                Icons.send_outlined,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget firstButtonOfSectionBottom(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            blurRadius: 1,
            color: shadowColor,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (builder) {
              return Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  margin: const EdgeInsets.all(18.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.add_photo_alternate_rounded),
                              ),
                              onTap: () {
                                _sendImg();
                              },
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            const Text('Gallery'),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: blue,
                                child: Icon(Icons.photo_camera),
                              ),
                              onTap: () {},
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            const Text('Camera'),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.green,
                                child: Icon(Icons.file_copy),
                              ),
                              onTap: () {},
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            const Text('File'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        icon: Icon(
          Icons.attach_file,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget bodyEventList() {
    return Flexible(
      child: ListView.builder(
        reverse: true,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(
              left: 15.0,
              top: 10.0,
              right: 30.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(25),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(0),
              ),
            ),
            child: ListTile(
              onLongPress: () => _moreFunctionsWithEvent(index),
              title: _event[index].toString() != "Instance of 'XFile'"
                  ? Text(
                      _event[index].toString(),
                      style: const TextStyle(fontSize: 14.0),
                    )
                  : Image.file(File((_event[index] as XFile).path)),
              subtitle: Text(
                _date[index],
                style: TextStyle(color: Colors.grey[400], fontSize: 10.0),
              ),
            ),
          );
        },
        itemCount: _event.length,
      ),
    );
  }

  Widget emptyBodyList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/cat_message.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              width: 300,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  const Text(
                    'This is the page where you can track'
                    ' everything about "..."',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Add your first event to "..."  page by'
                    ' entering some text in the text box below'
                    ' and hitting the send button. Long tap the'
                    ' send button to align the event in the'
                    ' opposite direction. Tap on the bookmark'
                    ' icon on the top right corner to show the'
                    ' bookmarked events only.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
