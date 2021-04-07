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
  final TextEditingController _textController = TextEditingController();

  _NotePageState({this.noteList, this.note});

  @override
  void initState() {
    if (note != null) {
      BlocProvider.of<NotesCubit>(context)
          .setIndexOfIcon(note.indexOfCircleAvatar);
      _textController.text = note.noteName;
      _focusNode.requestFocus();
    } else {
      BlocProvider.of<NotesCubit>(context).setIndexOfIcon(0);
    }
    BlocProvider.of<NotesCubit>(context).init(note, noteList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _notePageBody(context, state),
          floatingActionButton: _floatingActionButton(state),
        );
      },
    );
  }

  Widget _notePageBody(BuildContext context, NotesState state) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: _textFieldAria(state),
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
            onTap: () =>
                BlocProvider.of<NotesCubit>(context).setIndexOfIcon(index),
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

  Row _textFieldAria(NotesState state) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: CircleAvatar(
            child: listOfIcons[state.indexOfSelectIcon],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 30),
            child: TextField(
              style: TextStyle(
                color: Colors.black,
              ),
              controller: _textController,
              focusNode: _focusNode,
              onChanged: (value) => value.isNotEmpty
                  ? BlocProvider.of<NotesCubit>(context).setWritingState(true)
                  : BlocProvider.of<NotesCubit>(context).setWritingState(false),
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

  FloatingActionButton _floatingActionButton(NotesState state) {
    return FloatingActionButton(
      onPressed: () => _floatingActionButtonEvent(state),
      child: state.isWriting
          ? Icon(
              Icons.check,
            )
          : Icon(
              Icons.clear,
            ),
    );
  }

  void _floatingActionButtonEvent(NotesState state) {
    if (note != null && state.isWriting) {
      note.noteName = _textController.text;
      note.indexOfCircleAvatar = state.indexOfSelectIcon;
      Navigator.of(context).pop();
    } else {
      if (state.isWriting) {
        BlocProvider.of<NotesCubit>(context).addNote(_textController.text);
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
