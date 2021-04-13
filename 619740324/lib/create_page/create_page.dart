import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../note.dart';
import 'cubit_create_page.dart';
import 'icons.dart';
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
  List<Note> noteList;
  final bool isEditing;
  final int index;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  CubitCreatePage _cubit;

  _CreatePageState(this.noteList, this.isEditing, this.index) {
    _cubit = CubitCreatePage(StatesCreatePage(0, noteList));
  }

  @override
  void initState() {
    if (isEditing) {
      _cubit.state.indexOfSelectedIcon = noteList[index].indexOfCircleAvatar;
      _textController.text = noteList[index].eventName;
      _focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: isEditing
              ? _appBar('Edit you page')
              : _appBar('Create a new page'),
          body: createPageBody,
          floatingActionButton: _floatingActionButton,
        );
      },
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      child: Icon(Icons.check),
      onPressed: () {
        isEditing ? _editPage() : _cubit.addNote(_textController.text);
        if (_textController.text.isNotEmpty) {
          Navigator.pop(context);
        }
      },
    );
  }

  void _editPage() {
    if (_textController.text.isNotEmpty) {
      noteList[index].eventName = _textController.text;
      noteList[index].indexOfCircleAvatar = _cubit.state.indexOfSelectedIcon;
    }
  }

  Column get createPageBody {
    return Column(
      children: <Widget>[
        _inputText,
        Expanded(
          child: _iconGrid,
        ),
      ],
    );
  }

  Widget get _inputText {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            child: listIcons[_cubit.state.indexOfSelectedIcon],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name of the page ',
              ),
            ),
          ),
        ),
      ],
    );
  }

  GridView get _iconGrid {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listIcons.length,
      itemBuilder: (context, index) {
        return IconButton(
          icon: _circleAvatar(listIcons[index]),
          onPressed: () => _cubit.setIndexOfIcon(index),
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
        padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
        child: Text(title),
      ),
    );
  }
}

CircleAvatar _circleAvatar(Icon icon) {
  return CircleAvatar(
    child: icon,
  );
}
