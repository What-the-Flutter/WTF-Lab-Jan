import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_page/home_page.dart';
import '../note_page.dart';
import '../utils/database.dart';
import '../utils/icons.dart';
import 'cubit_create_page.dart';
import 'states_create_page.dart';

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
  final DatabaseProvider _databaseProvider = DatabaseProvider();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final bool isEditing;
  final int index;
  List<NotePage> noteList;
  CubitCreatePage _cubit;

  _CreatePageState(this.noteList, this.isEditing, this.index) {
    _cubit = CubitCreatePage(StatesCreatePage(0));
  }

  @override
  void initState() {
    if (isEditing) {
      _textEditingController.text = noteList[index].title;
    }
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar:
              isEditing ? _appBar('Edit event') : _appBar('Create new event'),
          body: _createPageBody,
          floatingActionButton: _floatingActionButton,
        );
      },
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
    noteList[index].title = _textEditingController.text;
    noteList[index].circleAvatarIndex = _cubit.state.selectedIconIndex;
    _databaseProvider.updateNote(noteList[index]);
  }

  void _createEvent() async {
    var note = NotePage(
      title: _textEditingController.text,
      subtitle: 'No events. Click to create one.',
      circleAvatarIndex: _cubit.state.selectedIconIndex,
    );
    noteList.insert(0, note);
    note.noteId = await _databaseProvider.insertNote(note);
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
              child: _circleAvatar(
                  Icon(icons[_cubit.state.selectedIconIndex]), Colors.green),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              focusNode: _focusNode,
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
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 3.0,
        ),
        itemCount: icons.length,
        itemBuilder: (context, index) {
          return _iconButton(index);
        },
      ),
    );
  }

  IconButton _iconButton(int index) {
    return IconButton(
      icon: _circleAvatar(Icon(icons[index]), Theme.of(context).accentColor),
      onPressed: () => _cubit.setSelectedIconIndex(index),
    );
  }

  CircleAvatar _circleAvatar(Icon icon, Color color) {
    return CircleAvatar(
      child: icon,
      backgroundColor: color,
      foregroundColor: Colors.white,
    );
  }
}
