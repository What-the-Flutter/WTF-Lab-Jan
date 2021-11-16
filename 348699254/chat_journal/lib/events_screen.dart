import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _myController = TextEditingController();
  final List<String> _events = [];
  final List<String> _currentTime = [];
  bool _isSelected = false;
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _isSelected == false
          ? AppBar(
        title: _createAppBarTitle(),
        actions: <Widget>[
          _buildAppBarButtons(),
        ],
      )
          : AppBar(
        leading: _buildAppBarLeftButton(),
        actions: <Widget>[
          _buildAppBarSelectedButtons(),
        ],
      ),
      body: _bodyStructure(context),
      bottomNavigationBar: Padding(
        child: _buildBottomAppBar(context),
        padding:
        EdgeInsets.only(bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom),
      ),
    );
  }

  Widget _createAppBarTitle() {
    return const Align(
      child: Text('Travel'),
      alignment: Alignment.center,
    );
  }

  Widget _buildAppBarLeftButton() {
    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        setState(() {
          _selectedIndex = -1;
          _isSelected = false;
        });
      },
    );
  }

  Widget _buildAppBarButtons() {
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

  Widget _buildAppBarSelectedButtons() {
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
              _myController.text = _events[_selectedIndex];
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: _createClipBoard,
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _openMyAlertDialog(context);
          },
        ),
      ],
    );
  }

  Future<void> _createClipBoard() async {
    Clipboard.setData(ClipboardData(text: _events[_selectedIndex]));
    await _showClipBoardToast();
    await _returnToInitialState();
  }

  Future<bool?> _showClipBoardToast() {
    return Fluttertoast.showToast(
        msg: 'Copied to a clipboard!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> _returnToInitialState() async {
    setState(() {
      _selectedIndex = -1;
      _isSelected = false;
    });
  }

  void _openMyAlertDialog(BuildContext context) {
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
              _events.removeAt(_selectedIndex);
              _showDeleteToast();
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
    // Call showDialog function.
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

  Future<bool?> _showDeleteToast() {
    return Fluttertoast.showToast(
        msg: 'Delete selected event',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget _buildAppBarNoteButton() {
    return IconButton(
      icon: const Icon(Icons.bookmark_border_outlined),
      onPressed: () {},
    );
  }

  Widget _bodyStructure(BuildContext context) {
    return ListView.builder(
      //padding: const EdgeInsets.only(top: 8.0, left: 15.0, right: 15.0),
      padding: const EdgeInsets.all(5),
      reverse: true,
      itemCount: _events.length, //To keep the latest messages at the bottom
      itemBuilder: (_, index) =>
          Align(
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
                  child: _tile(_events[index], _currentTime[index], index),
                ),
              ],
            ),
          ),
    );
  }

  Widget _tile(String title, String subtitle, int index) {
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
              ? _buildRowWithIconToListTile(subtitle)
              : _buildRowToListTile(subtitle),
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

  Widget _buildRowToListTile(String subtitle) {
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

  Widget _buildRowWithIconToListTile(String subtitle) {
    return Row(
      children: <Widget>[
        const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.teal),
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
    _myController.dispose();
    super.dispose();
  }

  Widget _buildBottomAppBar(BuildContext context) {
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
            child: _createTextFormField(),
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

  Widget _createTextFormField() {
    final timeFormat = DateFormat('h:m a');
    final now = DateTime.now();
    final todayTimeInString = timeFormat.format(now);
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
        controller: _myController,
        onFieldSubmitted: (text) {
          if (_selectedIndex == -1) {
            _events.insert(0, text);
            _currentTime.insert(0, todayTimeInString);
          } else {
            _events.removeAt(_selectedIndex);
            _events.insert(_selectedIndex, text);
            _selectedIndex = -1;
            _isSelected = false;
          }
          _myController.clear();
          print(_events);
        });
  }
}