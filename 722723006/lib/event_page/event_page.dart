import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../icon_list.dart';
import '../note_page/note.dart';
import '../widget/event_list_widget.dart';
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

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  final Note _note;
  final List<Note> _noteList;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchTextFieldFocusNode = FocusNode();
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventCubit>(context).init(_note);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void didUpdateWidget(EventPage oldWidget) {
    if (oldWidget != widget) {
      _controller.reset();
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: state.eventSelected
              ? _appBarMenu(
                  state.selectedElement,
                  state,
                )
              : _defaultAppBar(state),
          body: state.backgroundImagePath.isNotEmpty
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

  _EventPageState(this._note, this._noteList);

  AppBar _defaultAppBar(EventsState state) {
    return AppBar(
      leading: _iconButtonBack(state),
      title: state.isIconButtonSearchPressed
          ? TextField(
              focusNode: _searchTextFieldFocusNode,
              controller: _searchTextController,
              onChanged: (value) => value.isEmpty
                  ? BlocProvider.of<EventCubit>(context).setWritingState(false)
                  : BlocProvider.of<EventCubit>(context).setWritingState(true),
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
                  BlocProvider.of<EventCubit>(context).setWritingState(false);
                  _searchTextController.clear();
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  _searchTextFieldFocusNode.requestFocus();
                  BlocProvider.of<EventCubit>(context)
                      .setIconButtonSearchPressedState(
                    !state.isIconButtonSearchPressed,
                  );
                },
              ),
        IconButton(
          icon: Icon(
            Icons.bookmark_border,
          ),
          onPressed: () => BlocProvider.of<EventCubit>(context)
              .setAllBookmarkState(!state.isAllBookmarked),
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
          BlocProvider.of<EventCubit>(context)
              .setIconButtonSearchPressedState(false);
          BlocProvider.of<EventCubit>(context).setWritingState(false);
          _searchTextController.clear();
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _eventPageBody(EventsState state) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animation,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: _directionality(state),
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
                        padding: EdgeInsets.only(
                            top: 5, left: 5, right: 3, bottom: 5),
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
                          date = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          BlocProvider.of<EventCubit>(context).setDateTime(
                              '${DateFormat.yMMMd().format(date)}');
                          BlocProvider.of<EventCubit>(context).setHourTime(
                            '${DateFormat.jm().format(date)}',
                          );
                        }
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
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
          BlocProvider.of<EventCubit>(context)
              .addImageEventFromResource(File(image.path));
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
          state.dateTime == null
              ? 'Calendar'
              : '${state.dateTime},' '${state.hourTime}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        if (state.dateTime != null &&
            state.dateTime != DateFormat.yMMMd().format(DateTime.now()))
          GestureDetector(
            child: Icon(
              Icons.clear,
              size: 18,
              color: Colors.white,
            ),
            onTap: () {
              BlocProvider.of<EventCubit>(context).setDateTime(
                DateFormat.yMMMd().format(
                  DateTime.now(),
                ),
              );
              BlocProvider.of<EventCubit>(context).setHourTime(
                DateFormat.jm().format(
                  DateTime.now(),
                ),
              );
            },
          ),
      ],
    );
  }

  ListView _listView(EventsState state) {
    final _searchedEventList = state.isIconButtonSearchPressed
        ? state.eventList
            .where(
                (element) => element.text.contains(_searchTextController.text))
            .toList()
        : state.eventList;
    final _allBookmarkedList = state.isAllBookmarked
        ? _searchedEventList.where((element) => element.isBookmarked).toList()
        : _searchedEventList;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: state.isAllBookmarked
          ? _allBookmarkedList.length
          : _searchedEventList.length,
      itemBuilder: (context, index) {
        final _event = state.isAllBookmarked
            ? _allBookmarkedList[index]
            : _searchedEventList[index];
        return EventListWidget(
          _event,
          state,
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              BlocProvider.of<EventCubit>(context).setSelectedElement(_event);
              BlocProvider.of<EventCubit>(context).setEditState(true);
              _textController.text = _event.text;
              _focusNode.requestFocus();
            } else {
              BlocProvider.of<EventCubit>(context).deleteEvent(_event);
            }
          },
          onTap: (text) {
            BlocProvider.of<EventCubit>(context)
                .setIconButtonSearchPressedState(true);
            BlocProvider.of<EventCubit>(context).setWritingState(true);
            _searchTextController.text = text;
          },
          onLongPressed: () {
            _appBarChange(state);
            BlocProvider.of<EventCubit>(context).setEventState(_event);
            BlocProvider.of<EventCubit>(context).setSelectedElement(_event);
          },
        );
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
            BlocProvider.of<EventCubit>(context)
                .setIndexOfCircleAvatar(state.note.indexOfCircleAvatar);
            _showHorizontalListView(context);
          },
        ),
        Expanded(
          child: HashTagTextField(
            decoratedStyle: TextStyle(
              color: Colors.yellow,
            ),
            controller: _textController,
            focusNode: _focusNode,
            onChanged: (value) {
              value.isEmpty
                  ? BlocProvider.of<EventCubit>(context)
                      .setWritingBottomTextFieldState(false)
                  : BlocProvider.of<EventCubit>(context)
                      .setWritingBottomTextFieldState(true);
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
            BlocProvider.of<EventCubit>(context).setIndexOfCircleAvatar(index);
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
              if (state.isEditing) {
                BlocProvider.of<EventCubit>(context).editText(
                  state.selectedElement,
                  _textController.text,
                );
              } else {
                BlocProvider.of<EventCubit>(context)
                    .sendEvent(_textController.text);
              }
              _textController.clear();
              BlocProvider.of<EventCubit>(context)
                  .setWritingBottomTextFieldState(false);
            },
          )
        : IconButton(
            icon: Icon(Icons.photo),
            iconSize: 29,
            onPressed: () => BlocProvider.of<EventCubit>(context)
                .setEditingPhotoState(!state.isEditingPhoto),
          );
  }

  void _appBarChange(EventsState state) {
    BlocProvider.of<EventCubit>(context)
        .setEventSelectedState(!state.eventSelected);
  }

  AppBar _appBarMenu(Event event, EventsState state) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          BlocProvider.of<EventCubit>(context).setEventState(event);
          _appBarChange(state);
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.reply),
          onPressed: () {
            BlocProvider.of<EventCubit>(context).setEventState(event);
            _appBarChange(state);
            _showDialogWindow(event);
          },
        ),
        if (event.imagePath == null)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              BlocProvider.of<EventCubit>(context).setEventState(event);
              _appBarChange(state);
              BlocProvider.of<EventCubit>(context).setEditState(true);
              _textController.text = event.text;
              _focusNode.requestFocus();
            },
          ),
        if (event.imagePath == null)
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              BlocProvider.of<EventCubit>(context).setEventState(event);
              _appBarChange(state);
              _copyEvent(event);
            },
          ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {
            BlocProvider.of<EventCubit>(context).setEventState(event);
            BlocProvider.of<EventCubit>(context).setBookmarkState(event);
            _appBarChange(state);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            BlocProvider.of<EventCubit>(context).setEventState(event);
            _appBarChange(state);
            BlocProvider.of<EventCubit>(context).deleteEvent(event);
          },
        ),
      ],
    );
  }

  void _showDialogWindow(Event event) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<EventCubit, EventsState>(
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
                            onPressed: () => Navigator.pop(context),
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
        BlocProvider.of<EventCubit>(context).transferEvent(event, _noteList);
        _updateSubTittle(state);
        BlocProvider.of<EventCubit>(context).deleteEvent(event);
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
      onChanged: (value) =>
          BlocProvider.of<EventCubit>(context).setIndexOfSelectedTile(value),
    );
  }

  void _copyEvent(Event event) {
    Clipboard.setData(ClipboardData(text: event.text));
  }
}
