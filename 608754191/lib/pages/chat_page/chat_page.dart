import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../entity/category.dart';
import '../entity/message.dart';

class ChatPage extends StatefulWidget {
  final Category category;

  const ChatPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatPage(category);
}

class _ChatPage extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _eventSelected = true;
  int _indexOfSelectedElement = 0;
  bool _isEditing = false;
  bool _isTyping = false;

  Category category;

  @required
  _ChatPage(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _eventSelected
          ? _appBarFromChatPage()
          : _appBarWhenSelectedFromChatPage(_indexOfSelectedElement),
      body: Column(
        children: [
          if (category.listMessages.isEmpty) _eventPage(),
          _bodyForInput(),
          _inputInsideChatPage(),
        ],
      ),
    );
  }

  AppBar _appBarFromChatPage() {
    return AppBar(
      backgroundColor: Colors.black,
      leading: const BackButton(),
      title: Center(
        child: Text(
          widget.category.title,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.bookmark_border_outlined,
          ),
        ),
      ],
    );
  }

  AppBar _appBarWhenSelectedFromChatPage(int index, {int? count}) {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      leading: IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        onPressed: _swapAppBar,
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.edit,
          ),
          onPressed: () {
            _swapAppBar();
            _editMessage(index);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.copy,
          ),
          onPressed: () {
            _swapAppBar();
            _copyMessage(index);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.bookmark_border,
          ),
          onPressed: _swapAppBar,
        ),
        IconButton(
          icon: const Icon(
            Icons.delete,
          ),
          onPressed: () {
            _swapAppBar();
            _deleteMessage(index);
          },
        ),
      ],
    );
  }

  Padding _eventPage() {
    return Padding(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Container(
        color: Colors.green[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Center(
                  child: Text(
                    'This is the page where you can'
                    ' track everything about ${widget.category.title} ',
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                '\nAdd your first event to ${widget.category.title} page by entering some text in'
                ' the box bellow and hitting the send button. Long tap the send button to align'
                ' the event in the opposite direction. Tap on bookmark icon on the top right'
                ' corner to show the bookmarked events only.',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyForInput() {
    return Expanded(
      child: ListView.builder(
        itemCount: category.listMessages.length,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.only(right: 100, top: 5, left: 5),
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              elevation: 5,
              color: Colors.blueGrey[600],
              child: ListTile(
                title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    category.listMessages[index].text,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd kk:mm').format(category.listMessages[index].time),
                  style: TextStyle(
                    color: Colors.blueGrey[200],
                    fontSize: 12,
                  ),
                ),
                onLongPress: () {
                  _indexOfSelectedElement = index;
                  _swapAppBar();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputInsideChatPage() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7.5,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.camera_alt_outlined,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 40,
                child: TextField(
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Enter Message',
                    filled: false,
                    hoverColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          40,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    isCollapsed: true,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
              ),
              iconSize: 30,
              onPressed: () {
                if (_isEditing) {
                  setState(() => _editText(
                        _indexOfSelectedElement,
                      ));
                } else {
                  setState(
                    _sendMessage,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    category.listMessages.insert(
      category.listMessages.length,
      Message(
        1,
        DateTime.now(),
        _textEditingController.text,
      ),
    );
    _textEditingController.clear();
  }

  void _editText(int index) {
    category.listMessages[index].text = _textEditingController.text;
    _textEditingController.clear();
    _isEditing = false;
  }

  void _swapAppBar() {
    setState(() => _eventSelected = !_eventSelected);
  }

  void _editMessage(int index) {
    setState(
      () {
        _isEditing = true;
        _textEditingController.text = category.listMessages[index].text;
        _focusNode.requestFocus();
      },
    );
  }

  void _copyMessage(int index) {
    Clipboard.setData(
      ClipboardData(text: category.listMessages[index].text),
    );
  }

  void _deleteMessage(int index) {
    category.listMessages.removeAt(index);
  }
}
