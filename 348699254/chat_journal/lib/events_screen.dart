import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'model/event.dart';

class EventScreen extends StatefulWidget {
  final int selectedPageIndex;

  EventScreen(this.selectedPageIndex);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _eventInputController = TextEditingController();
  final List<Event> _eventList = [];
  final timeFormat = DateFormat('h:m a');
  int _eventId = 0;
  bool _isSelected = false;
  int _selectedIndex = -1;
  int _pageId = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:
      _isSelected == false ? _usualAppBar() : _appBarForSelectedEvents(),
      body: _bodyStructure(context),
      bottomNavigationBar: Padding(
        child: _eventBottomAppBar(context),
        padding:
        EdgeInsets.only(bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom),
      ),
    );
  }

  AppBar _usualAppBar() {
    return AppBar(
      title: const Align(
        child: Text('Travel'),
        alignment: Alignment.center,
      ),
      actions: <Widget>[
        _usualAppBarButtons(),
      ],
    );
  }

  Widget _usualAppBarButtons() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  AppBar _appBarForSelectedEvents() {
    return AppBar(
      leading: _appBarCrossButton(),
      actions: <Widget>[
        _appBarButtonsForSelectedEvents(),
      ],
    );
  }

  Widget _appBarCrossButton() {
    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        setState(
              () {
            _selectedIndex = -1;
            _isSelected = false;
          },
        );
      },
    );
  }

  Widget _appBarButtonsForSelectedEvents() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.reply),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            setState(() {
              _eventInputController.text = _eventList[_selectedIndex].eventData;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: _copyClipBoard,
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _alertDeleteDialog(context),
        ),
      ],
    );
  }

  Future<void> _copyClipBoard() async {
    Clipboard.setData(
        ClipboardData(text: _eventList[_selectedIndex].eventData));
    await _clipBoardCopyToast();
    await _initialState();
  }

  Future<bool?> _clipBoardCopyToast() {
    return Fluttertoast.showToast(
        msg: 'Copied to a clipboard!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> _initialState() async {
    setState(() {
      _selectedIndex = -1;
      _isSelected = false;
    });
  }

  void _alertDeleteDialog(BuildContext context) {
    var dialog = AlertDialog(
      title: const Text('Delete Entry(s)?'),
      content: const FittedBox(
        child: Text('Are you sure you want to delete the 1 selected events?'),
      ),
      actions: [
        Row(children: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _eventList.removeAt(_selectedIndex);
              _deleteToast();
              Navigator.of(context).pop(true);
              // Return true
            },
          ),
          const Text('Delete'),
        ]),
        Row(children: [
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.blue),
            onPressed: () {
              Navigator.of(context).pop(false); // Return true
            },
          ),
          const Text('Cancel'),
        ]),
      ],
    );
    var futureValue = showDialog(
        context: context,
        builder: (context) {
          return dialog;
        });
    futureValue.then((value) {
      setState(() {
        _selectedIndex = -1;
        _isSelected = false;
      });
      print('Return value: $value'); // true/false
    });
  }

  Future<bool?> _deleteToast() {
    return Fluttertoast.showToast(
        msg: 'Delete selected event',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget _appBarNoteButton() {
    return IconButton(
      icon: const Icon(Icons.bookmark_border_outlined),
      onPressed: () {},
    );
  }

  Widget _bodyStructure(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      reverse: true,
      itemCount: _eventList.length, //To keep the latest messages at the bottom
      itemBuilder: (_, index) => _eventItem(index),
    );
  }

  Widget _eventItem(int index) {
    var pageEventList = _eventList
        .where((element) => _pageId == widget.selectedPageIndex)
        .toList();
    final todayTimeInString =
    timeFormat.format(pageEventList[index].creationDate);
    return Align(
      alignment: Alignment.centerLeft,
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 5),
            constraints: BoxConstraints(
              maxWidth: MediaQuery
                  .of(context)
                  .size
                  .width * 0.87,
            ),
            decoration: const BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: _eventTile(
                pageEventList[index].eventData, todayTimeInString, index),
          ),
        ],
      ),
    );
  }

  Widget _eventTile(String title, String subtitle, int index) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      subtitle: Row(
        children: <Widget>[
          index == _selectedIndex
              ? _listTileWithIconRow(subtitle)
              : _listTileRow(subtitle),
        ],
      ),
      selected: index == _selectedIndex,
      onLongPress: () => _onLongPressTile(index),
    );
  }

  void _onLongPressTile(int index) {
    setState(() {
      _selectedIndex = index;
      _isSelected = true;
    });
  }

  Widget _listTileWithIconRow(String subtitle) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.check_circle,
          color: Colors.black54,
          size: 13,
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black26,
          ),
        ),
      ],
    );
  }

  Widget _listTileRow(String subtitle) {
    return Row(
      children: <Widget>[
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black26,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _eventInputController.dispose();
    super.dispose();
  }

  Widget _eventBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.workspaces_filled),
            color: Colors.teal,
            onPressed: () {},
          ),
          Expanded(
            child: _eventTextFormField(),
          ),
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            color: Colors.teal,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _eventTextFormField() {
    //final timeFormat = DateFormat('h:m a');
    final now = DateTime.now();
    //final todayTimeInString = timeFormat.format(now);
    return TextFormField(
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(15),
        isDense: true,
        hintText: 'Enter Event',
        fillColor: Colors.lightBlueAccent,
        filled: true,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _eventInputController,
      onFieldSubmitted: (text) {
        _eventId++;
        _pageId = widget.selectedPageIndex;
        var event = Event(_eventId, text, now, _pageId);
        if (_selectedIndex == -1) {
          _eventList.insert(0, event);
        } else {
          _eventList.removeAt(_selectedIndex);
          _eventList.insert(_selectedIndex, event);
          _selectedIndex = -1;
          _isSelected = false;
        }
        _eventInputController.clear();
        print(_eventList.last.eventData);
      },
    );
  }
}
