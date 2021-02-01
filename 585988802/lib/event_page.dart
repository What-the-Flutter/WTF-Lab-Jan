import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_app/event_message.dart';
import 'package:intl/intl.dart';

List<EventMessage> eventMessagesList = [
  EventMessage('Family', DateFormat.yMMMd().add_jm().format(new DateTime.now()),
      'Visit relatives', false),
  EventMessage('Family', DateFormat.yMMMd().add_jm().format(new DateTime.now()),
      'Call grandmothers', true),
  EventMessage('Family', DateFormat.yMMMd().add_jm().format(new DateTime.now()),
      'Eat everyone in a good mood', false),
  EventMessage('Food', DateFormat.yMMMd().add_jm().format(new DateTime.now()),
      'dine for 15\$', false),
  EventMessage('Food', DateFormat.yMMMd().add_jm().format(new DateTime.now()),
      'buy food for dinner', false),
  EventMessage('Sport', DateFormat.yMMMd().add_jm().format(new DateTime.now()),
      'Football practice at 19 PM', true),
  EventMessage('Sport', DateFormat.yMMMd().add_jm().format(new DateTime.now()),
      'Swim 4 km', false),
  EventMessage('Sport', DateFormat.yMMMd().add_jm().format(new DateTime.now()),
      'bicycle 30 km', true),
  EventMessage('Travel', DateFormat.yMMMd().add_jm().format(new DateTime.now()),
      'Book a hotel in munich', true),
];

class EventPage extends StatefulWidget {
  final String title;

  EventPage({Key key, this.title}) : super(key: key);

  @override
  _EventPage createState() => _EventPage();
}

class _EventPage extends State<EventPage> {
  TextEditingController _textEditingController = TextEditingController();
  bool isWriting = false;
  bool isFavoriteButPressed = false;
  EventMessage _bottomSheetEventMessage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildAppBarEventPage(),
      body: _buildEventPageBody(),
    );
  }

  Widget _buildEventPageBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                child: _buildEventMessageListView(),
              ),
            ),
          ),
          _buildEventMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildEventMessageListView() {
    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.only(top: 15.0),
      itemCount: eventMessagesList.length,
      itemBuilder: (context, index) {
        EventMessage eventMessage = eventMessagesList[index];
        return _buildEventAndFavoriteMessage(eventMessage);
      },
    );
  }

  Widget _buildEventAndFavoriteMessage(EventMessage eventMessage) {
    if (widget.title == eventMessage.nameOfSuggestion &&
        eventMessage.isFavorite &&
        isFavoriteButPressed) {
      return _buildEventMessage(eventMessage);
    } else {
      if (widget.title == eventMessage.nameOfSuggestion &&
          !isFavoriteButPressed) {
        return _buildEventMessage(eventMessage);
      } else {
        return Container();
      }
    }
  }

  void _setIsWriting(bool isWriting) {
    setState(() {
      this.isWriting = isWriting;
    });
  }

  Widget _buildEventMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: 70.0,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            iconSize: 25.0,
            color: Colors.white,
            onPressed: () {},
          ),
          _buildInpEventMessageTextField(),
          isWriting
              ? IconButton(
                  icon: Icon(Icons.send),
                  iconSize: 25.0,
                  color: Colors.white,
                  onPressed: () {
                    _sendIconPressed();
                  },
                )
              : IconButton(
                  icon: Icon(Icons.photo),
                  iconSize: 25.0,
                  color: Colors.white,
                  onPressed: () {},
                ),
        ],
      ),
    );
  }

  void _sendIconPressed() {
    eventMessagesList.insert(
        0,
        EventMessage(
            widget.title,
            DateFormat.yMMMd().add_jm().format(new DateTime.now()),
            _textEditingController.text,
            false),
    );
    _textEditingController.clear();
    _setIsWriting(false);
  }

  Widget _buildInpEventMessageTextField() {
    return Expanded(
      child: TextField(
        controller: _textEditingController,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {
          (value.length > 0 && value.trim() != "")
              ? _setIsWriting(true)
              : _setIsWriting(false);
        },
        decoration: InputDecoration(
          hintText: 'Enter event',
          hintStyle: TextStyle(
            color: Colors.white70,
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(25.0),
            ),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          filled: true,
          fillColor: Colors.white38,
        ),
      ),
    );
  }

  Widget _buildEventMessage(EventMessage eventMessage) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          return _buildBottomSheet(context, eventMessage);
        });
      },
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 10.0,
            ),
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Color(0xFFFFEFEE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventMessage.time,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  eventMessage.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: eventMessage.isFavorite
                ? Icon(
                    Icons.bookmark,
                    color: Colors.orangeAccent,
                  )
                : Icon(Icons.bookmark_border_outlined),
            onPressed: () {
              setState(() {
                eventMessage.isFavorite = !eventMessage.isFavorite;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarEventPage() {
    return AppBar(
      title: Container(
        child: Text(widget.title),
        alignment: Alignment.centerLeft,
      ),
      elevation: 0.0,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: isFavoriteButPressed
              ? Icon(
                  Icons.bookmark_border_outlined,
                  color: Colors.orangeAccent,
                )
              : Icon(
                  Icons.bookmark_border_outlined,
                ),
          onPressed: () {
            setState(() {
              isFavoriteButPressed = !isFavoriteButPressed;
            });
          },
        ),
      ],
    );
  }

  _buildBottomSheet(BuildContext context, EventMessage eventMessage) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 90, 90, 1),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.0),
                topLeft: Radius.circular(25.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildListTile(
                  context,
                  'Forward',
                  Icons.arrow_back_outlined,
                  _forwardEventMessage,
                  eventMessage,
                ),
                _buildListTile(
                  context,
                  'Copy',
                  Icons.copy,
                  _copyEventMessage,
                  eventMessage,
                ),
                _buildListTile(
                  context,
                  'Edit',
                  Icons.edit,
                  _editEventMessage,
                  eventMessage,
                ),
                _buildListTile(
                  context,
                  'Add to favorites',
                  Icons.bookmark_border_outlined,
                  _addToFavorites,
                  eventMessage,
                ),
                _buildListTile(
                  context,
                  'Delete',
                  Icons.delete,
                  _deleteEventMessage,
                  eventMessage,
                ),
              ],
            ),
          );
        });
  }

  ListTile _buildListTile(BuildContext context, String name, IconData icon,
      Function action, EventMessage eventMessage) {
    _bottomSheetEventMessage = eventMessage;
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        name,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  _forwardEventMessage() {
    setState(() {
      //will be implemented
      print('forwardEventMessage');
    });
  }

  _copyEventMessage() {
    setState(() {
      Clipboard.setData(new ClipboardData(text: _bottomSheetEventMessage.text));
    });
  }

  _editEventMessage() {
    setState(() {
      _textEditingController.text;
      print('editEventMessage');
    });
  }

  _addToFavorites() {
    setState(() {
      _bottomSheetEventMessage.isFavorite =
          !_bottomSheetEventMessage.isFavorite;
    });
  }

  _deleteEventMessage() {
    setState(() {
      eventMessagesList.remove(_bottomSheetEventMessage);
    });
  }
}
