import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';

import 'event_classes.dart';
import 'themes.dart';

class EventPage extends StatefulWidget {
  final int eventPageIndex;
  const EventPage({Key? key, required this.eventPageIndex}) : super(key: key);
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List _messages = [];
  bool onlyMarked = false;
  bool _isSelected = false;
  late int _selectedMessageIndex;
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _showMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.onSecondary,
            Theme.of(context).colorScheme.secondaryVariant,
          ],
        ),
      ),
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
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => setState(() => _isSelected = false),
      ),
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
      ],
    );
  }

  PreferredSizeWidget _defaultAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(''),
      actions: [
        IconButton(
          icon: onlyMarked
              ? const Icon(Icons.bookmark_rounded)
              : const Icon(Icons.bookmark_border_rounded),
          onPressed: _showMarked,
        ),
      ],
    );
  }

  Widget _messageBottomBar() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(radiusValue),
        ),
        child: Container(
          height: 50,
          color: Theme.of(context).colorScheme.onPrimary,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_a_photo_rounded),
                color: Theme.of(context).colorScheme.onPrimary,
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
                color: Theme.of(context).colorScheme.background,
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
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.onPrimary,
          borderRadius: const BorderRadius.all(
            Radius.circular(radiusValue),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(_messages[i].date,
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).colorScheme.background)),
            ),
            _messages[i].content.toString() == "Instance of 'XFile'"
                ? Image.file(
                    File((_messages[i].content).path),
                    height: 300,
                  )
                : Text(_messages[i].content.toString(),
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).colorScheme.background)),
          ],
        ),
      ),
    );
  }

  void _mark(int i) {
    setState(() {
      if (eventPages[widget.eventPageIndex].eventMessages[i].isMarked ==
          false) {
        eventPages[widget.eventPageIndex].eventMessages[i].isMarked = true;
      } else {
        eventPages[widget.eventPageIndex].eventMessages[i].isMarked = false;
      }
    });
  }

  void _showMarked() {
    setState(() {
      onlyMarked = !onlyMarked;
      if (onlyMarked) {
        _messages = eventPages[widget.eventPageIndex]
            .eventMessages
            .where((message) => message.isMarked == true)
            .toList();
      } else {
        _messages = eventPages[widget.eventPageIndex].eventMessages;
      }
    });
  }

  void _showMessages() {
    setState(() {
      if (onlyMarked) {
        _messages = eventPages[widget.eventPageIndex]
            .eventMessages
            .where((message) => message.isMarked == true)
            .toList();
      } else {
        _messages = eventPages[widget.eventPageIndex].eventMessages;
      }
    });
  }

  void _delete() {
    setState(() {
      eventPages[widget.eventPageIndex]
          .eventMessages
          .removeAt(_selectedMessageIndex);
      _isSelected = false;
    });
  }

  void _edit() {
    if (eventPages[widget.eventPageIndex]
            .eventMessages[_selectedMessageIndex]
            .content
            .toString() ==
        "Instance of 'XFile'") {
      _addImage();
    } else {
      _controller.text = eventPages[widget.eventPageIndex]
          .eventMessages[_selectedMessageIndex]
          .content;
    }
  }

  void _copy() {
    Clipboard.setData(
      ClipboardData(
          text: eventPages[widget.eventPageIndex]
              .eventMessages[_selectedMessageIndex]
              .content),
    );
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
      var tempDate = eventPages[widget.eventPageIndex]
          .eventMessages[_selectedMessageIndex]
          .date;
      _delete();
      message = EventMessage(image, tempDate);
      setState(() {
        eventPages[widget.eventPageIndex]
            .eventMessages
            .insert(_selectedMessageIndex, message);
      });
    } else {
      message = EventMessage(
        image,
        Jiffy(DateTime.now()).format('d/M/y h:mm a'),
      );

      setState(() {
        eventPages[widget.eventPageIndex].eventMessages.add(message);
      });
    }
  }

  void _addMessage(BuildContext context) {
    if (_isSelected) {
      var tempDate = eventPages[widget.eventPageIndex]
          .eventMessages[_selectedMessageIndex]
          .date;
      var message = EventMessage(_controller.text, tempDate);
      _delete();
      setState(() {
        eventPages[widget.eventPageIndex]
            .eventMessages
            .insert(_selectedMessageIndex, message);
        _isSelected = false;
      });
    } else {
      var message = EventMessage(
        _controller.text,
        Jiffy(DateTime.now()).format('d/M/y h:mm a'),
      );
      setState(() {
        eventPages[widget.eventPageIndex].eventMessages.add(message);
      });
    }
    _controller.clear();
  }
}
