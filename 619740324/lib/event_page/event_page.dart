import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../create_page/icons.dart';
import '../data/shared_preferences_provider.dart';
import '../event.dart';
import '../note.dart';
import 'cubit_event_page.dart';
import 'states_event_page.dart';

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
  final List<Note> noteList;
  final TextEditingController textController = TextEditingController();
  TextEditingController textSearchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  CubitEventPage _cubit;

  _EventPageState(this._note, this.noteList) {
    _cubit = CubitEventPage(StatesEventPage(note: _note));
  }

  @override
  void initState() {
    _focusNode.requestFocus();
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitEventPage, StatesEventPage>(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: state.isSearch ? searchAppBar : _defaultAppBar(state),
          body: _eventPageBody(state),
        );
      },
    );
  }

  TextField get _textFieldSearch {
    return TextField(
      controller: textSearchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Enter text',
        border: InputBorder.none,
        filled: true,
      ),
    );
  }

  AppBar get searchAppBar {
    return AppBar(
      title: _textFieldSearch,
      actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              textSearchController.clear();
              _cubit.setTextSearch(false);
            },
          ),
        ),
      ],
    );
  }

  AppBar _defaultAppBar(StatesEventPage state) {
    return AppBar(
      title: Center(
        child: Text(widget.title),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _searchFocusNode.requestFocus();
            _cubit.setTextSearch(
              !_cubit.state.isSearch,
            );
            textSearchController.addListener(
              () {
                _cubit.setEventsList(state.eventList);
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _eventPageBody(StatesEventPage state) {
    return Stack(
      children: <Widget>[
        Column(
          children: [
            Expanded(
              child: _listView(state),
            ),
            if (state.isEditingPhoto)
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: _choiceImageSourceWrap,
              ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black26,
                  ),
                ),
              ),
              child: _textFieldArea,
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
                  padding: EdgeInsets.all(
                    5.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        70.0,
                      ),
                    ),
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
                  _cubit.setData(
                    DateFormat.yMMMd().format(date),
                  );
                  if (time != null) {
                    _cubit.setTime(
                      time.format(context),
                    );
                  }
                }
              },
            ),
          ),
      ],
    );
  }

  Wrap get _choiceImageSourceWrap {
    return Wrap(
      spacing: 25,
      alignment: WrapAlignment.spaceAround,
      children: [
        _widgetForImagePick(
          ListTile(
            leading: Icon(
              Icons.add_a_photo_outlined,
              color: Colors.white,
            ),
            title: Text(
              'Open Camera',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ImageSource.camera,
        ),
        _widgetForImagePick(
          ListTile(
            leading: Icon(
              Icons.photo,
              color: Colors.white,
            ),
            title: Text(
              'Open Gallery',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ImageSource.gallery,
        ),
      ],
    );
  }

  Widget _widgetForImagePick(ListTile listTile, ImageSource imageSource) {
    return GestureDetector(
      child: Container(
        width: 160,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(80)),
          color: Theme.of(context).primaryColor,
        ),
        child: listTile,
      ),
      onTap: () async {
        final image = await ImagePicker().getImage(source: imageSource);
        if (image != null) {
          _cubit.addImageEventFromResource(File(image.path));
        }
      },
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
        Text(
          state.date == null ? 'Calendar' : '${state.date},' '${state.time}',
        ),
        if (state.date != null)
          GestureDetector(
            child: Icon(
              Icons.clear,
              color: Colors.white,
              size: 18,
            ),
            onTap: () {
              _cubit.setData(DateFormat.yMMMd().format(DateTime.now()));
              _cubit.setTime(DateFormat.jm().format(DateTime.now()));
            },
          ),
      ],
    );
  }

  Row get _textFieldArea {
    return Row(
      children: <Widget>[
        IconButton(
          icon: _cubit.state.indexOfSelectedCircleAvatar == null
              ? CircleAvatar(
                  child: Icon(Icons.category),
                )
              : CircleAvatar(
                  child: listIcons[_cubit.state.indexOfSelectedCircleAvatar],
                ),
          iconSize: 32,
          onPressed: () => _showBottomSheetIcons(context),
        ),
        Expanded(
          child: TextField(
            controller: textController,
            focusNode: _focusNode,
            onChanged: (value) {
              value.isNotEmpty
                  ? _cubit.setWriting(true)
                  : _cubit.setWriting(false);
            },
            decoration: InputDecoration(
              hintText: 'Enter event',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        _cubit.state.isWriting
            ? IconButton(
                icon: Icon(Icons.send),
                iconSize: 32,
                color: Colors.blueGrey,
                onPressed: () {
                  if (_cubit.state.isEditing) {
                    _cubit.editText(
                        _cubit.state.selectedElement,
                        textController,
                        _cubit.state.indexOfSelectedCircleAvatar);
                  } else {
                    _cubit.sendEvent(textController);
                    _cubit.removeSelectedCircleAvatar();
                  }
                },
              )
            : IconButton(
                icon: Icon(Icons.photo),
                onPressed: () =>
                    _cubit.setEditingPhotoState(!_cubit.state.isEditingPhoto),
              ),
      ],
    );
  }

  ListView _listView(StatesEventPage state) {
    final _myEventList = state.isSearch
        ? state.eventList
            .where(
                (element) => element.text.contains(textSearchController.text))
            .toList()
        : state.eventList;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: _myEventList.length,
      itemBuilder: (context, index) {
        return _showEventList(_myEventList[index], index, state);
      },
    );
  }

  Widget _showEventList(Event event, int index, StatesEventPage state) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: Column(
        children: [
          ListTile(
            title: SharedPreferencesProvider().fetchCenterDateBubble()
                ? Center(
                    child: Text(_cubit.state.eventList[index].date),
                  )
                : Text(
                    _cubit.state.eventList[index].date,
                  ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Align(
              alignment: state.isBubbleAlignment
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: Container(
                width: 230,
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    leading: event.indexOfCircleAvatar != null
                        ? CircleAvatar(
                            child: listIcons[event.indexOfCircleAvatar],
                          )
                        : null,
                    title: _cubit.state.eventList[index].imagePath != null
                        ? Image.file(
                            File(_cubit.state.eventList[index].imagePath),
                          )
                        : Text(
                            event.text,
                          ),
                    subtitle: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(event.time),
                    ),
                    onLongPress: () {
                      _cubit.setIndexOfSelectedElement(event);
                      _showBottomSheet(context, event, index);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Event event, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: event.imagePath == null ? 280 : 120,
          child: _buildBottomNavigationMenu(index, event),
        );
      },
    );
  }

  void _showBottomSheetIcons(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 70,
          child: Row(
            children: [
              IconButton(
                icon: CircleAvatar(
                  child: Icon(Icons.clear),
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  _cubit.removeSelectedCircleAvatar();
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listIcons.length,
                  itemBuilder: (context, index) => _iconButton(index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconButton _iconButton(var index) {
    return IconButton(
      icon: CircleAvatar(
        child: listIcons[index],
      ),
      onPressed: () {
        _cubit.setIndexOfSelectedCircleAvatar(index);
        Navigator.pop(context);
      },
    );
  }

  Column _buildBottomNavigationMenu(int index, Event event) {
    return Column(
      children: <Widget>[
        if (event.imagePath == null)
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Colors.blue,
            ),
            title: Text('Edit'),
            onTap: () {
              _cubit.editEvent(event, textController);
              Navigator.pop(context);
            },
          ),
        ListTile(
          leading: Icon(
            Icons.reply,
            color: Colors.grey,
          ),
          title: Text('Send'),
          onTap: () {
            Navigator.pop(context);
            _showRadioList(index, event);
          },
        ),
        if (event.imagePath == null)
          ListTile(
            leading: Icon(
              Icons.copy,
              color: Colors.orange,
            ),
            title: Text('Copy'),
            onTap: () {
              _copyEvent(index);
              Navigator.pop(context);
            },
          ),
        if (event.imagePath == null)
          ListTile(
            leading: Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.green,
            ),
            title: Text('Important'),
            onTap: () {
              _importantEvent(index);
              Navigator.pop(context);
            },
          ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          title: Text('Delete'),
          onTap: () {
            _cubit.deleteEvent(event);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _showRadioList(int index, Event event) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder(
          cubit: _cubit,
          builder: (context, state) {
            return AlertDialog(
              title: Text('Choose the page'),
              content: _dialogColumn(index),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    _cubit.transferEvent(event, noteList);
                    _cubit.deleteEvent(event);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Padding _dialogColumn(var index) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          return RadioListTile(
            title: Text(noteList[index].eventName),
            value: index,
            activeColor: Theme.of(context).accentColor,
            groupValue: _cubit.state.selectedIndex,
            onChanged: (value) => _cubit.setSelectedIndex(value),
          );
        },
      ),
    );
  }

  void _importantEvent(int index) {
    _note.subTittleEvent = _cubit.state.eventList[index].text;
  }

  void _copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: _cubit.state.eventList[index].text));
  }
}
