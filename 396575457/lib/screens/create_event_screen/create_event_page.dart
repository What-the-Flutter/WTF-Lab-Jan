import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../home_screen/home_page.dart';
import 'favorite_messages_list.dart';
import 'message.dart';
import 'messages_list.dart';
import 'messages_store.dart';

class EventPage extends StatefulWidget {
  final String eventTitle;
  final bool isEventSelected;
  final Message selectedMessage;
  final EventsStore data;

  EventPage({
    Key key,
    @required this.eventTitle,
    @required this.isEventSelected,
    @required this.selectedMessage,
    @required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventPageState(
        eventTitle,
        isEventSelected,
        selectedMessage,
        data,
      );
}

class _EventPageState extends State<EventPage> {
  final bool _isEventSelected;
  final String _eventTitle;
  EventsStore _data = EventsStore();
  Message selectedMessage;
  bool _isEventEdit = false;
  bool _isFavoriteMessagesButtonEnable = false;

  _EventPageState(
    this._eventTitle,
    this._isEventSelected,
    this.selectedMessage,
    data,
  ) {
    if (data != null) {
      _data = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEventSelected) {
      for (var i = 0; i < _data.size; i++) {
        if (_data.elementAt(i).isMessageEdit) {
          _isEventEdit = true;
        }
      }
    }

    final textController = TextEditingController();
    @override
    void dispose() {
      textController.dispose();
      super.dispose();
    }

    var _bottomNavigationBar = BottomAppBar(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          IconButton(
              icon: Icon(
                Icons.scatter_plot,
                color: Colors.white,
              ),
              onPressed: null),
          SizedBox(
            // todo: Ask about max width widget
            width: 263,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white70,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: textController,
                  decoration: InputDecoration(
                      hintText: 'Enter event',
                      hintStyle: TextStyle(color: Colors.black26)),
                ),
              ),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  var check = false;
                  for (var i = 0; i < _data.size; i++) {
                    if (_data.elementAt(i).isMessageEdit) {
                      _data.elementAt(i).sendNewMessage(textController.text);
                      _data.elementAt(i).editMessage(false);
                      check = true;
                    }
                  }
                  if (!check) {
                    _data.addMessage(textController.text);
                  }
                  textController.clear();
                });
              })
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _isEventSelected
          ? _drawAppBarForSelectedEvent(textController, _isEventEdit)
          : _drawDefaultAppBar(),
      body: _isFavoriteMessagesButtonEnable
          ? FavoriteMessagesList(_fetchFavoriteMessagesData(), _eventTitle)
          : MessagesList(_data, _eventTitle),
      bottomNavigationBar: _bottomNavigationBar,
    );
  }

  EventsStore _fetchFavoriteMessagesData() {
    var _favoriteMessageData = EventsStore();
    _favoriteMessageData.clear();
    for (var i = 0; i < _data.size; i++) {
      if (_data.elementAt(i).isMessageFavorite) {
        _favoriteMessageData.addAlreadyCreateMessage(_data.elementAt(i));
      }
    }
    return _favoriteMessageData;
  }

  AppBar _drawAppBarForSelectedEvent(
      TextEditingController textController, bool isEventEdit) {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.cancel,
            color: Colors.white,
          ),
          onPressed: () {
            clearUserActions();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(
                  eventTitle: _eventTitle,
                  isEventSelected: false,
                  selectedMessage: null,
                  data: _data,
                ),
              ),
            );
          }),
      actions: <Widget>[
        _drawCounter(),
        Padding(padding: EdgeInsets.only(right: 20)),
        IconButton(
            icon: Icon(
              Icons.reply,
              color: Colors.white,
            ),
            onPressed: null),
        if (!isEventEdit)
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                for (var i = 0; i < _data.size; i++) {
                  if (_data.elementAt(i).isMessageSelected) {
                    textController.text = _data.elementAt(i).message;
                    _data.elementAt(i).editMessage(true);
                  }
                }
              }),
        IconButton(
            icon: Icon(
              Icons.content_copy,
              color: Colors.white,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: selectedMessage.message));
            }),
        IconButton(
            icon: Icon(
              Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: () {
              // todo: make message favorite
              for (var i = 0; i < _data.size; i++) {
                if (_data.elementAt(i).isMessageSelected) {
                  _data.elementAt(i).favoriteMessage(true);
                  print(_data.elementAt(i).message);
                }
              }
            }),
        IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                var indexes = <int>[];
                for (var i = 0; i < _data.size; i++) {
                  if (_data.elementAt(i).isMessageSelected) {
                    indexes.add(i);
                  }
                }
                for (var i = 0; i < indexes.length; i++) {
                  _data.removeElementAt(indexes[i] - i);
                }
              });
            }),
      ],
    );
  }

  bool clearUserActions() {
    for (var i = 0; i < _data.size; i++) {
      if (_data.elementAt(i).isMessageSelected) {
        _data.elementAt(i).selectMessage(false);
        _data.elementAt(i).editMessage(false);
      }
    }
    return true;
  }

  Center _drawCounter() {
    var counter = 0;
    for (var i = 0; i < _data.size; i++) {
      if (_data.elementAt(i).isMessageSelected) {
        counter++;
      }
    }
    return Center(
      child: Text(
        '$counter',
        style: TextStyle(fontSize: 25),
      ),
    );
  }

  AppBar _drawDefaultAppBar() {
    return AppBar(
      title: Center(
        child: Text(_eventTitle),
      ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: null),
        IconButton(
            icon: Icon(
              Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isFavoriteMessagesButtonEnable =
                    !_isFavoriteMessagesButtonEnable;
              });
            })
      ],
    );
  }
}
