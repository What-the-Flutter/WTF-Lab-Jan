import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../note_page/note.dart';
import 'event.dart';

class EventPage extends StatefulWidget {
  final String title;
  final Note note;

  EventPage({Key key, this.title, this.note}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(note);
}

class _EventPageState extends State<EventPage> {
  final Note note;
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final bool isEditingText = false;
  bool eventSelected = true;
  int indexOfSelectedElement = 0;
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eventSelected
          ? defaultAppBar
          : appBarMenu(indexOfSelectedElement),
      body: eventPageBody,
    );
  }

  _EventPageState(this.note);

  AppBar get defaultAppBar {
    return AppBar(
      title: Center(
        child: Text(widget.title),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget get eventPageBody {
    return Column(
      children: <Widget>[
        Expanded(
          child: _listView,
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black12,
                ),
              ),
            ),
            child: _row,
          ),
        ),
      ],
    );
  }

  ListView get _listView {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: note.eventList.length,
      itemBuilder: (context, index) {
        indexOfSelectedElement = index;
        final event = note.eventList[index];
        return showEventList(event, index);
      },
    );
  }

  Row get _row {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.camera_alt_outlined),
          iconSize: 30,
          onPressed: () {
            setState(() {});
          },
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Enter Event',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        IconButton(
          icon: Icon(Icons.send),
          iconSize: 30,
          onPressed: () {
            if (isEditing) {
              setState(() => editText(indexOfSelectedElement));
            } else {
              setState(sendEvent);
            }
          },
        ),
      ],
    );
  }

  Widget showEventList(Event event, int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      width: 100,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 3,
          color: Colors.lightGreenAccent,
          child: ListTile(
            title: Text(event.text),
            subtitle: Text(event.time),
            onLongPress: () {
              indexOfSelectedElement = index;
              appBarChange();
            },
          ),
        ),
      ),
    );
  }

  AppBar appBarMenu(int index, {int count}) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          appBarChange();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            appBarChange();
            editEvent(index);
          },
        ),
        IconButton(
          icon: Icon(Icons.copy),
          onPressed: () {
            appBarChange();
            copyEvent(index);
          },
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {
            appBarChange();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            appBarChange();
            deleteEvent(index);
          },
        ),
      ],
    );
  }

  void editText(int index) {
    note.eventList[index].text = textEditingController.text;
    textEditingController.clear();
    isEditing = false;
  }

  void sendEvent() {
    note.eventList.insert(
      0,
      Event(
        text: textEditingController.text,
        time: DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
        isSelected: false,
      ),
    );
    textEditingController.clear();
  }

  void appBarChange() {
    setState(
      () {
        eventSelected = !eventSelected;
      },
    );
  }

  void editEvent(int index) {
    setState(
      () {
        isEditing = true;
        textEditingController.text = note.eventList[index].text;
        focusNode.requestFocus();
      },
    );
  }

  void copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: note.eventList[index].text));
  }

  void deleteEvent(int index) {
    note.eventList.removeAt(index);
  }
}
