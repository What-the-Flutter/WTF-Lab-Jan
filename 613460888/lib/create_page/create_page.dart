import 'package:flutter/material.dart';

import '../note_page/note.dart';

class CreatePage extends StatefulWidget {
  final List<Note> noteList;
  final bool isEditing;
  final int index;

  CreatePage({Key key, this.noteList, this.isEditing, this.index}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState(noteList, isEditing, index);
}

class _CreatePageState extends State<CreatePage> {
  final int index;
  final bool isEditing;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  IconData _selectedIcon = Icons.home;
  List<Note> noteList;
  List<IconData> listIcons = [
    Icons.home,
    Icons.flight_takeoff_rounded,
    Icons.drive_eta,
    Icons.store,
    Icons.family_restroom,
    Icons.sports_basketball,
    Icons.account_box,
    Icons.monetization_on_outlined,
    Icons.add_shopping_cart,
  ];

  _CreatePageState(this.noteList, this.isEditing, this.index);

  @override
  void initState() {
    if (isEditing) {
      _textEditingController.text = noteList[index].eventName;
      _focusNode.requestFocus();
    }
    super.initState();
  }

  void _createPage() {
    if (_textEditingController.text.isNotEmpty) {
      noteList.add(
        Note(_textEditingController.text, _selectedIcon, ''),
      );
    }
  }

  void _editPage() {
    if (_textEditingController.text.isNotEmpty) {
      noteList[index].eventName = _textEditingController.text;
      noteList[index].iconData = _selectedIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isEditing
          ? _appBar('Editing page')
          : _appBar('Creating page'),
      body: _pageBody,
      floatingActionButton: _floatingActionButton,
    );
  }

  AppBar _appBar(String title) {
    return AppBar(
      title: Center(
        child: Text(title),
      ),
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      child: Icon(Icons.check),
      onPressed: () {
        isEditing
            ? _editPage()
            : _createPage();
        if (_textEditingController.text.isNotEmpty) {
          Navigator.pop(
            context,
          );
        }
        ;
      },
    );
  }

  Column get _pageBody {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                _selectedIcon,
                size: 40,
              )
            ],
          ),
          title: _inputName,
        ),
        Expanded(child: _iconsGrid),
      ],
    );
  }

  Widget get _inputName {
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter name of the page',
      ),
    );
  }

  GridView get _iconsGrid {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: listIcons.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Icon(
            listIcons[index],
            size: 40,
          ),
          onTap: () {
            setState(() {
              _selectedIcon = listIcons[index];
            });
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
}
