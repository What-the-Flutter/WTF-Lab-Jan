import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'event.dart';
import 'note.dart';

class EventPage extends StatefulWidget {
  final String title;
  final Note note;

  EventPage({Key key, this.title, this.note}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(note);
}

class _EventPageState extends State<EventPage> {
  final Note _note;
  final TextEditingController textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final bool _isEditingText = false;
  bool _eventSelected = true;
  int _indexOfSelectedElement = 0;
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _eventSelected
          ? _defaultAppBar
          : _appBarMenu(_indexOfSelectedElement),
      body: _eventPageBody,
    );
  }

  _EventPageState(this._note);

  AppBar get _defaultAppBar {
    return AppBar(
      title: Text(widget.title),
    );
  }

  Widget get _eventPageBody {
    return Column(
      children: <Widget>[
        Expanded(
          child: _listView,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black12,
                ),
              ),
            ),
            child: _row,
          ),
        ),
      ],
    );
  }

  ListView get _listView {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: _note.eventList.length,
      itemBuilder: (context, index) {
        _indexOfSelectedElement = index;
        final _event = _note.eventList[index];
        return _showEventList(_event, index);
      },
    );
  }

  Row get _row {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.camera_alt_outlined),
          iconSize: 25,
          color: Colors.blueGrey,
          onPressed: () {
            setState(() {});
          },
        ),
        Expanded(
          child: TextField(
            controller:
                _isEditingText ? TextEditingController() : textController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Enter event',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.send),
            iconSize: 29,
            color: Colors.blueGrey,
            onPressed: () {
              if (_isEditing) {
                setState(() {
                  _editText(_indexOfSelectedElement);
                });
              } else {
                setState(_sendEvent);
              }
            }),
      ],
    );
  }

  void _editText(int index) {
    _note.eventList[index].text = textController.text;
    textController.clear();
    _isEditing = false;
  }

  void _sendEvent() {
    _note.eventList.insert(
      0,
      Event(
        text: textController.text,
        time: DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
        isSelected: false,
      ),
    );
    textController.clear();
  }

  Widget _showEventList(Event event, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 3,
          color: Colors.blueGrey[100],
          child: ListTile(
              title: Text(event.text),
              subtitle: Text(event.time),
              onLongPress: () {
                _indexOfSelectedElement = index;
                //  _changeSelected(index);
                _appBarChange();
              }),
        ),
      ),
    );
  }

  void _appBarChange() {
    setState(() {
      _eventSelected = !_eventSelected;
    });
  }

  AppBar _appBarMenu(int index, {int count}) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _appBarChange();
          }),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.reply),
            onPressed: () {
              _appBarChange();
            }),
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _appBarChange();
              _editEvent(index);
            }),
        IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              _appBarChange();
              _copyEvent(index);
            }),
        IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              _appBarChange();
            }),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _appBarChange();
              _deleteEvent(index);
            }),
      ],
    );
  }

  void _editEvent(int index) {
    setState(() {
      _isEditing = true;
      textController.text = _note.eventList[index].text;
      _focusNode.requestFocus();
    });
  }

  void _copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: _note.eventList[index].text));
  }

  void _deleteEvent(int index) {
    _note.eventList.removeAt(index);
  }
}
