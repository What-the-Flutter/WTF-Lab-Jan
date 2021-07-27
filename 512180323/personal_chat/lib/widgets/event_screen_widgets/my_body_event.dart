import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';

import '../../constants.dart';

class MyBodyEvent extends StatefulWidget {
  const MyBodyEvent({Key key}) : super(key: key);

  @override
  _MyBodyEventState createState() => _MyBodyEventState();
}

class _MyBodyEventState extends State<MyBodyEvent> {
  final _event = <Object>[];
  final List _date = <String>[];
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
            ? buildEmptyBodyList()

            // Here is a list with different events.
            : buildBodyEventList(),

        // Here is the bottom section with textField widgets and various functions.
        buildBottomSection(context),
      ],
    );
  }

  Container buildBottomSection(BuildContext context) {
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
                color: Colors.blue[100],
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
              color: pinkDecor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                const BoxShadow(
                  blurRadius: 1,
                  color: Colors.grey,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                _sendMessage();
              },
              icon: const Icon(
                Icons.send_outlined,
                color: blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container firstButtonOfSectionBottom(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        color: pinkDecor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            blurRadius: 1,
            color: Colors.grey,
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
        icon: const Icon(
          Icons.attach_file,
          color: blue,
        ),
      ),
    );
  }

  Expanded buildBodyEventList() {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(
              left: 15.0,
              top: 10.0,
              right: 30.0,
            ),
            decoration: const BoxDecoration(
              color: pinkDecor,
              borderRadius: BorderRadius.only(
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

  Expanded buildEmptyBodyList() {
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
                color: pinkDecor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  const Text(
                    'This is the page where you can track'
                    ' everything about "..."',
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
                    style: TextStyle(
                      color: Colors.grey[700],
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

  Widget iconCreating(Color bgColor, Icon icon, String nameIcon, void tap) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            tap;
          },
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 30,
            child: icon,
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text(nameIcon),
      ],
    );
  }
}
