import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../note_page/note.dart';
import 'event.dart';
import 'events_cubit.dart';

class EventPage extends StatefulWidget {
  final String title;
  final Note note;
  final List<Note> noteList;

  EventPage({Key key, this.title, this.note, this.noteList}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(note, noteList);
}

class _EventPageState extends State<EventPage> {
  final Note _note;
  final List<Note> _noteList;
  final TextEditingController textController = TextEditingController();
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchTextFieldFocusNode = FocusNode();
  List<Event> _eventList;
  EventCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: cubit.state.eventSelected
              ? _defaultAppBar
              : _appBarMenu(cubit.state.indexOfSelectedElement),
          body: _eventPageBody,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _EventPageState(this._note, this._noteList) {
    cubit = EventCubit(EventsState(_note));
  }

  AppBar get _defaultAppBar {
    return AppBar(
      leading: _iconButtonBack,
      title: cubit.state.isIconButtonSearchPressed
          ? TextField(
              focusNode: _searchTextFieldFocusNode,
              controller: searchTextController,
              onChanged: (value) {
                value.isEmpty
                    ? cubit.setWritingState(false)
                    : cubit.setWritingState(true);
              },
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
            )
          : Text(widget.title),
      actions: [
        cubit.state.isWriting
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  setState(searchTextController.clear);
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  _searchTextFieldFocusNode.requestFocus();
                  cubit.setIconButtonSearchPressedState(
                    !cubit.state.isIconButtonSearchPressed,
                  );
                },
              ),
        IconButton(
          icon: Icon(
            Icons.bookmark_border,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  IconButton get _iconButtonBack {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        if (cubit.state.isIconButtonSearchPressed) {
          cubit.setIconButtonSearchPressedState(false);
          cubit.setWritingState(false);
          searchTextController.clear();
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget get _eventPageBody {
    return Column(
      children: <Widget>[
        Expanded(
          child: _listView,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black12,
                ),
              ),
            ),
            child: _textFieldArea,
          ),
        ),
      ],
    );
  }

  ListView get _listView {
    cubit.state.isIconButtonSearchPressed
        ? _eventList = _note.eventList
            .where(
                (element) => element.text.contains(searchTextController.text))
            .toList()
        : _eventList = _note.eventList;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: _eventList.length,
      itemBuilder: (context, index) {
        return _showEventList(_eventList[index], index);
      },
    );
  }

  Row get _textFieldArea {
    return Row(
      children: <Widget>[
        IconButton(
          icon: cubit.state.circleAvatar ?? Icon(Icons.widgets_outlined),
          iconSize: 25,
          color: Colors.blueGrey,
          onPressed: () {
            cubit.setCircleAvatar(cubit.state.circleAvatar);
            _showHorizontalListView(context);
          },
        ),
        Expanded(
          child: TextField(
            controller: textController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Enter event',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        _sendButton,
      ],
    );
  }

  void _showHorizontalListView(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          height: 60,
          child: _horizontalListView,
        );
      },
    );
  }

  ListView get _horizontalListView {
    return ListView.builder(
      itemCount: _noteList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            width: 100,
            child: Column(
              children: [
                _noteList[index].iconData,
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Center(
                    child: Text(
                      _noteList[index].eventName,
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            cubit.setCircleAvatar(_noteList[index].iconData);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  IconButton get _sendButton {
    return IconButton(
      icon: Icon(Icons.send),
      iconSize: 29,
      color: Colors.blueGrey,
      onPressed: () {
        cubit.state.isEditing
            ? cubit.editText(cubit.state.indexOfSelectedElement, textController)
            : cubit.sendEvent(textController);
        cubit.state.circleAvatar = null;
      },
    );
  }

  Widget _showEventList(Event event, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 3,
          color: Theme.of(context).primaryColor,
          child: ListTile(
            leading: cubit.state.note.eventList[index].circleAvatar,
            title: Text(
              event.text,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              event.time,
              style: TextStyle(color: Colors.white54),
            ),
            onLongPress: () {
              cubit.setIndexOfSelectedElement(index);
              _appBarChange();
            },
          ),
        ),
      ),
    );
  }

  void _appBarChange() {
    cubit.setEventSelectedState(!cubit.state.eventSelected);
  }

  AppBar _appBarMenu(int index, {int count}) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          _appBarChange();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.reply),
          onPressed: () {
            _appBarChange();
            _showDialogWindow(index);
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _appBarChange();
            cubit.editEvent(index, textController);
            _focusNode.requestFocus();
          },
        ),
        IconButton(
          icon: Icon(Icons.copy),
          onPressed: () {
            _appBarChange();
            _copyEvent(index);
          },
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {
            _appBarChange();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _appBarChange();
            cubit.deleteEvent(index);
          },
        ),
      ],
    );
  }

  void _showDialogWindow(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder(
          cubit: cubit,
          builder: (context, state) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 16,
              child: Container(
                width: 300,
                height: 450,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _noteList.length,
                        itemBuilder: (context, index) {
                          return _showDialogEventList(index);
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 150),
                          child: _confirmTransferButton(index),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconButton _confirmTransferButton(int index) {
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: () {
        _noteList[cubit.state.selectedTile].eventList.insert(
              0,
              Event(
                text: _note.eventList[index].text,
                time: DateFormat('yyyy-MM-dd kk:mm').format(
                  DateTime.now(),
                ),
                circleAvatar: _note.eventList[index].circleAvatar,
              ),
            );
        _updateSubTittle();
        cubit.deleteEvent(index);
        Navigator.pop(context);
      },
    );
  }

  void _updateSubTittle() {
    _noteList[cubit.state.selectedTile].eventList.isEmpty
        ? _noteList[cubit.state.selectedTile].subTittleEvent = 'Add event'
        : _noteList[cubit.state.selectedTile].subTittleEvent =
            _note.eventList[0].text;
  }

  Widget _showDialogEventList(int index) {
    return RadioListTile(
      title: Text(
        _noteList[index].eventName,
      ),
      value: index,
      groupValue: cubit.state.selectedTile,
      onChanged: (value) {
        cubit.setIndexOfSelectedTile(value);
      },
    );
  }

  void _copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: _note.eventList[index].text));
  }
}
