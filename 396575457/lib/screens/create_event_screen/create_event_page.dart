import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../home_screen/event.dart';
import 'message.dart';
import 'messages_store.dart';

class EventPage extends StatefulWidget {
  final String eventTitle;
  final bool isEventSelected;
  final Message selectedMessage;
  final Event dataEvent;

  EventPage({
    Key key,
    @required this.eventTitle,
    @required this.isEventSelected,
    @required this.selectedMessage,
    @required this.dataEvent,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _isEventSelected;
  String _eventTitle;
  Event _dataEvent;
  EventsStore _data;
  Message _selectedMessage;
  bool _isEventEdit = false;
  bool _isFavoriteMessagesButtonEnable = false;
  final _textController = TextEditingController();

  @override
  void initState() {
    _dataEvent = widget.dataEvent;
    _data = _dataEvent.messagesData;
    _isEventSelected = false;
    for (var i = 0; i < _data.size; i++) {
      if (_data.elementAt(i).isMessageSelected) {
        _isEventSelected = true;
      }
    }
    _eventTitle = widget.eventTitle;
    _selectedMessage = widget.selectedMessage;

    super.initState();
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

    @override
    void dispose() {
      _textController.dispose();
      super.dispose();
    }

    var _bottomWidget = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.scatter_plot,
                color: Colors.white,
              ),
              onPressed: null,
            ),
            SizedBox(
              width: 263,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white70,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter event',
                      hintStyle: TextStyle(color: Colors.black26),
                    ),
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
                setState(
                  () {
                    var check = false;
                    for (var i = 0; i < _data.size; i++) {
                      if (_data.elementAt(i).isMessageEdit) {
                        _data.elementAt(i).sendNewMessage(_textController.text);
                        _data.elementAt(i).editMessage(false);
                        check = true;
                      }
                    }
                    if (!check) {
                      _data.addMessage(_textController.text);
                    }
                    _textController.clear();
                  },
                );
              },
            )
          ],
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _isEventSelected
          ? _appBarForSelectedEvent(_textController, _isEventEdit)
          : _defaultAppBar(),
      body: Stack(
        children: [
          _isFavoriteMessagesButtonEnable
              ? _messagesList(_fetchFavoriteMessagesData())
              : _messagesList(_data),
          _bottomWidget,
        ],
      ),
    );
  }

  Container _messagesList(_listData) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: _listData.size,
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.only(
              left: 7,
              right: 7,
            ),
            child: RaisedButton(
              color: _listData.elementAt(i).isMessageSelected
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: () => setState(
                () => _listData.elementAt(i).inverseChosen(),
              ),
              onLongPress: () => setState(
                () {
                  _listData.elementAt(i).inverseSelected();
                  _isEventSelected = _listData.elementAt(i).isMessageSelected;
                },
              ),
              child: Row(
                children: [
                  Text(
                    _listData.eventsList[i].message,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  _listData.eventsList[i].isMessageFavorite
                      ? Icon(
                          Icons.bookmark,
                          size: 15,
                          color: Colors.orange,
                        )
                      : SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
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

  AppBar _appBarForSelectedEvent(
      TextEditingController textController, bool isEventEdit) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.cancel,
          color: Colors.white,
        ),
        onPressed: () {
          _clearUserActions();
          setState(
            () {
              _isEventSelected = false;
              _selectedMessage = null;
            },
          );
        },
      ),
      actions: <Widget>[
        _counter(),
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
            },
          ),
        IconButton(
          icon: Icon(
            Icons.content_copy,
            color: Colors.white,
          ),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: _selectedMessage.message));
          },
        ),
        IconButton(
          icon: Icon(
            Icons.bookmark_border,
            color: Colors.white,
          ),
          onPressed: () {
            setState(
              () {
                for (var i = 0; i < _data.size; i++) {
                  if (_data.elementAt(i).isMessageSelected) {
                    _data.elementAt(i).inverseChosen();
                  }
                }
              },
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
            setState(
              () {
                var indexes = <int>[];
                for (var i = 0; i < _data.size; i++) {
                  _isEventSelected = false;
                  if (_data.elementAt(i).isMessageSelected) {
                    indexes.add(i);
                    _isEventSelected = true;
                  }
                }
                for (var i = 0; i < indexes.length; i++) {
                  _data.removeElementAt(indexes[i] - i);
                }
                if (_data.size == 0) {
                  _isEventSelected = false;
                }
              },
            );
          },
        ),
      ],
    );
  }

  bool _clearUserActions() {
    for (var i = 0; i < _data.size; i++) {
      if (_data.elementAt(i).isMessageSelected) {
        _data.elementAt(i).selectMessage(false);
        _data.elementAt(i).editMessage(false);
      }
    }
    return true;
  }

  Center _counter() {
    var counter = 0;
    for (var i = 0; i < _data.size; i++) {
      if (_data.elementAt(i).isMessageSelected) {
        counter++;
      }
    }
    if (counter == 0 && !_isEventSelected) {
      setState(
        () {
          _isEventSelected = false;
        },
      );
    }
    return Center(
      child: Text(
        '$counter',
        style: TextStyle(fontSize: 25),
      ),
    );
  }

  AppBar _defaultAppBar() {
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
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(
            _isFavoriteMessagesButtonEnable
                ? Icons.bookmark
                : Icons.bookmark_border,
            color: Colors.white,
          ),
          onPressed: () {
            setState(
              () {
                _isFavoriteMessagesButtonEnable =
                    !_isFavoriteMessagesButtonEnable;
              },
            );
          },
        )
      ],
    );
  }
}
