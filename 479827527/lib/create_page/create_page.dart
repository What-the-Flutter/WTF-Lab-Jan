import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_page/home_page.dart';
import '../note.dart';
import '../utils/icons.dart';
import 'cubit_create_page.dart';
import 'states_create_page.dart';

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
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final bool _isEditing;
  final int _index;
  final List<Note> _noteList;
  CubitCreatePage _cubit;

  _CreatePageState(this._noteList, this._isEditing, this._index) {
    _cubit = CubitCreatePage(StatesCreatePage(0));
  }

  @override
  void initState() {
    if (_isEditing) {
      _textEditingController.text = _noteList[_index].title;
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
              _isEditing ? _appBar('Edit event') : _appBar('Create new event'),
          body: _createPageBody(state),
          floatingActionButton: _floatingActionButton(state),
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

  FloatingActionButton _floatingActionButton(StatesCreatePage state) {
    return FloatingActionButton(
      child: Icon(
        Icons.check,
      ),
      onPressed: () {
        _isEditing ? _editPage(state) : _createPage(state);
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    );
  }

  void _editPage(StatesCreatePage state) {
    _noteList[_index].title = _textEditingController.text;
    _noteList[_index].circleAvatarIndex = state.selectedIconIndex;
    _cubit.editPage(_noteList[_index]);
  }

  void _createPage(StatesCreatePage state) async {
    var note = Note(
      title: _textEditingController.text,
      subtitle: 'No events. Click to create one.',
      circleAvatarIndex: state.selectedIconIndex,
    );
    _noteList.insert(0, note);
    await _cubit.addPage(note);
  }

  Column _createPageBody(StatesCreatePage state) {
    return Column(
      children: <Widget>[
        _inputArea(state),
        _iconsGrid,
      ],
    );
  }

  Widget _inputArea(StatesCreatePage state) {
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
                  Icon(icons[state.selectedIconIndex]), Colors.green),
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
