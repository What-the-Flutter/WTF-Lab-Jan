import 'package:flutter/material.dart';

import 'home_page.dart';
import 'note_page.dart';

class CreatePage extends StatefulWidget {
  final List<NotePage> noteList;
  final bool isEditing;
  final int index;

  CreatePage({Key key, this.noteList, this.isEditing, this.index})
      : super(key: key);

  @override
  _CreatePageState createState() =>
      _CreatePageState(noteList, isEditing, index);
}

class _CreatePageState extends State<CreatePage> {
  final bool isEditing;
  final int index;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  IconData _selectedIcon = Icons.airplanemode_active;
  List<NotePage> noteList;

  _CreatePageState(this.noteList, this.isEditing, this.index);

  @override
  void initState() {
    if (isEditing) {
      _textController.text = noteList[index].title.data;
      _focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isEditing ? _appBar('Edit event') : _appBar('Create new event'),
      body: _createPageBody,
      floatingActionButton: _floatingActionButton,
    );
  }

  AppBar _appBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      child: Icon(
        Icons.check,
      ),
      onPressed: () {
        isEditing ? _editEvent() : _createEvent();
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    );
  }

  void _editEvent() {
    noteList[index].title = Text(
      _textController.text,
      style: TextStyle(
        fontSize: 20,
      ),
    );
    noteList[index].icon = CircleAvatar(
      child: Icon(_selectedIcon),
    );
  }

  void _createEvent() {
    noteList.add(
      NotePage(
        Text(
          _textController.text,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Text(
          'No events. Click to create one.',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        CircleAvatar(
          child: Icon(_selectedIcon),
        ),
      ),
    );
  }

  Column get _createPageBody {
    return Column(
      children: <Widget>[
        _inputArea,
        _iconsGrid,
      ],
    );
  }

  Widget get _inputArea {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 15),
            child: Ink(
              child: _circleAvatar(_selectedIcon, Colors.green),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter name of the page...',
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded get _iconsGrid {
    return Expanded(
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 3.0,
        ),
        children: <IconButton>[
          IconButton(
            icon: _circleAvatar(
                Icons.airplanemode_active, Theme.of(context).accentColor),
            onPressed: () {
              setState(() {
                _selectedIcon = Icons.airplanemode_active;
              });
            },
          ),
          IconButton(
            icon: _circleAvatar(
                Icons.school_sharp, Theme.of(context).accentColor),
            onPressed: () {
              setState(() {
                _selectedIcon = Icons.school_sharp;
              });
            },
          ),
          IconButton(
            icon: _circleAvatar(Icons.search, Theme.of(context).accentColor),
            onPressed: () {
              setState(() {
                _selectedIcon = Icons.search;
              });
            },
          ),
          IconButton(
            icon: _circleAvatar(
                Icons.emoji_food_beverage, Theme.of(context).accentColor),
            onPressed: () {
              setState(() {
                _selectedIcon = Icons.emoji_food_beverage;
              });
            },
          ),
          IconButton(
            icon:
                _circleAvatar(Icons.car_rental, Theme.of(context).accentColor),
            onPressed: () {
              setState(() {
                _selectedIcon = Icons.car_rental;
              });
            },
          ),
        ],
      ),
    );
  }

  CircleAvatar _circleAvatar(IconData icon, Color color) {
    return CircleAvatar(
      child: Icon(
        icon,
        size: 30,
      ),
      backgroundColor: color,
      foregroundColor: Colors.white,
    );
  }
}
