import 'dart:io';
import 'dart:ui' as ui;

import 'package:chat_journal/models/note_model.dart';
import 'package:chat_journal/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import 'event_page_cubit.dart';

class EventPage extends StatefulWidget {
  final String? title;
  final Note? note;
  final List<Note>? noteList;

  EventPage({
    Key? key,
    this.title,
    this.note,
    this.noteList,
  }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(note!, noteList!);
}

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  final Note _note;
  final List<Note> _noteList;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventCubit>(context).init(_note);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: state.eventSelected!
              ? _appBarMenu(state.selectedElement!, state)
              : _defaultAppBar(state),
          body: _eventPageBody(state),
        );
      },
    );
  }

  _EventPageState(this._note, this._noteList);

  AppBar _defaultAppBar(EventsState state) {
    return AppBar(
      leading: _iconButtonBack(state),
      title: state.isIconButtonSearchPressed!
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
                hintStyle: TextStyle(color: Colors.white70),
              ),
            )
          : Text(widget.title!),
      actions: [
        state.isWriting!
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  BlocProvider.of<EventCubit>(context).setWritingState(false);
                  _searchTextController.clear();
                },
              )
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _searchTextFieldFocusNode.requestFocus();
                  BlocProvider.of<EventCubit>(context)
                      .setIconButtonSearchPressedState(
                    !state.isIconButtonSearchPressed!,
                  );
                },
              ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () => BlocProvider.of<EventCubit>(context)
              .setAllBookmarkState(!state.isAllBookmarked!),
        ),
      ],
    );
  }

  IconButton _iconButtonBack(EventsState state) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        if (state.isIconButtonSearchPressed!) {
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
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Expanded(
              child: _directionality(state),
            ),
            if (state.isEditingPhoto!)
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
      ],
    );
  }

  Directionality _directionality(EventsState state) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
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
        final image = await ImagePicker().pickImage(source: imageSource);
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
                DateFormat.yMMMd().format(DateTime.now()),
              );
              BlocProvider.of<EventCubit>(context).setHourTime(
                DateFormat.jm().format(DateTime.now()),
              );
            },
          ),
      ],
    );
  }

  ListView _listView(EventsState state) {
    final _searchedEventList = state.isIconButtonSearchPressed!
        ? state.eventList!
            .where(
                (element) => element.text.contains(_searchTextController.text))
            .toList()
        : state.eventList;
    final _allBookmarkedList = state.isAllBookmarked!
        ? _searchedEventList!.where((element) => element.isBookmarked).toList()
        : _searchedEventList;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: state.isAllBookmarked!
          ? _allBookmarkedList!.length
          : _searchedEventList!.length,
      itemBuilder: (context, index) {
        final _event = state.isAllBookmarked!
            ? _allBookmarkedList![index]
            : _searchedEventList![index];
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
                  child: Icon(iconsList[state.indexOfCircleAvatar!]),
                ),
          iconSize: 25,
          onPressed: () {
            BlocProvider.of<EventCubit>(context)
                .setIndexOfCircleAvatar(state.note!.indexOfCircleAvatar);
            _showHorizontalListView(context);
          },
        ),
        Expanded(
          child: TextField(
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
      itemCount: iconsList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            width: 100,
            child: CircleAvatar(
              child: Icon(iconsList[index]),
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
    return state.isWritingBottomTextField!
        ? IconButton(
            icon: Icon(Icons.send),
            iconSize: 29,
            onPressed: () {
              if (state.isEditing!) {
                BlocProvider.of<EventCubit>(context).editText(
                  state.selectedElement!,
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
                .setEditingPhotoState(!state.isEditingPhoto!),
          );
  }

  void _appBarChange(EventsState state) => BlocProvider.of<EventCubit>(context)
      .setEventSelectedState(!state.eventSelected!);

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
    state.eventList!.isEmpty
        ? _noteList[state.selectedTile!].subTitleEvent = 'Add event'
        : _noteList[state.selectedTile!].subTitleEvent =
            state.eventList![0].text;
  }

  Widget _showDialogEventList(int index, EventsState state) {
    return RadioListTile(
      title: Text(
        _noteList[index].noteName,
      ),
      value: index,
      groupValue: state.selectedTile,
      onChanged: (value) =>
          BlocProvider.of<EventCubit>(context).setIndexOfSelectedTile(value as int),
    );
  }

  void _copyEvent(Event event) =>
      Clipboard.setData(ClipboardData(text: event.text));
}

class EventListWidget extends StatefulWidget {
  final Event event;
  final dynamic state;
  final Function(dynamic)? onDismissed;
  final Function(String)? onTap;
  final Function()? onLongPressed;
  @override
  _EventListWidgetState createState() => _EventListWidgetState();

  EventListWidget(
    this.event,
    this.state, {
    this.onDismissed,
    this.onTap,
    this.onLongPressed,
  });
}

class _EventListWidgetState extends State<EventListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: Column(
        children: [
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
                      padding: EdgeInsets.only(left: 15),
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
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onDismissed: widget.onDismissed,
                child: _eventListTile(widget.event),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventListTile(Event event) {
    return Container(
      color: event.isSelected ? Colors.grey : Theme.of(context).primaryColor,
      child: ListTile(
        leading: event.indexOfCircleAvatar != null
            ? CircleAvatar(child: Icon(iconsList[event.indexOfCircleAvatar!]))
            : null,
        title: event.imagePath != null && event.imagePath!.isNotEmpty
            ? Image.file(File(event.imagePath!))
            : Text(
                event.text,
                style: TextStyle(color: Colors.white),
              ),
        subtitle: Text(
          event.time,
          style: TextStyle(color: Colors.white54),
        ),
        trailing: event.isBookmarked ? Icon(Icons.bookmark) : null,
        onLongPress: widget.onLongPressed,
      ),
    );
  }

}
