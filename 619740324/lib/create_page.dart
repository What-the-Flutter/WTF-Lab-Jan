import 'package:flutter/material.dart';

import 'note.dart';

class CreatePage extends StatefulWidget {
  final List<Note> noteList;
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
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  CircleAvatar _selectedIcon = CircleAvatar(child: Icon(Icons.home));
  List<Note> noteList;
  List<Icon> listIcons = [
    Icon(Icons.home),
    Icon(Icons.airplanemode_active),
    Icon(Icons.drive_eta),
    Icon(Icons.store),
    Icon(Icons.videogame_asset_sharp),
    Icon(Icons.wc),
    Icon(Icons.account_box),
    Icon(Icons.monetization_on_outlined),
    Icon(Icons.add_shopping_cart),
  ];

  _CreatePageState(this.noteList, this.isEditing, this.index);

  @override
  void initState() {
    if (isEditing) {
      _textController.text = noteList[index].eventName;
      _focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          isEditing ? _appBar('Edit you page') : _appBar('Create a new page'),
      body: createPageBody,
      floatingActionButton: _floatingActionButton,
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      child: Icon(Icons.check),
      onPressed: () {
        isEditing ? _editPage() : _createPage();
        if (_textController.text.isNotEmpty) {
          Navigator.pop(
            context,
          );
        }
        ;
      },
    );
  }

  void _createPage() {
    if (_textController.text.isNotEmpty) {
      noteList.add(
        Note(_textController.text, _selectedIcon, ''),
      );
    }
  }

  void _editPage() {
    if (_textController.text.isNotEmpty) {
      noteList[index].eventName = _textController.text;
      noteList[index].circleAvatar = _selectedIcon;
    }
  }

  Column get createPageBody {
    return Column(
      children: <Widget>[
        _inputText,
        _iconGrid,
      ],
    );
  }

  Widget get _inputText {
    return Container(
      padding: EdgeInsets.all(30),
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Name of the page ',
        ),
      ),
    );
  }

  GridView get _iconGrid {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: listIcons.length,
      itemBuilder: (context, index) {
        return IconButton(
          icon: _circleAvatar(listIcons[index]),
          onPressed: () {
            _selectedIcon = _circleAvatar(listIcons[index]);
            _circleAvatar(listIcons[index], Colors.green);
          },
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),
    );
  }

  AppBar _appBar(String title) {
    return AppBar(
      title: Padding(
          padding: EdgeInsets.fromLTRB(35, 0, 0, 0), child: Text(title)),
    );
  }
}

CircleAvatar _circleAvatar(Icon icon, [Color color]) {
  return CircleAvatar(
    child: icon,
    backgroundColor: color,
  );
}
