import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event.dart';
import '../note_page.dart';
import 'cubit_event_page.dart';
import 'states_event_page.dart';

class EventPage extends StatefulWidget {
  final NotePage notePage;
  final List<NotePage> noteList;

  EventPage({Key key, this.notePage, this.noteList}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(notePage, noteList);
}

class _EventPageState extends State<EventPage> {
  final NotePage _notePage;
  final List<NotePage> _noteList;
  CubitEventPage cubit;

  _EventPageState(this._notePage, this._noteList) {
    cubit = CubitEventPage(StatesEventPage(_notePage.eventList));
  }

  @override
  void initState() {
    cubit.state.focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: cubit.state.isEventSelected
              ? _editingTextAppBar(cubit.state.selectedItemIndex)
              : _defaultAppBar,
          body: _eventPageBody,
        );
      },
    );
  }

  void _changeAppBar() {
    cubit.setSelectedEventState(!cubit.state.isEventSelected);
  }

  TextField get _textFieldSearch {
    return TextField(
      controller: cubit.state.textSearchController,
      focusNode: cubit.state.focusSearchNode,
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
      title: cubit.state.isSearch ? _textFieldSearch : _notePage.title,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(
              cubit.state.isSearch ? Icons.clear : Icons.search,
            ),
            onPressed: () {
              cubit.openSearchAppBar();
            },
          ),
        ),
      ],
    );
  }

  AppBar _editingTextAppBar(var index) {
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
            cubit.editEvent(index);
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
              cubit.deleteEvent(index);
            }),
      ],
    );
  }

  void _showReplyDialog(var index) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder(
          cubit: cubit,
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

  Column _dialogColumn(var index) {
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
              child: IconButton(
                icon: Icon(
                  Icons.check,
                  size: 50,
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                onPressed: () {
                  _noteList[cubit.state.selectedPageReplyIndex]
                      .eventList
                      .insert(0, cubit.state.currentEventsList[index]);
                  cubit.deleteEvent(index);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
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

  RadioListTile _radioListTile(var index) {
    return RadioListTile(
      title: _noteList[index].title,
      value: index,
      activeColor: Theme.of(context).accentColor,
      groupValue: cubit.state.selectedPageReplyIndex,
      onChanged: (value) {
        cubit.setSelectedPageReplyIndex(value);
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
    if (cubit.state.isSearch) {
      cubit.state.currentEventsList = _notePage.eventList
          .where((element) =>
              element.text.contains(cubit.state.textSearchController.text))
          .toList();
    } else {
      cubit.setCurrentEventsList(_notePage.eventList);
    }
  }

  ListView get _listView {
    updateList();
    return ListView.builder(
      reverse: true,
      scrollDirection: Axis.vertical,
      itemCount: cubit.state.currentEventsList.length,
      itemBuilder: (context, index) {
        final _event = cubit.state.currentEventsList[index];
        return _showEventList(_event, index);
      },
    );
  }

  Widget _showEventList(Event event, var index) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 3,
          child: ListTile(
            leading: cubit.state.currentEventsList[index].circleAvatar,
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
              cubit.setSelectedItemIndex(index);
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
          icon: Icon(cubit.state.selectedIcon ?? Icons.category),
          iconSize: 30,
          color: Theme.of(context).appBarTheme.color,
          onPressed: () {
            _showBottomSheet(context);
          },
        ),
        Expanded(
          child: TextField(
            controller: cubit.state.textController,
            focusNode: cubit.state.focusNode,
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
            if (cubit.state.isEditing) {
              cubit.editText(
                  cubit.state.selectedItemIndex,
                  _circleAvatar(cubit.state.selectedIcon,
                      Theme.of(context).primaryColor));
            } else {
              cubit.addEvent(_circleAvatar(
                  cubit.state.selectedIcon, Theme.of(context).primaryColor));
            }
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
            itemCount: cubit.state.bottomSheetButtons.length,
            itemBuilder: (context, index) => _iconButton(index),
          ),
        );
      },
    );
  }

  IconButton _iconButton(var index) {
    return IconButton(
      icon: _circleAvatar(cubit.state.bottomSheetButtons[index],
          Theme.of(context).primaryColor),
      onPressed: () {
        if (index != 0) {
          cubit.state.selectedIcon = cubit.state.bottomSheetButtons[index];
        } else {
          cubit.state.selectedIcon = null;
        }
        Navigator.pop(context);
      },
    );
  }

  CircleAvatar _circleAvatar(IconData icon, Color color) {
    if (icon == null) {
      return null;
    }
    if (icon == Icons.clear) {
      color = Colors.red;
    }
    return CircleAvatar(
      child: Icon(
        icon,
        size: 30,
        color: Colors.white,
      ),
      backgroundColor: color,
    );
  }

  void _copyEvent(var index) => Clipboard.setData(
      ClipboardData(text: cubit.state.currentEventsList[index].text));
}
