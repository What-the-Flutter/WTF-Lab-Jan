import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _myController = TextEditingController();
  final bool _isEnable = false;
  final List<String> _events = [];
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
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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

  Future<bool?> _createClipBoard() async {
    return Clipboard.setData(ClipboardData(text: _events[_selectedIndex])).then(
      (value) => Fluttertoast.showToast(
          msg: 'Copied to a clipboard!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0),
    );
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
              Navigator.of(context).pop(true); // Return true
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

  Widget _buildAppBarNoteButton() {
    return IconButton(
      icon: const Icon(Icons.bookmark_border_outlined),
      onPressed: () {},
    );
  }

  Widget _bodyStructure(BuildContext context) {
    final timeFormat = DateFormat('h:m a');
    final now = DateTime.now();
    final todayTimeInString = timeFormat.format(now);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(5),
            reverse: true, //To keep the latest messages at the bottom
            itemBuilder: (_, index) => Container(
              margin: const EdgeInsets.only(top: 5),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: _tile(_events[index], todayTimeInString, index),
            ),
            itemCount: _events.length,
          ),
        ),
      ],
    );
  }

  ListTile _tile(String title, String subtitle, int index) {
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
            _events.add(text);
          } else {
            _events.removeAt(_selectedIndex);
            _events.insert(_selectedIndex, text);
          }
          _myController.clear();
          print(_events);
        });
  }
}
