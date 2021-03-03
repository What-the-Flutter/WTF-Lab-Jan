import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'event.dart';
import 'note_page.dart';

class EventPage extends StatefulWidget {
  final Text title;
  final NotePage notePage;

  EventPage({Key key, this.title, this.notePage}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(notePage);
}

class _EventPageState extends State<EventPage> {
  final TextEditingController textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final NotePage _notePage;
  bool _isEventSelected = false;
  bool _isEditing = false;
  var _selectedItemIndex = 0;

  _EventPageState(this._notePage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isEventSelected
          ? _editingTextAppBar(_selectedItemIndex)
          : _defaultAppBar,
      body: _eventPageBody,
    );
  }

  void _changeAppBar() {
    setState(() {
      _isEventSelected = !_isEventSelected;
    });
  }

  AppBar get _defaultAppBar {
    return AppBar(
      title: widget.title,
    );
  }

  AppBar _editingTextAppBar(var index) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: _changeAppBar,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.edit,
          ),
          onPressed: () {
            _changeAppBar();
            _editEvent(index);
          },
        ),
        IconButton(
            icon: Icon(
              Icons.copy,
            ),
            onPressed: () {
              _changeAppBar();
              _copyEvent(index);
            }),
        IconButton(
            icon: Icon(
              Icons.bookmark_border,
            ),
            onPressed: () {
              _changeAppBar();
              // need to change
            }),
        IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () {
              _changeAppBar();
              _deleteEvent(index);
            }),
      ],
    );
  }

  Widget get _eventPageBody {
    return Column(
      children: <Widget>[
        Expanded(
          child: _listView,
        ),
        Align(
          child: _bottomInputWidgets,
        ),
      ],
    );
  }

  ListView get _listView {
    return ListView.builder(
      reverse: true,
      scrollDirection: Axis.vertical,
      itemCount: _notePage.eventList.length,
      itemBuilder: (context, index) {
        final _event = _notePage.eventList[index];
        return _showEventList(_event, index);
      },
    );
  }

  Widget _showEventList(Event event, var index) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 3,
          child: ListTile(
            tileColor: Theme.of(context).appBarTheme.color,
            title: Text(
              event.text,
              style: TextStyle(
                fontSize: 17,
                color:
                    Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
            ),
            subtitle: Text(
              event.time,
              style: TextStyle(
                fontSize: 15,
                color:
                    Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
            ),
            onLongPress: () {
              _selectedItemIndex = index;
              _changeAppBar();
            },
          ),
        ),
      ),
    );
  }

  Row get _bottomInputWidgets {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add_a_photo_rounded,
          ),
          iconSize: 30,
          color:Theme.of(context).appBarTheme.color,
          onPressed: () {
            // add some data from user device
          },
        ),
        Expanded(
          child: TextField(
            controller: textController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Enter event...',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.send,
          ),
          iconSize: 30,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          onPressed: () {
            if (_isEditing) {
              setState(() {
                _editText(_selectedItemIndex);
              });
            } else {
              setState(_addEvent);
            }
          },
        ),
      ],
    );
  }

  void _addEvent() {
    _notePage.eventList.insert(
      0,
      Event(
        text: textController.text,
        time: DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now()),
        isSelectedEvent: false,
      ),
    );
    textController.clear();
  }

  void _editEvent(var index) {
    setState(() {
      _isEditing = true;
      textController.text = _notePage.eventList[index].text;
      _focusNode.requestFocus();
    });
  }

  void _editText(var index) {
    _notePage.eventList[index].text = textController.text;
    textController.clear();
    _isEditing = false;
  }

  void _copyEvent(var index) =>
      Clipboard.setData(ClipboardData(text: _notePage.eventList[index].text));

  void _deleteEvent(var index) => _notePage.eventList.removeAt(index);
}
