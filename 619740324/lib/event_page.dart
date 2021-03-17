import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'event.dart';
import 'light_theme.dart';
import 'note.dart';
import 'theme.dart';

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
  int _indexOfSelectedElement = 0;
  bool _isEditing = false;

  _EventPageState(this._note);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _defaultAppBar,
      body: _eventPageBody,
    );
  }

  AppBar get _defaultAppBar {
    return AppBar(
      title: Center(
        child: Text(widget.title),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget get _eventPageBody {
    return Column(
      children: <Widget>[
        Expanded(
          child: _listView,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black26,
              ),
            ),
          ),
          child: _textFieldArea,
        ),
      ],
    );
  }

  Row get _textFieldArea {
    return Row(
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.attach_file), iconSize: 32, onPressed: () {}),
        Expanded(
          child: TextField(
            controller: textController,
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
          iconSize: 32,
          color: Colors.blueGrey,
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
    if (textController.text.isNotEmpty) {
      _note.eventList[index].text = textController.text;
      textController.clear();
      _isEditing = false;
    } else {
      _deleteEvent(index);
      _isEditing = false;
    }
  }

  void _sendEvent() {
    if (textController.text.isNotEmpty) {
      _note.eventList.insert(
        0,
        Event(
          text: textController.text,
          time: DateFormat('yyyy-MM-dd kk:mm').format(
            DateTime.now(),
          ),
          isSelected: false,
        ),
      );
      textController.clear();
    }
  }

  ListView get _listView {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: _note.eventList.length,
      itemBuilder: (context, index) {
        final _event = _note.eventList[index];
        return _showEventList(_event, index);
      },
    );
  }

  Widget _showEventList(Event event, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 5,
          color: ThemeSwitcher
              .of(context)
              .themeData == lightThemeData
              ? Colors.blueGrey[100]
              : Theme
              .of(context)
              .primaryColor,
          child: ListTile(
            title: Text(event.text),
            subtitle: Align(
                alignment: Alignment.bottomRight, child: Text(event.time)),
            onLongPress: () {
              _indexOfSelectedElement = index;
              _showBottomSheet(context, index);
            },
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 230,
          child: _buildBottomNavigationMenu(index),
        );
      },
    );
  }

  Column _buildBottomNavigationMenu(int index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          title: Text('Edit'),
          onTap: () {
            setState(() {
              _editEvent(index);
              Navigator.pop(context);
            });
          },
        ),
        ListTile(
          leading: Icon(
            Icons.copy,
            color: Colors.orange,
          ),
          title: Text('Copy'),
          onTap: () {
            setState(() {
              _copyEvent(index);
              Navigator.pop(context);
            });
          },
        ),
        ListTile(
          leading: Icon(
            Icons.check_circle_outline_outlined,
            color: Colors.green,
          ),
          title: Text('Important'),
          onTap: () {
            setState(() {
              _importantEvent(index);
              Navigator.pop(context);
            });
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          title: Text('Delete'),
          onTap: () {
            setState(() {
              _deleteEvent(index);
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }

  void _importantEvent(int index) {
    _note.subTittleEvent = _note.eventList[index].text;
  }

  void _copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: _note.eventList[index].text));
  }

  void _deleteEvent(int index) {
    if (_note.subTittleEvent == _note.eventList[index].text) {
      _note.subTittleEvent = '';
    }
    _note.eventList.removeAt(index);
  }

  void _editEvent(int index) {
    setState(
          () {
        _isEditing = true;
        textController.text = _note.eventList[index].text;
        _focusNode.requestFocus();
      },
    );
  }
}
