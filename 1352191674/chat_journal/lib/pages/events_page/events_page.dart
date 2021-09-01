import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../models/event_model.dart';
import 'event_bloc.dart';
import 'event_extras.dart';

class EventPage extends StatelessWidget {
  final _bloc = EventPageBloc();
  final String title;
  EventPage({required this.title});

  AppBar _appBar(BuildContext context, EventPageState state) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      actions: <Widget>[
        IconButton(
          onPressed: () => {_showSearch(context, state)},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () => {},
          icon: const Icon(Icons.bookmark),
        ),
        IconButton(
          onPressed: () => {_showSearchResult(context, state)},
          icon: const Icon(Icons.slideshow),
        ),
      ],
    );
  }

  Widget _eventBuilder(
      Event event, BuildContext context, EventPageState state) {
    return Container(
      margin: event.isFavorite
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: _decoration(event, context),
      child: GestureDetector(
        onLongPress: () => {
          _showPopupMenu(event, context, state),
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                Text(
                  DateFormat.yMd().add_jm().format(event.time).toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.0),
                event.image != null
                    ? Image.file(
                  event.image!,
                )
                    : Text(
                  event.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (event.icon != null)
                  CircleAvatar(
                    child: Icon(event.icon),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _decoration(Event event, BuildContext context) {
    return BoxDecoration(
      color: Colors.blueGrey,
      borderRadius: event.isFavorite
          ? BorderRadius.only(
          topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0))
          : BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0)),
    );
  }

  void _showPopupMenu(Event event, BuildContext context, EventPageState state) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.attach_file_outlined, color: Colors.green),
              title: Text('Like/Unlike Event'),
              onTap: () {
                //_likeEvent(event);
              },
            ),
            ListTile(
              leading: Icon(Icons.copy, color: Colors.yellow),
              title: Text('Copy Event'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: event.text));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit Event'),
              onTap: () {
                _bloc.myController.text = event.text;
                event.isEdit = true;
                Navigator.pop(context);
                _bloc.insert = true;
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.redAccent),
              title: Text('Delete Event'),
              onTap: () {
                _bloc.add(DeleteEventEvent(event, state.events));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.swap_horiz, color: Colors.deepOrange),
              title: Text('Swap Event'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return _migrateEventDialog(event, context);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _eventComposer(BuildContext context, EventPageState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.bubble_chart),
            onPressed: () {
              _showIconList(context, state);
            },
          ),
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Colors.white,
            onPressed: () {
              _getImage(ImageSource.gallery);
              state.image != null
                  ? state.events.insert(
                0,
                Event(
                    time: DateTime.now(),
                    text: '',
                    isFavorite: false,
                    isEdit: false,
                    image: state.image,
                    icon: state.icon),
              )
                  : state.image = null;
              state.image = null;
            },
          ),
          Expanded(
            child: TextField(
              style: TextStyle(backgroundColor: Theme.of(context).primaryColor),
              controller: _bloc.myController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Create a event',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Colors.white,
            onPressed: () {
              _createNewEventOrEdit(state, context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _getImage(ImageSource imageSource) async {
    var imageFile = await _bloc.picker.pickImage(source: imageSource);
    if (imageFile == null) return;
    _bloc.add(
      EventImageEvent(File(imageFile.path)),
    );
  }

  dynamic _createNewEventOrEdit(EventPageState state, BuildContext context) {
    if (_bloc.insert) {
      var index = 0;
      for (var event in state.events) {
        if (event.isEdit) {
          _bloc.add(EditEventEvent(
              event, state.events, _bloc.myController.text, index));
          _bloc.insert = false;
          _bloc.myController.text = '';
        }
        index++;
      }
    } else {
      var event = Event(
          time: DateTime.now(),
          text: _bloc.myController.text,
          isFavorite: false,
          isEdit: false,
          image: null,
          icon: state.icon);
      _bloc.add(AddEventEvent(event, state.events));
      _bloc.myController.text = '';
      state.icon = null;
    }
  }

  Widget _searchPage(BuildContext context, EventPageState state) {
    return AlertDialog(
      title: Text(
        'Search',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: _bloc.myController,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {},
        decoration: InputDecoration.collapsed(
          hintText: 'Search an event',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            for (var event in state.events) {
              if (event.text.contains(_bloc.myController.text)) {
                _bloc.add(SearchEventEvent(event, state.searchEvents));
              }
            }
          },
          child: Text('Search'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _bloc.myController.text = '';
          },
          child: Text('OK'),
        )
      ],
    );
  }

  void _showSearch(BuildContext context, EventPageState state) {
    showDialog(
      context: context,
      builder: (context) {
        return _searchPage(context, state);
      },
    );
  }

  void _showSearchResult(BuildContext context, EventPageState state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: ListView.builder(
            itemCount: state.searchEvents.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                title: Text(state.searchEvents[index].text),
              );
            },
          ),
        );
      },
    );
  }

  void _showIconList(BuildContext context, EventPageState state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          content: GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundColor: state.currentIconIndex == index
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor,
                  radius: 28,
                  child:
                  Icon(categoryList[index], size: 35, color: Colors.white),
                ),
                onPressed: () {
                  _bloc.add(AddIconEvent(categoryList[index]));
                  Navigator.pop(context);
                },
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 7.0,
            ),
          ),
        );
      },
    );
  }

  Dialog _migrateEventDialog(Event event, BuildContext dialogContext) {
    return Dialog(
      elevation: 16,
      child: Container(
        height: 300,
        width: 220,
        child: ListView.separated(
          itemCount: categoryList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Center(
                child: Text(
                  'Select the page you want to migrate the selected event to!',
                ),
              );
            }
            return ListTile(
              leading: Icon(categoryList[index - 1]),
              onTap: () {},
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventPageBloc,EventPageState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(context, state),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: state.events.length,
                    itemBuilder: (context, index) {
                      final event = state.events[index];
                      return _eventBuilder(event, context, state);
                    },
                  ),
                ),
              ),
              _eventComposer(context, state),
            ],
          ),
        );
      },
    );
  }

}

final categoryList = <IconData>[
  Icons.book,
  Icons.import_contacts_outlined,
  Icons.nature_people_outlined,
  Icons.info,
  Icons.mail,
  Icons.ac_unit,
  Icons.access_time,
  Icons.camera_alt,
  Icons.hail,
  Icons.all_inbox,
];
