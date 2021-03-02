import 'package:flutter/material.dart';
import 'main.dart';

import 'note.dart';

class NotePage extends StatefulWidget {
  final List<Note> noteList;
  final Note note;

  const NotePage({Key key, this.noteList, this.note}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState(
        noteList: noteList,
        note: note,
      );
}

class _NotePageState extends State<NotePage> {
  final FocusNode _focusNode = FocusNode();
  final List<Note> noteList;
  final Note note;
  final TextEditingController textController = TextEditingController();
  CircleAvatar _selectIcon;
  bool _isWriting = false;

  _NotePageState({this.noteList, this.note});

  @override
  void initState() {
    if (note != null) {
      _selectIcon = CircleAvatar(
        child: note.iconData,
      );
      textController.text = note.eventName;
      _focusNode.requestFocus();
    } else {
      _selectIcon = CircleAvatar(
        child: Icon(Icons.fastfood),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _notePageBody(context),
      floatingActionButton: _floatingActionButton,
    );
  }

  List<Icon> listOfIcons = [
    Icon(Icons.camera_alt),
    Icon(Icons.airport_shuttle_rounded),
    Icon(Icons.wine_bar_sharp),
    Icon(Icons.wc),
    Icon(Icons.fastfood),
    Icon(Icons.accessibility_new_sharp),
    Icon(Icons.reply),
    Icon(Icons.airplanemode_active),
    Icon(Icons.account_balance_wallet),
    Icon(Icons.anchor_rounded),
    Icon(Icons.apartment),
    Icon(Icons.wb_sunny_sharp),
    Icon(Icons.watch_later),
    Icon(Icons.weekend_rounded),
  ];

  Widget _notePageBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: _textFieldAria,
          ),
          Expanded(
            child: _gridView,
          ),
        ],
      ),
    );
  }

  GridView get _gridView {
    return GridView.extent(
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(5),
      maxCrossAxisExtent: 100,
      children: [
        for (var index = 0; index < listOfIcons.length; index++)
          GestureDetector(
            onTap: () {
              setState(
                () {
                  _selectIcon = CircleAvatar(
                    child: listOfIcons[index],
                  );
                },
              );
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  height: 80,
                  width: 80,
                  child: CircleAvatar(
                    radius: 10,
                    child: listOfIcons[index],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Row get _textFieldAria {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: _selectIcon,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 30),
            child: TextField(
              controller: textController,
              focusNode: _focusNode,
              onChanged: (value) {
                setState(
                  () {
                    value.isNotEmpty ? _isWriting = true : _isWriting = false;
                  },
                );
              },
              decoration: InputDecoration(
                hintText: 'Enter event',
                fillColor: Colors.grey[200],
                border: InputBorder.none,
                filled: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      onPressed: () {
        setState(floatingActionButtonEvent);
      },
      child: _isWriting ? Icon(Icons.check) : Icon(Icons.clear),
    );
  }

  void floatingActionButtonEvent() {
    if (note != null && _isWriting) {
      setState(
        () {
          note.eventName = textController.text;
          note.iconData = CircleAvatar(
            child: _selectIcon,
          );
          Navigator.of(context).pop();
        },
      );
    } else {
      if (_isWriting) {
        setState(
          () {
            noteList.add(
              Note(
                textController.text,
                CircleAvatar(
                  child: _selectIcon,
                ),
                'Add event',
              ),
            );
            Navigator.of(context).pop();
          },
        );
      } else {
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
        );
      }
    }
  }

  AppBar get _appBar {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: Text('Create a new note'),
      ),
    );
  }
}
