import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../domain/entities/event.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _EventScreenState createState() => _EventScreenState(title);
}

class _EventScreenState extends State<EventScreen> {
  final FocusNode _focusNode = FocusNode();
  final List<Event> _events = [];
  final TextEditingController _messageController = TextEditingController();
  int _selectedMessageIndex = -1;
  bool _isCRUDMode = false;

  _EventScreenState(String title);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: _isCRUDMode == false ? Text('${widget.title}') : Container(),
          centerTitle: true,
          actions: _appBarActions,
        ),
        body: Column(
          children: [
            _events.isEmpty ? _hintMessageBox() : _eventList(),
            _messageBar(),
          ],
        ),
      ),
    );
  }

  List<Widget> get _appBarActions {
    if (_isCRUDMode) {
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
    if (_events[_selectedMessageIndex].message == null) {
      _selectedMessageIndex = -1;
    } else {
      _messageController.text = _events[_selectedMessageIndex].message!;
    }
    _isCRUDMode = false;
  }

  void _copyEvent() {
    if (_events[_selectedMessageIndex].message != null) {
      Clipboard.setData(
        ClipboardData(text: _events[_selectedMessageIndex].message),
      );
    }
    unfocus();
  }

  void unfocus() {
    _isCRUDMode = false;
    _selectedMessageIndex = -1;
    setState(() {});
  }

  /// state switching implementation (bookmarked / unbookmarked)
  ///      if true is true or false is false then 0
  ///      if true false or false ture then 1
  void _bookmarkEvent() {
    _events[_selectedMessageIndex].isBookmarked ^= true;
    unfocus();
  }

  void _deleteEvent() {
    _events.removeAt(_selectedMessageIndex);
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
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'This is the ${widget.title} page!',
                    ),
                    const TextSpan(
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
        itemCount: _events.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              _isCRUDMode ^= true;
              setState(() {});
              _selectedMessageIndex = _isCRUDMode == true ? index : -1;
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      color: _selectedMessageIndex != index
                          ? Theme.of(context).dialogBackgroundColor
                          : Theme.of(context).selectedRowColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _events[index].message != null
                            ? Text(
                                _events[index].message!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              )
                            : Container(
                                width: 150,
                                height: 150,
                                child: Image.file(_events[index].image!),
                              ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _events[index].sendTime,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(width: 4),
                            _events[index].isBookmarked
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
                focusNode: _focusNode,
                controller: _messageController,
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
              _focusNode.hasFocus ? Icons.send : Icons.add_a_photo,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _focusNode.hasFocus ? _addMessageEvent : _addImageEvent,
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
      _events.insert(0, Event(image: imageFile));
      setState(() {});
    }
  }

  void _addMessageEvent() {
    if (_selectedMessageIndex != -1) {
      if (_messageController.text.isEmpty) {
        _events.removeAt(_selectedMessageIndex);
      } else {
        _events[_selectedMessageIndex].message = _messageController.text;
        _events[_selectedMessageIndex].updateSendTime();
      }
      _selectedMessageIndex = -1;
    } else if (_messageController.text.isNotEmpty) {
      _events.insert(
        0,
        Event(
          message: _messageController.text,
        ),
      );
    }
    _messageController.clear();
    setState(() {});
  }
}
