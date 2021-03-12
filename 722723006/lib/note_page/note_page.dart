import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  NotesCubit cubit;
  _NotePageState({this.noteList, this.note}) {
    cubit = NotesCubit(NotesState(note, noteList));
  }

  @override
  void initState() {
    if (note != null) {
      cubit.state.selectIcon = CircleAvatar(
        child: note.iconData,
      );
      textController.text = note.eventName;
      _focusNode.requestFocus();
    } else {
      cubit.state.selectIcon = CircleAvatar(
        child: Icon(Icons.fastfood),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _notePageBody(context),
          floatingActionButton: _floatingActionButton,
        );
      },
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
              cubit.setCircleIcon(
                CircleAvatar(
                  child: listOfIcons[index],
                ),
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
          child: cubit.state.selectIcon,
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
                    ? cubit.setWritingState(true)
                    : cubit.setWritingState(false);
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
      child: cubit.state.isWriting ? Icon(Icons.check) : Icon(Icons.clear),
    );
  }

  void _floatingActionButtonEvent() {
    if (note != null && cubit.state.isWriting) {
      note.eventName = textController.text;
      note.iconData = CircleAvatar(
        child: cubit.state.selectIcon,
      );
      Navigator.of(context).pop();
    } else {
      if (cubit.state.isWriting) {
        cubit.addNote(textController.text);
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
