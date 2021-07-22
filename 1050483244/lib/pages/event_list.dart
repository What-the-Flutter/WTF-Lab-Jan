import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EventPage extends StatelessWidget {
  final String title;
  const EventPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_outlined),
            tooltip: 'Favorites',
            onPressed: () {},
          ),
        ],
      ),
      body: Chat(),
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _eventsBody = <Object>[];
  final _eventsDates = <String>[];
  final controller = TextEditingController();
  int _eventIndex = 0;
  bool _needEdit = false;

  void _sendMsg() {
    if (_needEdit) {
      _eventsBody.removeAt(_eventIndex);
      _eventsDates.removeAt(_eventIndex);
    }
    setState(() {
      _eventsBody.insert(_eventIndex, controller.text);
      _eventsDates.insert(
          _eventIndex, Jiffy(DateTime.now()).format('d/M/y h:mm a'));
    });
    _eventIndex = 0;
    _needEdit = false;
    controller.clear();
  }

  void _addPicture() async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (_needEdit) {
        _eventsBody.removeAt(_eventIndex);
        _eventsDates.removeAt(_eventIndex);
      }
      setState(() {
        _eventsBody.insert(_eventIndex, image);
        _eventsDates.insert(
            _eventIndex, Jiffy(DateTime.now()).format('d/M/y h:mm a'));
      });
      _needEdit = false;
      _eventIndex = 0;
    }
  }

  void _showPopupMenu(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.content_copy_outlined, color: Colors.teal),
              title: Text('Copy to Clipboard'),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: _eventsBody[index].toString()));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit Event'),
              onTap: () {
                Navigator.pop(context);
                if (_eventsBody[index].toString() != "Instance of 'XFile'") {
                  controller.text = _eventsBody[index].toString();
                  _needEdit = true;
                  _eventIndex = index;
                } else {
                  _needEdit = true;
                  _eventIndex = index;
                  _addPicture();
                }
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.redAccent),
              title: Text('Delete Event'),
              onTap: () {
                _eventsBody.removeAt(index);
                _eventsDates.removeAt(index);
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
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            reverse: true,
            padding:
                const EdgeInsets.only(right: 50, bottom: 5, left: 5, top: 5),
            itemCount: _eventsBody.length,
            separatorBuilder: (context, index) => Divider(
              height: 10,
              color: Colors.transparent,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListTile(
                  onLongPress: () => _showPopupMenu(index),
                  title: _eventsBody[index].toString() != "Instance of 'XFile'"
                      ? Text(
                          _eventsBody[index].toString(),
                          style: TextStyle(fontSize: 14),
                        )
                      : Image.file(File((_eventsBody[index] as XFile).path)),
                  subtitle: Text(
                    _eventsDates[index],
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.camera_alt),
              tooltip: 'Choose picture',
              onPressed: _addPicture,
            ),
            Flexible(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Enter Event',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              tooltip: 'Send',
              onPressed: _sendMsg,
            ),
          ],
        ),
      ],
    );
  }
}
