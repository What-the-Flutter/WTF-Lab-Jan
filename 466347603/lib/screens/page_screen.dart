import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../modules/page_info.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({Key? key}) : super(key: key);

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  late final TextEditingController _messageController = TextEditingController();
  late final FocusNode _messageFocusNode;
  late PageInfo _page;
  int _selectedEventIndex = -1;
  bool _isEditMode = false;
  bool _isBookmarkedOnly = false;

  @override
  void initState() {
    super.initState();
    _messageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _messageFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _page = ModalRoute.of(context)!.settings.arguments as PageInfo;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Center(
          child: Text(_page.title),
        ),
        actions: _appBarActions,
      ),
      body: GestureDetector(
        onTap: () {
          _isEditMode = false;
          _selectedEventIndex = -1;
          setState(() {});
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            _page.events.isEmpty ? _hintMessageBox() : _eventList(),
            _messageBar(),
          ],
        ),
      ),
    );
  }

  List<Widget> get _appBarActions {
    if (_isEditMode) {
      return <Widget>[
        if (_page.events[_selectedEventIndex].message != null)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _editEvent,
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: _copyEvent,
              ),
            ],
          ),
        IconButton(
          icon: _page.events[_selectedEventIndex].isBookmarked
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_border),
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
        IconButton(
          icon: _isBookmarkedOnly
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_border),
          onPressed: () {
            _isBookmarkedOnly ^= true;
            setState(() {});
          },
        ),
      ];
    }
  }

  void _editEvent() {
    _messageFocusNode.requestFocus();
    if (_page.events[_selectedEventIndex].message == null) {
      _selectedEventIndex = -1;
    } else {
      _messageController.text = _page.events[_selectedEventIndex].message!;
      _messageController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: _messageController.text.length,
        ),
      );
    }
    _isEditMode = false;
  }

  void _copyEvent() {
    if (_page.events[_selectedEventIndex].message != null) {
      Clipboard.setData(
        ClipboardData(text: _page.events[_selectedEventIndex].message),
      );
    }
    _isEditMode = false;
    _selectedEventIndex = -1;
    setState(() {});
  }

  void _bookmarkEvent() {
    _page.events[_selectedEventIndex].isBookmarked ^= true;
    _isEditMode = false;
    _selectedEventIndex = -1;
    setState(() {});
  }

  void _deleteEvent() {
    _page.events.removeAt(_selectedEventIndex);
    _isEditMode = false;
    _selectedEventIndex = -1;
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
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: 'This is the page where you can track '
                        'everything about "${_page.title}"!\n\n',
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                  ),
                  TextSpan(
                    text: 'Add you first event to "${_page.title}" page by '
                        'entering some text in the text box below '
                        'and hitting the send button. Tap on the '
                        'bookmark icon on the top right corner to '
                        'show the bookmarked events only.',
                    style: Theme.of(context).primaryTextTheme.subtitle2,
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
        itemCount: _page.events.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              _isEditMode = true;
              _selectedEventIndex = index;
              setState(() {});
            },
            child: Row(
              children: [
                if (_page.events[index].isBookmarked || !_isBookmarkedOnly)
                  _eventListElement(index, context)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _eventListElement(int index, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: _selectedEventIndex == index
            ? Theme.of(context).selectedRowColor
            : Theme.of(context).dialogBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _page.events[index].message != null
              ? LimitedBox(
                  maxWidth: 320,
                  child: Text(
                    _page.events[index].message!,
                  ),
                )
              : Container(
                  width: 150,
                  height: 150,
                  child: Image.file(_page.events[index].image!),
                ),
          const SizedBox(height: 2),
          Row(
            children: [
              if (_page.events[index].isBookmarked)
                Icon(
                  Icons.bookmark,
                  color: Colors.orange[600],
                  size: 15,
                ),
              const SizedBox(width: 5),
              Text(_page.events[index].sendTime),
            ],
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
              color: Theme.of(context).accentIconTheme.color,
            ),
            onPressed: _addImageEvent,
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: TextField(
                focusNode: _messageFocusNode,
                controller: _messageController,
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
              color: Theme.of(context).accentIconTheme.color,
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
      _page.events.insert(0, Event(image: imageFile));
      setState(() {});
    }
  }

  void _addMessageEvent() {
    if (_selectedEventIndex != -1) {
      if (_messageController.text.isEmpty) {
        _page.events.removeAt(_selectedEventIndex);
      } else {
        _page.events[_selectedEventIndex].message = _messageController.text;
        _page.events[_selectedEventIndex].updateSendTime();
      }
      _selectedEventIndex = -1;
    } else if (_messageController.text.isNotEmpty) {
      _page.events.insert(
        0,
        Event(
          message: _messageController.text,
        ),
      );
    }
    _messageController.clear();
    FocusScope.of(context).unfocus();
    setState(() {});
  }
}
