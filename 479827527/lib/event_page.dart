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
      centerTitle: true,
      backgroundColor: Colors.deepPurple,
    );
  }

  AppBar _editingTextAppBar(var index) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.white,
        ),
        onPressed: _changeAppBar,
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              _changeAppBar();
              _editEvent(index);
            }),
        IconButton(
            icon: Icon(
              Icons.copy,
              color: Colors.white,
            ),
            onPressed: () {
              _changeAppBar();
              _copyEvent(index);
            }),
        IconButton(
            icon: Icon(
              Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: () {
              _changeAppBar();
              // need to change
            }),
        IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
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
        _selectedItemIndex = index;
        final _event = _notePage.eventList[index];
        return _showEventList(_event, index);
      },
    );
  }

  Widget _showEventList(Event event, var index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 3,
          color: Colors.deepPurple,
          child: ListTile(
            title: Text(
              event.text,
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              event.time,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            onLongPress: () {
              _selectedItemIndex = index;
              setState(() {
                _isEventSelected = !_isEventSelected;
              });
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
            color: Colors.deepPurple,
          ),
          iconSize: 30,
          color: Colors.deepPurple,
          onPressed: () {
            // add some data from user device
          },
        ),
        Expanded(
          child: TextField(
            autocorrect: true,
            enableSuggestions: true,
            controller: textController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Enter event...',
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.deepPurple,
          ),
          iconSize: 30,
          onPressed: () {
            setState(_addEvent);
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
      ),
    );
    textController.clear();
  }

  void _editEvent(var index) {
    _notePage.eventList[index].text = textController.text;
    textController.clear();
  }

  void _copyEvent(var index) =>
      Clipboard.setData(ClipboardData(text: _notePage.eventList[index].text));

  void _deleteEvent(var index) => _notePage.eventList.removeAt(index);
}
