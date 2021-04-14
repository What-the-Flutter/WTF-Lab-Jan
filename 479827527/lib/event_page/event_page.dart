import 'dart:io';
import 'dart:ui' as ui;

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';
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
  List<Event> _eventList;

  _EventPageState(this._note, this._noteList);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CubitEventPage>(context).init(_note);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitEventPage, StatesEventPage>(
      builder: (context, state) {
        return Scaffold(
          appBar: state.selectedItemIndex != -1
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
        onPressed: () =>
            BlocProvider.of<CubitEventPage>(context).setSelectedItemIndex(-1),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.reply,
          ),
          onPressed: () {
            _showReplyDialog(index);
            BlocProvider.of<CubitEventPage>(context).setSelectedItemIndex(-1);
          },
        ),
        if (state.currentEventsList[index].imagePath == null)
          IconButton(
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () {
              BlocProvider.of<CubitEventPage>(context).setTextEditState(true);
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
              _copyEvent(state, index);
              BlocProvider.of<CubitEventPage>(context).setSelectedItemIndex(-1);
            },
          ),
        if (state.currentEventsList[index].imagePath == null)
          IconButton(
            icon: Icon(
              Icons.bookmark_border,
            ),
            onPressed: () {
              BlocProvider.of<CubitEventPage>(context).updateBookmark(index);
              BlocProvider.of<CubitEventPage>(context).setSelectedItemIndex(-1);
            },
          ),
        IconButton(
          icon: Icon(
            Icons.delete,
          ),
          onPressed: () {
            BlocProvider.of<CubitEventPage>(context).deleteEvent(index);
            updateNoteSubtitle();
            BlocProvider.of<CubitEventPage>(context).updateNote();
            BlocProvider.of<CubitEventPage>(context).setSelectedItemIndex(-1);
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
            ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            right: 10.0,
          ),
          child: Row(
            children: [
              if (!state.isSearch)
                IconButton(
                  icon: Icon(
                    Icons.bookmark_border,
                  ),
                  onPressed: () => BlocProvider.of<CubitEventPage>(context)
                      .setSortedByBookmarksState(!state.isSortedByBookmarks),
                ),
              IconButton(
                icon: Icon(
                  state.isSearch ? Icons.clear : Icons.search,
                ),
                onPressed: () {
                  BlocProvider.of<CubitEventPage>(context)
                      .setTextSearchState(!state.isSearch);
                  _focusSearchNode.requestFocus();
                },
              ),
            ],
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
                padding: EdgeInsets.all(
                  10.0,
                ),
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
                  BlocProvider.of<CubitEventPage>(context).setSelectedDate(
                    DateFormat.yMMMd().format(date),
                  );
                  if (time != null) {
                    BlocProvider.of<CubitEventPage>(context).setSelectedTime(
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
        return BlocBuilder<CubitEventPage, StatesEventPage>(
          builder: (context, state) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
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
            horizontal: 5.0,
            vertical: 15.0,
          ),
          child: Text(
            'Choose the page to migrate event',
          ),
        ),
        Expanded(
          child: _dialogListView(state),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                bottom: 15.0,
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
                right: 10.0,
                bottom: 15.0,
                left: 180.0,
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
        BlocProvider.of<CubitEventPage>(context)
            .transferEvent(_noteList, index);
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
      onChanged: (value) => BlocProvider.of<CubitEventPage>(context)
          .setSelectedPageReplyIndex(value),
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
            left: 5.0,
            right: 5.0,
          ),
          child: Text(
            _calendarTitle(state),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        if (state.selectedDate != '')
          GestureDetector(
            child: Icon(
              Icons.clear,
              color: Colors.white,
              size: 18,
            ),
            onTap: () => BlocProvider.of<CubitEventPage>(context)
                .resetDateTimeModifications(),
          ),
      ],
    );
  }

  String _calendarTitle(StatesEventPage state) {
    if (state.selectedDate != '' && state.selectedTime != '') {
      return '${state.selectedDate} ${state.selectedTime}';
    } else if (state.selectedTime == '' && state.selectedDate != '') {
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
          Icons.add_a_photo,
          'Open camera',
          ImageSource.camera,
        ),
        _chooseImageResource(
          Icons.photo,
          'Open gallery',
          ImageSource.gallery,
        ),
      ],
    );
  }

  GestureDetector _chooseImageResource(
      IconData icon, String text, ImageSource imageSource) {
    return GestureDetector(
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              80.0,
            ),
          ),
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
          BlocProvider.of<CubitEventPage>(context).addImageEvent(
            File(image.path),
          );
          updateNoteSubtitle();
          BlocProvider.of<CubitEventPage>(context).updateNote();
        }
      },
    );
  }

  void _updateList(StatesEventPage state) {
    BlocProvider.of<CubitEventPage>(context).sortEventsByDate();
    if (state.isSortedByBookmarks) {
      _eventList = state.currentEventsList
          .where((element) => element.bookmarkIndex == 1)
          .toList();
    } else if (state.isSearch) {
      _eventList = state.currentEventsList
          .where(
            (element) => element.text.contains(_textSearchController.text),
          )
          .toList();
    } else {
      _eventList = state.currentEventsList;
    }
  }

  LiveList _listView(StatesEventPage state) {
    _updateList(state);
    return LiveList.options(
      options: LiveOptions(
        visibleFraction: 0.025,
      ),
      reverse: true,
      scrollDirection: Axis.vertical,
      itemCount: _eventList.length,
      itemBuilder: (context, index, animation) {
        final _event = _eventList[index];
        return FadeTransition(
          opacity: animation,
          child: _showEventList(state, _event, index),
        );
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
                width: 140,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      40.0,
                    ),
                  ),
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                child: Center(
                  child: ListTile(
                    title: Text(
                      event.date,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            child: Card(
              elevation: 3,
              child: AnimatedContainer(
                duration: Duration(
                  milliseconds: 200,
                ),
                color: state.selectedItemIndex == index
                    ? Colors.orangeAccent
                    : Theme.of(context).primaryColor,
                child: ListTile(
                  leading: event.circleAvatarIndex != -1
                      ? _circleAvatar(
                          icons[event.circleAvatarIndex],
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
                            fontSize:
                                Theme.of(context).textTheme.bodyText1.fontSize,
                          ),
                          decoratedStyle: TextStyle(
                            color: Colors.yellow,
                            fontSize:
                                Theme.of(context).textTheme.bodyText1.fontSize,
                          ),
                          onTap: (text) {
                            BlocProvider.of<CubitEventPage>(context)
                                .setTextSearchState(!state.isSearch);
                            _textSearchController.text = text;
                          },
                        ),
                  subtitle: Text(
                    event.time,
                    style: TextStyle(
                      color: Theme.of(context)
                          .floatingActionButtonTheme
                          .foregroundColor,
                    ),
                  ),
                  trailing: event.bookmarkIndex == 1
                      ? Icon(
                          Icons.bookmark_border,
                          size: 30,
                          color: Colors.white,
                        )
                      : null,
                  onLongPress: () {
                    BlocProvider.of<CubitEventPage>(context)
                        .setSelectedItemIndex(index);
                  },
                ),
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
          icon: state.selectedIconIndex != -1
              ? Icon(icons[state.selectedIconIndex])
              : Icon(Icons.category),
          iconSize: 30,
          color: Theme.of(context).appBarTheme.color,
          onPressed: () => _showBottomSheet(context),
        ),
        Expanded(
          child: HashTagTextField(
            controller: _textController,
            focusNode: _focusNode,
            onChanged: (value) {
              if (value.isNotEmpty) {
                BlocProvider.of<CubitEventPage>(context)
                    .setSendPhotoButtonState(false);
                BlocProvider.of<CubitEventPage>(context)
                    .setAddingPhotoState(false);
              } else {
                BlocProvider.of<CubitEventPage>(context)
                    .setSendPhotoButtonState(true);
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
              BlocProvider.of<CubitEventPage>(context)
                  .setAddingPhotoState(true);
            } else {
              state.isEditing
                  ? BlocProvider.of<CubitEventPage>(context)
                      .editText(state.selectedItemIndex, _textController.text)
                  : BlocProvider.of<CubitEventPage>(context)
                      .addEvent(_textController.text);
              _textController.clear();
              BlocProvider.of<CubitEventPage>(context).removeSelectedIcon();
              BlocProvider.of<CubitEventPage>(context)
                  .setSendPhotoButtonState(true);
              updateNoteSubtitle();
            }
          },
        ),
      ],
    );
  }

  void updateNoteSubtitle() {
    final state = BlocProvider.of<CubitEventPage>(context).state;
    if (state.currentEventsList.isNotEmpty) {
      if (state.currentEventsList[0].imagePath == null) {
        state.note.subtitle =
            '${state.currentEventsList[0].text}  ${state.currentEventsList[0].time}';
      } else {
        state.note.subtitle = 'Image';
      }
    } else {
      state.note.subtitle = 'No events. Click to create one';
    }
    BlocProvider.of<CubitEventPage>(context).updateNote();
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
        BlocProvider.of<CubitEventPage>(context).setSelectedIconIndex(index);
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
        ClipboardData(text: state.currentEventsList[index].text),
      );
}
