import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../event.dart';
import '../note.dart';
import '../utils/icons.dart';
import 'cubit_event_page.dart';
import 'states_event_page.dart';

class EventPage extends StatefulWidget {
  final Note note;
  final List<Note> noteList;

  EventPage({Key key, this.note, this.noteList}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(note, noteList);
}

class _EventPageState extends State<EventPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textSearchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusSearchNode = FocusNode();
  final Note _note;
  final List<Note> _noteList;
  List<Event> _searchEventList;
  CubitEventPage _cubit;

  _EventPageState(this._note, this._noteList) {
    _cubit = CubitEventPage(StatesEventPage(_note));
  }

  @override
  void initState() {
    _focusNode.requestFocus();
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: state.isEventSelected
              ? _editingTextAppBar(state, state.selectedItemIndex)
              : _defaultAppBar(state),
          body: _eventPageBody(state),
        );
      },
    );
  }

  AppBar _editingTextAppBar(StatesEventPage state, int index) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () => _cubit.changeAppBar(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.reply,
          ),
          onPressed: () {
            _cubit.changeAppBar();
            _showReplyDialog(index);
          },
        ),
        if (state.currentEventsList[index].imagePath == null)
          IconButton(
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () {
              _cubit.changeAppBar();
              _cubit.setTextEditState(true);
              _textController.text = state.currentEventsList[index].text;
              _textController.selection = TextSelection(
                baseOffset: _textController.text.length,
                extentOffset: _textController.text.length,
              );
            },
          ),
        if (state.currentEventsList[index].imagePath == null)
          IconButton(
            icon: Icon(
              Icons.copy,
            ),
            onPressed: () {
              _cubit.changeAppBar();
              _copyEvent(state, index);
            },
          ),
        IconButton(
          icon: Icon(
            Icons.bookmark_border,
          ),
          onPressed: () {
            _cubit.changeAppBar();
            //TODO
          },
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
          ),
          onPressed: () {
            _cubit.changeAppBar();
            _cubit.deleteEvent(index);
          },
        ),
      ],
    );
  }

  AppBar _defaultAppBar(StatesEventPage state) {
    return AppBar(
      title: state.isSearch
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
              state.isSearch ? Icons.clear : Icons.search,
            ),
            onPressed: () {
              _cubit.setTextSearchState(!state.isSearch);
              _textSearchController.addListener(
                () {
                  _cubit.setCurrentEventsList(state.currentEventsList);
                },
              );
              _focusSearchNode.requestFocus();
            },
          ),
        ),
      ],
    );
  }

  Widget _eventPageBody(StatesEventPage state) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: _directionality(state),
            ),
            if (state.isAddingPhoto)
              Padding(
                padding: EdgeInsets.all(10.0),
                child: _imageChooserRow,
              ),
            Align(
              child: _bottomInputWidgets(state),
            ),
          ],
        ),
        if (state.isDateTimeModification)
          Align(
            alignment: state.isBubbleAlignment
                ? Alignment.topLeft
                : Alignment.topRight,
            child: GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  right: 10,
                  left: 10,
                ),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(70)),
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                  ),
                  child: _calendarRow(state),
                ),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(date),
                  );
                  _cubit.setSelectedDate(DateFormat.yMMMd().format(date));
                  if (time != null) {
                    _cubit.setSelectedTime(time.format(context));
                  }
                }
              },
            ),
          ),
      ],
    );
  }

  TextField get _textFieldSearch {
    return TextField(
      controller: _textSearchController,
      focusNode: _focusSearchNode,
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
                child: _dialogColumn(state, index),
              ),
            );
          },
        );
      },
    );
  }

  Column _dialogColumn(StatesEventPage state, int index) {
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
        Expanded(child: _dialogListView(state)),
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
        _cubit.transferEvent(_noteList, index);
        Navigator.pop(context);
      },
    );
  }

  ListView _dialogListView(StatesEventPage state) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _noteList.length,
      itemBuilder: (context, index) {
        return _radioListTile(state, index);
      },
    );
  }

  RadioListTile _radioListTile(StatesEventPage state, int index) {
    return RadioListTile(
      title: Text(_noteList[index].title),
      value: index,
      activeColor: Theme.of(context).accentColor,
      groupValue: state.selectedPageReplyIndex,
      onChanged: (value) => _cubit.setSelectedPageReplyIndex(value),
    );
  }

  Directionality _directionality(StatesEventPage state) {
    return Directionality(
      textDirection:
          state.isBubbleAlignment ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: _listView(state),
    );
  }

  Row _calendarRow(StatesEventPage state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today_outlined,
          color: Colors.white,
          size: 18,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: Text(
            _calendarTitle(state),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        if (state.selectedDate != null)
          GestureDetector(
            child: Icon(
              Icons.clear,
              color: Colors.white,
              size: 18,
            ),
            onTap: () => _cubit.resetDateTimeModifications(),
          ),
      ],
    );
  }

  String _calendarTitle(StatesEventPage state) {
    if (state.selectedDate != null && state.selectedTime != null) {
      return '${state.selectedDate} ${state.selectedTime}';
    } else if (state.selectedTime == null && state.selectedDate != null) {
      return '${state.selectedDate}';
    } else {
      return 'Calendar';
    }
  }

  ListTile _imageChooserListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Row get _imageChooserRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _chooseImageResource(
            Icons.add_a_photo, 'Open camera', ImageSource.camera),
        _chooseImageResource(Icons.photo, 'Open gallery', ImageSource.gallery),
      ],
    );
  }

  GestureDetector _chooseImageResource(
      IconData icon, String text, ImageSource imageSource) {
    return GestureDetector(
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
          color: Theme.of(context).primaryColor,
        ),
        child: _imageChooserListTile(
          icon,
          text,
        ),
      ),
      onTap: () async {
        final image = await ImagePicker().getImage(source: imageSource);
        if (image != null) {
          _cubit.addImageEvent(File(image.path));
        }
      },
    );
  }

  void updateList(StatesEventPage state) {
    if (state.isSearch) {
      _searchEventList = state.currentEventsList
          .where((element) => element.text.contains(_textSearchController.text))
          .toList();
    } else {
      _searchEventList = state.currentEventsList;
    }
  }

  ListView _listView(StatesEventPage state) {
    _cubit.sortEventsByDate();
    updateList(state);
    return ListView.builder(
      reverse: true,
      scrollDirection: Axis.vertical,
      itemCount: _searchEventList.length,
      itemBuilder: (context, index) {
        final _event = _searchEventList[index];
        return _showEventList(state, _event, index);
      },
    );
  }

  Widget _showEventList(StatesEventPage state, Event event, int index) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
            ),
            child: Align(
              alignment: state.isCenterDateBubble
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    title: Center(
                      child: Text(
                        event.date,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              elevation: 3,
              child: ListTile(
                leading: event.circleAvatarIndex != null
                    ? _circleAvatar(
                        icons[event.circleAvatarIndex],
                      )
                    : null,
                tileColor: Theme.of(context).appBarTheme.color,
                title: event.imagePath != null
                    ? Image.file(
                        File(event.imagePath),
                      )
                    : Text(
                        event.text,
                        style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .foregroundColor,
                        ),
                      ),
                subtitle: Text(
                  event.time,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .foregroundColor,
                  ),
                ),
                onLongPress: () {
                  _cubit.setSelectedItemIndex(index);
                  _cubit.changeAppBar();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _bottomInputWidgets(StatesEventPage state) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: state.selectedIconIndex != null
              ? Icon(icons[state.selectedIconIndex])
              : Icon(Icons.category),
          iconSize: 30,
          color: Theme.of(context).appBarTheme.color,
          onPressed: () => _showBottomSheet(context),
        ),
        Expanded(
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            onChanged: (value) {
              if (value.isNotEmpty) {
                _cubit.setSendButtonState(false);
                _cubit.setAddingPhotoState(false);
              } else {
                _cubit.setSendButtonState(true);
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter event...',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            state.isSendPhotoButton ? Icons.add_a_photo : Icons.send,
          ),
          iconSize: 30,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          onPressed: () {
            if (state.isSendPhotoButton) {
              _cubit.setAddingPhotoState(true);
            } else {
              state.isEditing
                  ? _cubit.editText(
                      state.selectedItemIndex, _textController.text)
                  : _cubit.addEvent(_textController.text);
              _textController.clear();
              _cubit.removeSelectedIcon();
              _cubit.updateCurrentNoteSubtitle();
              _cubit.setSendButtonState(true);
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

  void _copyEvent(StatesEventPage state, int index) => Clipboard.setData(
      ClipboardData(text: state.currentEventsList[index].text));
}
