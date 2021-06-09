import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';

class Chat extends StatefulWidget {
  final Category category;

  const Chat({Key? key, required this.category}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Chat(category);
}

class _Chat extends State<Chat> {
  final Category category;
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final bool isEditingText = false;
  bool eventSelected = true;
  int indexOfSelectedElement = 0;
  bool isEditing = false;

  _Chat(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          eventSelected ? baseAppBar : selectItemAppBar(indexOfSelectedElement),
      body: chatBody,
    );
  }

  AppBar get baseAppBar {
    return AppBar(
      title: Center(
        child: Text(category.name),
      ),
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
      ],
    );
  }

  AppBar selectItemAppBar(int index, {int? count}) {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      leading: IconButton(icon: Icon(Icons.clear), onPressed: swapAppBar),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              swapAppBar();
              editEvent(index);
            }),
        IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              swapAppBar();
              copyEvent(index);
            }),
        IconButton(icon: Icon(Icons.bookmark_border), onPressed: swapAppBar),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              swapAppBar();
              deleteEvent(index);
            }),
      ],
    );
  }

  Widget get chatBody {
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
            child: _messageField,
          ),
        ),
      ],
    );
  }

  ListView get _listView {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: category.events.length,
      itemBuilder: (context, index) {
        indexOfSelectedElement = index;
        final event = category.events[index];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          width: 100,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.2,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Card(
              elevation: 3,
              color: Colors.tealAccent,
              child: ListTile(
                title: Text(event.text),
                subtitle:
                    Text(DateFormat('yyyy-MM-dd kk:mm').format(event.dateTime)),
                onLongPress: () {
                  indexOfSelectedElement = index;
                  swapAppBar();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Row get _messageField {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.camera_alt_outlined),
          iconSize: 30,
          color: Colors.teal,
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
          color: Colors.teal,
          onPressed: () {
            if (isEditing) {
              setState(() {
                editText(indexOfSelectedElement);
              });
            } else {
              setState(sendEvent);
            }
          },
        ),
      ],
    );
  }

  void editText(int index) {
    category.events[index].text = textEditingController.text;
    textEditingController.clear();
    isEditing = false;
  }

  void sendEvent() {
    category.events.insert(
      0,
      Event(textEditingController.text, DateTime.now()),
    );
    textEditingController.clear();
  }

  void swapAppBar() {
    setState(() {
      eventSelected = !eventSelected;
    });
  }

  void editEvent(int index) {
    setState(() {
      isEditing = true;
      textEditingController.text = category.events[index].text;
      focusNode.requestFocus();
    });
  }

  void copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: category.events[index].text));
  }

  void deleteEvent(int index) {
    category.events.removeAt(index);
  }
}
