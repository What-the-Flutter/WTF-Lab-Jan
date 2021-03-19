import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../data/db_provider.dart';
import '../icon_list.dart';
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
  EventCubit _cubit;
  DBProvider dbProvider = DBProvider();
  @override
  void initState() {
    super.initState();
    _cubit.initEventList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _cubit.state.eventSelected
              ? _defaultAppBar
              : _appBarMenu(_cubit.state.indexOfSelectedElement),
          body: _eventPageBody,
        );
      },
    );
  }

  _EventPageState(this._note, this._noteList) {
    _cubit = EventCubit(EventsState(_note));
  }

  AppBar get _defaultAppBar {
    return AppBar(
      leading: _iconButtonBack,
      title: _cubit.state.isIconButtonSearchPressed
          ? TextField(
              focusNode: _searchTextFieldFocusNode,
              controller: searchTextController,
              onChanged: (value) {
                value.isEmpty
                    ? _cubit.setWritingState(false)
                    : _cubit.setWritingState(true);
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
        _cubit.state.isWriting
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  searchTextController.clear;
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  _searchTextFieldFocusNode.requestFocus();
                  _cubit.setIconButtonSearchPressedState(
                    !_cubit.state.isIconButtonSearchPressed,
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
        if (_cubit.state.isIconButtonSearchPressed) {
          _cubit.setIconButtonSearchPressedState(false);
          _cubit.setWritingState(false);
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
    _cubit.state.isIconButtonSearchPressed
        ? _eventList = _cubit.state.eventList
            .where(
                (element) => element.text.contains(searchTextController.text))
            .toList()
        : _eventList = _cubit.state.eventList;
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
          icon: _cubit.state.indexOfCircleAvatar == null
              ? Icon(Icons.widgets_outlined)
              : CircleAvatar(
                  child: listOfIcons[_cubit.state.indexOfCircleAvatar],
                ),
          iconSize: 25,
          color: Colors.blueGrey,
          onPressed: () {
            _cubit
                .setIndexOfCircleAvatar(_cubit.state.note.indexOfCircleAvatar);
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
      itemCount: listOfIcons.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            width: 100,
            child: Column(
              children: [
                CircleAvatar(
                  child: listOfIcons[index],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Center(
                    child: Text(
                      listOfIconsName[index],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            _cubit.setIndexOfCircleAvatar(index);
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
        _cubit.state.isEditing
            ? _cubit.editText(
                _cubit.state.indexOfSelectedElement, textController)
            : _cubit.sendEvent(textController);
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
            leading: _cubit.state.eventList[index].indexOfCircleAvatar != null
                ? CircleAvatar(
                    child: listOfIcons[
                        _cubit.state.eventList[index].indexOfCircleAvatar],
                  )
                : null,
            title: Text(
              event.text,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              event.time,
              style: TextStyle(color: Colors.white54),
            ),
            onLongPress: () {
              _cubit.setIndexOfSelectedElement(index);
              _appBarChange();
            },
          ),
        ),
      ),
    );
  }

  void _appBarChange() {
    _cubit.setEventSelectedState(!_cubit.state.eventSelected);
  }

  AppBar _appBarMenu(int index) {
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
            _cubit.editEvent(index, textController);
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
            _cubit.deleteEvent(index);
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
          cubit: _cubit,
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
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
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
      icon: Icon(
        Icons.check,
        color: Colors.green[400],
      ),
      onPressed: () {
        final event = Event(
          text: _cubit.state.eventList[index].text,
          time: DateFormat('yyyy-MM-dd kk:mm').format(
            DateTime.now(),
          ),
          noteId: _noteList[_cubit.state.selectedTile].id,
          indexOfCircleAvatar:
              _cubit.state.eventList[index].indexOfCircleAvatar,
        );
        _updateSubTittle();
        _cubit.deleteEvent(index);
        dbProvider.insertEvent(event);
        Navigator.pop(context);
      },
    );
  }

  void _updateSubTittle() {
    _cubit.state.eventList.isEmpty
        ? _noteList[_cubit.state.selectedTile].subTittleEvent = 'Add event'
        : _noteList[_cubit.state.selectedTile].subTittleEvent =
            _cubit.state.eventList[0].text;
  }

  Widget _showDialogEventList(int index) {
    return RadioListTile(
      title: Text(
        _noteList[index].noteName,
      ),
      value: index,
      groupValue: _cubit.state.selectedTile,
      onChanged: (value) {
        _cubit.setIndexOfSelectedTile(value);
      },
    );
  }

  void _copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: _cubit.state.eventList[index].text));
  }
}
