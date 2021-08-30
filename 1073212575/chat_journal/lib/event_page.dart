import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'style.dart';

class EventMessage {
  dynamic content;
  dynamic date;
  bool isMarked = false;
  EventMessage(this.content, this.date);
}

List _allMessages = [];
List _markedMessages = [];
List _messages = _allMessages;
bool _isSelected = false;
late int _selectedMessageIndex;

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _isSelected ? _editingAppBar() : _defaultAppBar(),
        body: Stack(
          children: <Widget>[
            _eventMessagesList(),
            _messageBottomBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _editingAppBar() {
    return AppBar(
        backgroundColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusBottom,
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => setState(() => _isSelected = false)),
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: _delete,
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            onPressed: _copy,
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: _edit,
          ),
        ]);
  }

  PreferredSizeWidget _defaultAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusBottom,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(''),
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark_border_rounded),
          onPressed: _showMarked,
        ),
      ],
    );
  }

  Widget _messageBottomBar() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: ClipRRect(
        borderRadius: borderRadiusTop,
        child: Container(
          height: 50,
          color: eventBackgroundColor,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_a_photo_rounded),
                color: mainColor,
                onPressed: _addImage,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                    hintText: 'Enter event',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded),
                color: mainColor,
                onPressed: () => _addMessage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventMessagesList() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 60, 70),
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, i) => _message(i),
      ),
    );
  }

  Widget _message(int i) {
    return GestureDetector(
      onTap: () => _mark(i),
      onLongPress: () => _select(i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _messages[i].isMarked == true
              ? markedMessageColor
              : eventBackgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(_messages[i].date,
                  style: TextStyle(fontSize: 12, color: mainColor)),
            ),
            _messages[i].content.toString() == "Instance of 'XFile'"
                ? Image.file(
                    File((_messages[i].content).path),
                    height: 300,
                  )
                : Text(_messages[i].content.toString(),
                    style: TextStyle(fontSize: 16, color: mainColor)),
          ],
        ),
      ),
    );
  }

  void _mark(int i) {
    setState(() {
      if (_allMessages[i].isMarked == false) {
        _allMessages[i].isMarked = true;
        _markedMessages.add(_allMessages[i]);
      } else {
        _allMessages[i].isMarked = false;
        _markedMessages.remove(_allMessages[i]);
      }
    });
  }

  void _showMarked() {
    setState(() {
      _messages == _allMessages
          ? _messages = _markedMessages
          : _messages = _allMessages;
    });
  }

  void _delete() {
    setState(() {
      _allMessages.removeAt(_selectedMessageIndex);
      _isSelected = false;
    });
  }

  void _edit() {
    if (_allMessages[_selectedMessageIndex].content.toString() ==
        "Instance of 'XFile'") {
      _addImage();
    } else {
      _controller.text = _allMessages[_selectedMessageIndex].content;
    }
  }

  void _copy() {
    Clipboard.setData(
        ClipboardData(text: _allMessages[_selectedMessageIndex].content));
    setState(() => _isSelected = false);
  }

  void _select(int i) {
    setState(() {
      _selectedMessageIndex = i;
      _isSelected = true;
    });
  }

  void _addImage() async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    var message;
    if (_isSelected) {
      var tempDate = _allMessages[_selectedMessageIndex].date;
      _delete();
      message = EventMessage(image, tempDate);
      setState(() {
        _allMessages.insert(_selectedMessageIndex, message);
      });
    } else {
      message =
          EventMessage(image, Jiffy(DateTime.now()).format('d/M/y h:mm a'));

      setState(() {
        _allMessages.add(message);
      });
    }
  }

  void _addMessage(BuildContext context) {
    if (_isSelected) {
      var tempDate = _allMessages[_selectedMessageIndex].date;
      var message = EventMessage(_controller.text, tempDate);
      _delete();
      setState(() {
        _allMessages.insert(_selectedMessageIndex, message);
        _isSelected = false;
      });
    } else {
      var message = EventMessage(
          _controller.text, Jiffy(DateTime.now()).format('d/M/y h:mm a'));
      setState(() {
        _allMessages.add(message);
      });
    }
    _controller.clear();
  }
}
