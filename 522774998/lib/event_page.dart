import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ListItem<T> {
  T message;
  String time;

  bool isSelected;
  bool isEdited;

  ListItem(this.message, this.time,
      {this.isSelected = false, this.isEdited = false});
}

enum Operation { input, delete, selection, edit }

class EventListPage extends StatefulWidget {
  final String title;
  final ThemeData theme;

  EventListPage({Key key, this.title, this.theme}) : super(key: key);

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<ListItem<String>> messages = <ListItem<String>>[];
  Operation currentOperation = Operation.input;
  final controller = TextEditingController();
  int countSelectedMessage = 0;
  String clipBoard = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: widget.theme,
      home: Scaffold(
        appBar: currentOperation == Operation.input
            ? _inputAppBar()
            : _editAppBar(),
        body: Stack(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Theme.of(context).backgroundColor,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        ListItem<String> data;
                        data = messages[messages.length - i - 1];
                        return _eventItem(data);
                      },
                    ),
                  ),
                  _inputItem(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputAppBar() {
    return AppBar(
      title: Container(
        alignment: Alignment.center,
        child: Text(
          widget.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 20),
          child: Icon(Icons.search),
        ),
      ],
    );
  }

  Widget _editAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.close,
        ),
        onPressed: () {
          setState(() {
            for (var i = 0; i < messages.length; i++) {
              if (messages[i].isSelected) {
                messages[i].isSelected = false;
              }
            }
            countSelectedMessage = 0;
            currentOperation = Operation.input;
          });
        },
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 14, right: 10),
          child: Text(
            countSelectedMessage.toString(),
            style: TextStyle(fontSize: 24),
          ),
        ),
        if (countSelectedMessage < 2)
          Container(
            margin: EdgeInsets.only(right: 0),
            child: IconButton(
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: () {
                  setState(() {
                    int index;
                    for (var i = 0; i < messages.length; i++) {
                      if (messages[i].isSelected) {
                        index = i;
                        break;
                      }
                    }
                    controller.text = messages[index].message;
                    controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length));
                    currentOperation = Operation.edit;
                  });
                }),
          ),
        Container(
          margin: EdgeInsets.only(right: 0),
          child: IconButton(
            icon: Icon(
              Icons.copy,
            ),
            onPressed: () {
              setState(() {
                for (var i = 0; i < messages.length; i++) {
                  if (messages[i].isSelected) {
                    clipBoard += messages[i].message;
                    clipBoard += ' ';
                    messages[i].isSelected = false;
                  }
                }
                Clipboard.setData(ClipboardData(text: clipBoard));
                clipBoard = '';
                countSelectedMessage = 0;
                currentOperation = Operation.input;
              });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () {
              setState(() {
                for (var i = 0; i < messages.length; i++) {
                  if (messages[i].isSelected) {
                    messages.removeAt(i);
                    i--;
                  }
                }
                countSelectedMessage = 0;
                currentOperation = Operation.input;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _eventItem(ListItem msg) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      alignment: Alignment.bottomLeft,
      child: GestureDetector(
        onLongPress: currentOperation == Operation.input
            ? () => _selectFirstItem(msg)
            : () => _changeListItemState(msg),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            border: Border.all(
              color: msg.isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.orange,
            ),
            color: msg.isSelected
                ? Colors.deepPurple[50]
                : Colors.orange[50],
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                msg.message,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                msg.isEdited
                    ? '${msg.time} edited'
                    : msg.time,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputItem() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              Icons.bubble_chart,
            ),
          ),
          Expanded(
            flex: 5,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter event',
                suffixIcon: IconButton(
                  icon: currentOperation != Operation.edit
                      ? Icon(Icons.send)
                      : Icon(Icons.done),
                  onPressed: currentOperation != Operation.edit
                      ? _addMessage
                      : _updateMessage,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(Icons.camera_enhance_rounded),
          ),
        ],
      ),
    );
  }

  void _changeListItemState(msg) {
    setState(() {
      if (msg.isSelected) {
        countSelectedMessage--;
        msg.isSelected = false;
      } else {
        countSelectedMessage++;
        msg.isSelected = true;
      }
      if (countSelectedMessage == 0) {
        currentOperation = Operation.input;
      }
    });
  }

  void _selectFirstItem(ListItem msg) {
    setState(() {
      msg.isSelected = true;
      countSelectedMessage++;
      currentOperation = Operation.selection;
    });
  }

  void _updateMessage() {
    setState(() {
      int index;
      for (var i = 0; i < messages.length; i++) {
        if (messages[i].isSelected) {
          index = i;
          messages[i].isEdited = true;
          messages[i].isSelected = false;
          break;
        }
      }
      messages[index].message = controller.text;
      countSelectedMessage = 0;
      currentOperation = Operation.input;
      controller.text = '';
    });
  }

  void _addMessage() {
    setState(() {
      messages.add(ListItem<String>(
          controller.text, DateFormat('kk:mm').format(DateTime.now())));
      controller.text = '';
    });
  }
}
