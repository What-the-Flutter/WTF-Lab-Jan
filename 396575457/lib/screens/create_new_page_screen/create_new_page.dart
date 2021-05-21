import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../create_event_screen/messages_store.dart';
import '../home_screen/event.dart';
import 'list_icons.dart';

typedef VoidCallBack = void Function(Event);

class CreateNewPage extends StatefulWidget {
  @override
  _CreateNewPageState createState() => _CreateNewPageState();

  final VoidCallBack _callback;

  CreateNewPage(this._callback);
}

class _CreateNewPageState extends State<CreateNewPage> {
  final _textController = TextEditingController();
  bool _isIconChosen = false;
  int _chosenIconIndex;

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      _textController.dispose();
      super.dispose();
    }

    var floatingActionButton = FloatingActionButton(
      onPressed: () {
        var newEvent = Event(
          title: _textController.text,
          avatar: _circleAvatar(
            listIcons[_chosenIconIndex ?? 0],
          ),
          messages: EventsStore(),
        );
        widget._callback(newEvent);
        Navigator.pop(context);
      },
      child: Icon(
        Icons.check,
        color: Colors.black,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.only(left: 10),
              color: Theme.of(context).primaryColor,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Name of the page',
                  hintStyle: TextStyle(color: Colors.white60),
                ),
              ),
            ),
          ),
          _iconGrid,
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  GridView get _iconGrid {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listIcons.length,
      itemBuilder: (context, index) {
        return IconButton(
          icon: index != _chosenIconIndex
              ? _circleAvatar(listIcons[index],
                  color: Theme.of(context).primaryColor)
              : _circleAvatar(listIcons[index], color: Colors.green),
          onPressed: () {
            _changeChosen();
            setState(
              () {
                _chosenIconIndex = index;
              },
            );
          },
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),
    );
  }

  CircleAvatar _circleAvatar(Icon icon, {color}) {
    return CircleAvatar(
      child: icon,
      backgroundColor: Color != null ? color : Colors.white,
    );
  }

  bool _changeChosen() {
    _isIconChosen = !_isIconChosen;
    return true;
  }
}
