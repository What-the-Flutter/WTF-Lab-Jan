import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';

class MyListEventsPage extends StatefulWidget {
  final String title;
  final List events = [];

  MyListEventsPage({required this.title});

  @override
  _MyListEventsPageState createState() => _MyListEventsPageState();
}

class _MyListEventsPageState extends State<MyListEventsPage> {
  final myController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future<void> _getImage(ImageSource imageSource) async {
    var imageFile = await picker.getImage(source: imageSource);
    if (imageFile == null) return;
    setState(
      () {
        _image = File(imageFile.path);
      },
    );
  }

  Container _buildEvent(Event event) {
    return Container(
      margin: event.isFavorite
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: event.isFavorite
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0))
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0)),
      ),
      child: GestureDetector(
        onLongPress: () => showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: <Widget>[
                ListTile(
                  leading:
                      Icon(Icons.attach_file_outlined, color: Colors.green),
                  title: Text('Like/Unlike Event'),
                  onTap: () {
                    event.isFavorite
                        ? event.isFavorite = false
                        : event.isFavorite = true;
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.copy, color: Colors.yellow),
                  title: Text('Copy Event'),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: event.text));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit, color: Colors.blue),
                  title: Text('Edit Event'),
                  onTap: () {
                    myController.text = event.text;
                    event.isEdit = true;
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.redAccent),
                  title: Text('Delete Event'),
                  onTap: () {
                    widget.events.remove(event);
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              DateFormat.yMd().add_jm().format(event.time).toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.0),
            event.image != null
                ? Image.file(
                    event.image!,
                  )
                : Text(
                    event.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Container _buildEventComposer() {
    var insert = true;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _getImage(ImageSource.gallery);
              _image!=null ? widget.events.insert(
                  0,
                  Event(
                      time: DateTime.now(),
                      text: '',
                      isFavorite: false,
                      isEdit: false,
                      image: _image)) : _image = null;
              _image = null;
            },
          ),
          Expanded(
            child: TextField(
              controller: myController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Create a event',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () => {
              widget.events.forEach((element) {
                if (element.isEdit) {
                  element.text = myController.text;
                  element.isEdit = false;
                  insert = false;
                }
              }),
              if (insert)
                {
                  widget.events.insert(
                    0,
                    Event(
                      time: DateTime.now(),
                      text: myController.text,
                      isFavorite: false,
                      isEdit: false,
                      image: null,
                    ),
                  ),
                },
              setState(() {}),
              myController.text = ''
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.bookmark),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.only(top: 15.0),
                itemCount: widget.events.length,
                itemBuilder: (context, index) {
                  final event = widget.events[index];
                  return _buildEvent(event);
                },
              ),
            ),
          ),
          _buildEventComposer(),
        ],
      ),
    );
  }
}
