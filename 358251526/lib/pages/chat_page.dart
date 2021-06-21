import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../domain.dart';

class Chat extends StatefulWidget {
  final Category category;

  const Chat({Key? key, required this.category}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Chat(category);
}

class _Chat extends State<Chat> {
  final Category _category;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final bool _isEditingText = false;
  bool _eventSelected = true;
  int _indexOfSelectedElement = 0;
  bool _isEditing = false;

  _Chat(this._category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _eventSelected
          ? _baseAppBar
          : _selectItemAppBar(_indexOfSelectedElement),
      body: _chatBody,
    );
  }

  AppBar get _baseAppBar {
    return AppBar(
      title: Center(
        child: Text(_category.name),
      ),
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
      ],
    );
  }

  AppBar _selectItemAppBar(int index, {int? count}) {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      leading: IconButton(icon: Icon(Icons.clear), onPressed: _swapAppBar),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _swapAppBar();
            _editEvent(index);
          },
        ),
        IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              _swapAppBar();
              _copyEvent(index);
            }),
        IconButton(icon: Icon(Icons.bookmark_border), onPressed: _swapAppBar),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => _deleteAlertDialog(index))),
      ],
    );
  }

  Widget get _chatBody {
    return Column(
      children: <Widget>[
        Expanded(
          child: _listView,
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black26,
                ),
              ),
            ),
            child: _messageField,
          ),
        ),
      ],
    );
  }

  ListView get _listView {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: _category.events.length,
      itemBuilder: (context, index) {
        _indexOfSelectedElement = index;
        final event = _category.events[index];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          width: 100,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.2,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Card(
              elevation: 3,
              child: ListTile(
                title: Text(event.text),
                subtitle:
                    Text(DateFormat('yyyy-MM-dd kk:mm').format(event.dateTime)),
                onLongPress: () {
                  _indexOfSelectedElement = index;
                  _swapAppBar();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Row get _messageField {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.camera_alt_outlined),
          iconSize: 30,
          onPressed: () {
            setState(() {});
          },
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Enter Event',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        IconButton(
          icon: Icon(Icons.send),
          iconSize: 30,
          onPressed: () {
            if (_isEditing) {
              setState(() {
                _editText(_indexOfSelectedElement);
              });
            } else {
              setState(_sendEvent);
            }
          },
        ),
      ],
    );
  }

  void _editText(int index) {
    _category.events[index].text = _textEditingController.text;
    _textEditingController.clear();
    _isEditing = false;
  }

  void _sendEvent() {
    _category.events.insert(
      0,
      Event(_textEditingController.text, DateTime.now()),
    );
    _textEditingController.clear();
  }

  void _swapAppBar() => setState(() {
        _eventSelected = !_eventSelected;
      });

  void _editEvent(int index) {
    setState(() {
      _isEditing = true;
      _textEditingController.text = _category.events[index].text;
      _textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
      _focusNode.requestFocus();
    });
  }

  void _copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: _category.events[index].text));
  }

  void _deleteEvent(int index) => _category.events.removeAt(index);

  AlertDialog _deleteAlertDialog(int index) {
    return AlertDialog(
      title: const Text('Delete event?'),
      elevation: 3,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Yes');
            _swapAppBar();
            _deleteEvent(index);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
