import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../icon_list.dart';
import '../main.dart';
import 'note.dart';
import 'notes_cubit.dart';

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
  NotesCubit _cubit;
  _NotePageState({this.noteList, this.note}) {
    _cubit = NotesCubit(NotesState(note, noteList));
  }

  @override
  void initState() {
    if (note != null) {
      _cubit.state.indexOfSelectIcon = note.indexOfCircleAvatar;
      textController.text = note.noteName;
      _focusNode.requestFocus();
    } else {
      _cubit.state.indexOfSelectIcon = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _notePageBody(context),
          floatingActionButton: _floatingActionButton,
        );
      },
    );
  }

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
              _cubit.setIndexOfIcon(
                index,
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
          child: CircleAvatar(
            child: listOfIcons[_cubit.state.indexOfSelectIcon],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 30),
            child: TextField(
              style: TextStyle(
                color: Colors.black,
              ),
              controller: textController,
              focusNode: _focusNode,
              onChanged: (value) {
                value.isNotEmpty
                    ? _cubit.setWritingState(true)
                    : _cubit.setWritingState(false);
              },
              decoration: InputDecoration(
                hintText: 'Enter event',
                hintStyle: TextStyle(
                  color: Colors.black45,
                ),
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
        _floatingActionButtonEvent();
      },
      child: _cubit.state.isWriting
          ? Icon(
              Icons.check,
            )
          : Icon(
              Icons.clear,
            ),
    );
  }

  void _floatingActionButtonEvent() {
    if (note != null && _cubit.state.isWriting) {
      note.noteName = textController.text;
      note.indexOfCircleAvatar = _cubit.state.indexOfSelectIcon;
      Navigator.of(context).pop();
    } else {
      if (_cubit.state.isWriting) {
        _cubit.addNote(textController.text);
        Navigator.of(context).pop();
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
