import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hashtagable/hashtagable.dart';
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

  @override
  void initState() {
    _cubit.initSettingsState();
    _cubit.initEventList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventsState>(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: state.eventSelected
              ? _defaultAppBar(state)
              : _appBarMenu(state.selectedElement, state),
          body: state.backgroundImagePath != ''
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(
                          state.backgroundImagePath,
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: _eventPageBody(state),
                )
              : _eventPageBody(state),
        );
      },
    );
  }

  _EventPageState(this._note, this._noteList) {
    _cubit = EventCubit(EventsState(_note));
  }

  AppBar _defaultAppBar(EventsState state) {
    return AppBar(
      leading: _iconButtonBack(state),
      title: state.isIconButtonSearchPressed
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
          : Text(
              widget.title,
            ),
      actions: [
        state.isWriting
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  _cubit.setWritingState(false);
                  searchTextController.clear();
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  _searchTextFieldFocusNode.requestFocus();
                  _cubit.setIconButtonSearchPressedState(
                    !state.isIconButtonSearchPressed,
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

  IconButton _iconButtonBack(EventsState state) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        if (state.isIconButtonSearchPressed) {
          _cubit.setIconButtonSearchPressedState(false);
          _cubit.setWritingState(false);
          searchTextController.clear();
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _eventPageBody(EventsState state) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Expanded(
              child: _directionality(state),
            ),
            if (state.isEditingPhoto)
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: _choiceImageSourceWrap,
              ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                  ),
                ),
              ),
              child: _textFieldArea(state),
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
                padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 5, left: 5, right: 3, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(70)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: _calendarRow(state),
                ),
              ),
              onTap: () async {
                var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(date),
                  );
                  if (time != null) {
                    date = DateTime(date.year, date.month, date.day, time.hour,
                        time.minute);
                    _cubit.setDateTime(
                      '${DateFormat.yMMMd().format(date)},'
                      '${DateFormat.Hm().format(date)}',
                    );
                  }
                }
              },
            ),
          ),
      ],
    );
  }

  Directionality _directionality(EventsState state) {
    return Directionality(
      textDirection:
          state.isBubbleAlignment ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: _listView(state),
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

  Row _calendarRow(EventsState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 18,
          color: Colors.white,
        ),
        Text(
          state.dateTime ?? 'Calendar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        if (state.dateTime != null)
          GestureDetector(
            child: Icon(
              Icons.clear,
              size: 18,
              color: Colors.white,
            ),
            onTap: () => _cubit.setDateTime(
              DateFormat.yMMMd().format(
                DateTime.now(),
              ),
            ),
          ),
      ],
    );
  }

  ListView _listView(EventsState state) {
    final _displayed = state.isIconButtonSearchPressed
        ? state.eventList
            .where(
                (element) => element.text.contains(searchTextController.text))
            .toList()
        : state.eventList;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: _displayed.length,
      itemBuilder: (context, index) {
        return _showEventList(_displayed[index], index, state);
      },
    );
  }

  Row _textFieldArea(EventsState state) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: state.indexOfCircleAvatar == null
              ? Icon(Icons.widgets_outlined)
              : CircleAvatar(
                  child: listOfIcons[state.indexOfCircleAvatar],
                ),
          iconSize: 25,
          onPressed: () {
            _cubit.setIndexOfCircleAvatar(state.note.indexOfCircleAvatar);
            _showHorizontalListView(context);
          },
        ),
        Expanded(
          child: HashTagTextField(
            decoratedStyle: TextStyle(
              color: Colors.yellow,
            ),
            controller: textController,
            focusNode: _focusNode,
            onChanged: (value) {
              value.isEmpty
                  ? _cubit.setWritingBottomTextFieldState(false)
                  : _cubit.setWritingBottomTextFieldState(true);
            },
            decoration: InputDecoration(
              hintText: 'Enter event',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        _sendButton(state),
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

  IconButton _sendButton(EventsState state) {
    return state.isWritingBottomTextField
        ? IconButton(
            icon: Icon(Icons.send),
            iconSize: 29,
            onPressed: () {
              state.isEditing
                  ? _cubit.editText(
                      state.selectedElement,
                      textController.text,
                    )
                  : _cubit.sendEvent(textController.text);
              textController.clear();
              _cubit.setWritingBottomTextFieldState(false);
            },
          )
        : IconButton(
            icon: Icon(Icons.photo),
            iconSize: 29,
            onPressed: () => _cubit.setEditingPhotoState(!state.isEditingPhoto),
          );
  }

  Widget _showEventList(Event event, int index, EventsState state) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: Column(
        children: [
          _dateListTile(event, state),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              elevation: 3,
              color: Theme.of(context).primaryColor,
              child: Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.green,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 15,
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    _cubit.setSelectedElement(event);
                    _cubit.setEditState(true);
                    textController.text = event.text;
                    _focusNode.requestFocus();
                  } else {
                    _cubit.deleteEvent(event);
                  }
                },
                child: _eventListTile(event, state),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateListTile(Event event, EventsState state) {
    return ListTile(
      title: state.isCenterDateBubble
          ? Center(
              child: Text(
                event.date,
              ),
            )
          : Text(
              event.date,
            ),
    );
  }

  Widget _eventListTile(Event event, EventsState state) {
    return ListTile(
      leading: event.indexOfCircleAvatar != null
          ? CircleAvatar(
              child: listOfIcons[event.indexOfCircleAvatar],
            )
          : null,
      title: event.imagePath != null
          ? Image.file(
              File(event.imagePath),
            )
          : HashTagText(
              text: event.text,
              basicStyle: TextStyle(
                color: Colors.white,
              ),
              decoratedStyle: TextStyle(
                color: Colors.yellow,
              ),
              onTap: (text) {
                _cubit.setIconButtonSearchPressedState(true);
                _cubit.setWritingState(true);
                searchTextController.text = text;
              },
            ),
      subtitle: Text(
        event.time,
        style: TextStyle(color: Colors.white54),
      ),
      onLongPress: () {
        _cubit.setSelectedElement(event);
        _appBarChange(state);
      },
    );
  }

  void _appBarChange(EventsState state) {
    _cubit.setEventSelectedState(!state.eventSelected);
  }

  AppBar _appBarMenu(Event event, EventsState state) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          _appBarChange(state);
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.reply),
          onPressed: () {
            _appBarChange(state);
            _showDialogWindow(event);
          },
        ),
        if (event.imagePath == null)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _appBarChange(state);
              _cubit.setEditState(true);
              textController.text = event.text;
              _focusNode.requestFocus();
            },
          ),
        if (event.imagePath == null)
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              _appBarChange(state);
              _copyEvent(event);
            },
          ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {
            _appBarChange(state);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _appBarChange(state);
            _cubit.deleteEvent(event);
          },
        ),
      ],
    );
  }

  void _showDialogWindow(Event event) {
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
                          return _showDialogEventList(index, state);
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
                          child: _confirmTransferButton(event, state),
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

  IconButton _confirmTransferButton(Event event, EventsState state) {
    return IconButton(
      icon: Icon(
        Icons.check,
        color: Colors.green[400],
      ),
      onPressed: () {
        _cubit.transferEvent(event, _noteList);
        _updateSubTittle(state);
        _cubit.deleteEvent(event);
        Navigator.pop(context);
      },
    );
  }

  void _updateSubTittle(EventsState state) {
    state.eventList.isEmpty
        ? _noteList[state.selectedTile].subTittleEvent = 'Add event'
        : _noteList[state.selectedTile].subTittleEvent =
            state.eventList[0].text;
  }

  Widget _showDialogEventList(int index, EventsState state) {
    return RadioListTile(
      title: Text(
        _noteList[index].noteName,
      ),
      value: index,
      groupValue: state.selectedTile,
      onChanged: (value) {
        _cubit.setIndexOfSelectedTile(value);
      },
    );
  }

  void _copyEvent(Event event) {
    Clipboard.setData(ClipboardData(text: event.text));
  }
}
