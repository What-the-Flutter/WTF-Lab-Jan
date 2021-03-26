import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lesson_1/utils/database.dart';
import 'package:intl/intl.dart';

import '../event.dart';
import '../note_page.dart';
import '../utils/icons.dart';
import 'cubit_event_page.dart';
import 'states_event_page.dart';

class EventPage extends StatefulWidget {
  final NotePage note;
  final List<NotePage> noteList;

  EventPage({Key key, this.note, this.noteList}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(note, noteList);
}

class _EventPageState extends State<EventPage> {
  final DatabaseProvider _databaseProvider = DatabaseProvider();
  final TextEditingController textController = TextEditingController();
  final TextEditingController textSearchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final FocusNode focusSearchNode = FocusNode();
  final NotePage _note;
  final List<NotePage> _noteList;
  List<Event> _searchEventList;
  CubitEventPage _cubit;

  _EventPageState(this._note, this._noteList) {
    _cubit = CubitEventPage(StatesEventPage(_note));
  }

  @override
  void initState() {
    focusNode.requestFocus();
    _cubit.initEventsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _cubit.state.isEventSelected
              ? _editingTextAppBar(_cubit.state.selectedItemIndex)
              : _defaultAppBar,
          body: _eventPageBody,
        );
      },
    );
  }

  void _changeAppBar() {
    _cubit.setSelectedEventState(!_cubit.state.isEventSelected);
  }

  TextField get _textFieldSearch {
    return TextField(
      controller: textSearchController,
      focusNode: focusSearchNode,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: 'Enter event...',
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        border: InputBorder.none,
        filled: false,
      ),
    );
  }

  AppBar get _defaultAppBar {
    return AppBar(
      title: _cubit.state.isSearch
          ? _textFieldSearch
          : Text(
              _note.title,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(
              _cubit.state.isSearch ? Icons.clear : Icons.search,
            ),
            onPressed: () {
              _cubit.openSearchAppBar(textSearchController);
              focusSearchNode.requestFocus();
            },
          ),
        ),
      ],
    );
  }

  AppBar _editingTextAppBar(int index) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: _changeAppBar,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.reply,
          ),
          onPressed: () {
            _changeAppBar();
            _showReplyDialog(index);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
          ),
          onPressed: () {
            _changeAppBar();
            _cubit.editEvent(index, textController);
          },
        ),
        IconButton(
            icon: Icon(
              Icons.copy,
            ),
            onPressed: () {
              _changeAppBar();
              _copyEvent(index);
            }),
        IconButton(
            icon: Icon(
              Icons.bookmark_border,
            ),
            onPressed: () {
              _changeAppBar();
              // need to change
            }),
        IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () {
              _changeAppBar();
              _cubit.deleteEvent(index);
            }),
      ],
    );
  }

  void _showReplyDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder(
          cubit: _cubit,
          builder: (context, state) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 3,
              child: Container(
                height: 400,
                child: _dialogColumn(index),
              ),
            );
          },
        );
      },
    );
  }

  Column _dialogColumn(int index) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 15,
          ),
          child: Text(
            'Choose the page to migrate event',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Expanded(child: _dialogListView),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                bottom: 15,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
                bottom: 15,
                left: 180,
              ),
              child: _transferEventButton(index),
            ),
          ],
        ),
      ],
    );
  }

  IconButton _transferEventButton(int index) {
    return IconButton(
      icon: Icon(
        Icons.check,
        size: 50,
        color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      ),
      onPressed: () {
        final event = Event(
          text: _cubit.state.currentEventsList[index].text,
          time: DateFormat('dd-MM-yyyy kk:mm').format(
            DateTime.now(),
          ),
          currentNoteId: _noteList[_cubit.state.selectedPageReplyIndex].noteId,
          circleAvatarIndex:
              _cubit.state.currentEventsList[index].circleAvatarIndex,
        );
        _cubit.deleteEvent(index);
        _databaseProvider.insertEvent(event);
        Navigator.pop(context);
      },
    );
  }

  ListView get _dialogListView {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _noteList.length,
      itemBuilder: (context, index) {
        return _radioListTile(index);
      },
    );
  }

  RadioListTile _radioListTile(int index) {
    return RadioListTile(
      title: Text(_noteList[index].title),
      value: index,
      activeColor: Theme.of(context).accentColor,
      groupValue: _cubit.state.selectedPageReplyIndex,
      onChanged: (value) {
        _cubit.setSelectedPageReplyIndex(value);
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
          child: _bottomInputWidgets,
        ),
      ],
    );
  }

  void updateList() {
    if (_cubit.state.isSearch) {
      _searchEventList = _cubit.state.currentEventsList
          .where((element) => element.text.contains(textSearchController.text))
          .toList();
    } else {
      _searchEventList = _cubit.state.currentEventsList;
    }
  }

  ListView get _listView {
    updateList();
    return ListView.builder(
      reverse: true,
      scrollDirection: Axis.vertical,
      itemCount: _searchEventList.length,
      itemBuilder: (context, index) {
        final _event = _searchEventList[index];
        return _showEventList(_event, index);
      },
    );
  }

  Widget _showEventList(Event event, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 3,
          child: ListTile(
            leading:
                _cubit.state.currentEventsList[index].circleAvatarIndex != null
                    ? _circleAvatar(
                        icons[_cubit
                            .state.currentEventsList[index].circleAvatarIndex],
                      )
                    : null,
            tileColor: Theme.of(context).appBarTheme.color,
            title: Text(
              event.text,
              style: TextStyle(
                fontSize: 17,
                color:
                    Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
            ),
            subtitle: Text(
              event.time,
              style: TextStyle(
                fontSize: 15,
                color:
                    Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
            ),
            onLongPress: () {
              _cubit.setSelectedItemIndex(index);
              _changeAppBar();
            },
          ),
        ),
      ),
    );
  }

  Row get _bottomInputWidgets {
    return Row(
      children: <Widget>[
        IconButton(
          icon: _cubit.state.selectedIconIndex != null
              ? Icon(icons[_cubit.state.selectedIconIndex])
              : Icon(Icons.category),
          iconSize: 30,
          color: Theme.of(context).appBarTheme.color,
          onPressed: () {
            _showBottomSheet(context);
          },
        ),
        Expanded(
          child: TextField(
            controller: textController,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Enter event...',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.send,
          ),
          iconSize: 30,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          onPressed: () {
            if (_cubit.state.isEditing) {
              _cubit.editText(_cubit.state.selectedItemIndex, textController);
            } else {
              _cubit.addEvent(textController);
            }
            _cubit.updateNoteSubtitle();
            _cubit.removeSelectedIcon();
          },
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: icons.length,
            itemBuilder: (context, index) => _iconButton(index),
          ),
        );
      },
    );
  }

  IconButton _iconButton(int index) {
    return IconButton(
      icon: _circleAvatar(icons[index]),
      onPressed: () {
        _cubit.setSelectedIcon(index);
        Navigator.pop(context);
      },
    );
  }

  CircleAvatar _circleAvatar(IconData icon) {
    return CircleAvatar(
      child: Icon(
        icon,
        size: 30,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void _copyEvent(int index) => Clipboard.setData(
      ClipboardData(text: _cubit.state.currentEventsList[index].text));
}
