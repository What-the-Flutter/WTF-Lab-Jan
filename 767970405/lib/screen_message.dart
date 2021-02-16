import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'list_item.dart';

enum ModeOperation { input, selection, edit }

class ScreenMessage extends StatefulWidget {
  @override
  _ScreenMessageState createState() => _ScreenMessageState();
}

class _ScreenMessageState extends State<ScreenMessage> {
  final controller = TextEditingController();
  List<ListItem<String>> messages = <ListItem<String>>[];
  List<ListItem<String>> bookmarkMessages = <ListItem<String>>[];
  ModeOperation _currentMode = ModeOperation.input;
  int _countDeletedMessage = 0;

  bool isBookmarkMsg = false;
  String clipBoard = '';

  final _picker = ImagePicker();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentMode == ModeOperation.input
          ? _inputAppBar()
          : _currentMode == ModeOperation.selection
          ? _selectionAppBar()
          : _editAppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount:
              isBookmarkMsg ? bookmarkMessages.length : messages.length,
              itemBuilder: (context, i) {
                ListItem<String> data;
                if (isBookmarkMsg) {
                  data = bookmarkMessages[bookmarkMessages.length - i - 1];
                } else {
                  data = messages[messages.length - i - 1];
                }
                return _buildItem(data);
              },
            ),
          ),
          _buildPanelInput(),
        ],
      ),
    );
  }

  Widget _buildPanelInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(Icons.bubble_chart),
          ),
          Expanded(
            flex: 5,
            child: TextField(
              enabled: _currentMode == ModeOperation.input ||
                  _currentMode == ModeOperation.edit
                  ? true
                  : false,
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: _currentMode != ModeOperation.edit
                      ? Icon(Icons.arrow_forward_ios)
                      : Icon(Icons.check),
                  onPressed: _currentMode != ModeOperation.edit
                      ? _addNewMessage
                      : _updateMessage,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: _showPhotoLibrary,
            ),
          ),
        ],
      ),
    );
  }

  void _updateMessage() {
    setState(
          () {
        var index = -1;
        for (var i = 0; i < messages.length; i++) {
          if (messages[i].isSelected) {
            index = i;
            break;
          }
        }
        messages[index].message = controller.text;
        _currentMode = ModeOperation.selection;
        controller.text = '';
      },
    );
  }

  void _addNewMessage() {
    setState(
          () {
        messages.add(ListItem<String>(controller.text));
        controller.text = '';
      },
    );
  }

  void _showPhotoLibrary() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      messages.add(ListItem(pickedFile.path, isImage: true));
    });
  }

  Widget _buildItem(ListItem msg) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: _currentMode == ModeOperation.input
              ? () => _changeBookmarkMessage(msg)
              : () => _changeStateListItem(msg),
          onLongPress: _currentMode == ModeOperation.input
              ? () => _selectingFirstItemToDeleted(msg)
              : () => _changeStateListItem(msg),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: msg.isSelected ? Colors.green[200] : Colors.green[50],
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                if (msg.isImage) Image.file(File(msg.message)),
                Text(msg.message),
                if (msg.isFeatured)
                  Icon(
                    Icons.bookmark,
                    color: Colors.orangeAccent,
                    size: 8,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeBookmarkMessage(ListItem msg) {
    setState(
          () {
        if (msg.isFeatured) {
          msg.isFeatured = false;
          bookmarkMessages.remove(msg);
        } else {
          msg.isFeatured = true;
          bookmarkMessages.add(msg);
        }
      },
    );
  }

  void _changeStateListItem(msg) {
    setState(
          () {
        if (msg.isSelected) {
          _countDeletedMessage--;
          msg.isSelected = false;
        } else {
          _countDeletedMessage++;
          msg.isSelected = true;
        }
        if (_countDeletedMessage == 0) {
          _currentMode = ModeOperation.input;
        }
      },
    );
  }

  void _selectingFirstItemToDeleted(ListItem msg) {
    setState(
          () {
        msg.isSelected = true;
        _countDeletedMessage++;
        _currentMode = ModeOperation.selection;
      },
    );
  }

  Widget _inputAppBar() {
    return AppBar(
      //leading: Icon(Icons.arrow_back_outlined),
      title: Center(
        child: Text('Hello'),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.search),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: IconButton(
            icon: isBookmarkMsg
                ? Icon(
              Icons.bookmark,
              color: Colors.orangeAccent,
            )
                : Icon(Icons.bookmark_border),
            onPressed: () {
              setState(
                    () {
                  isBookmarkMsg = !isBookmarkMsg;
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _editAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.keyboard_backspace),
        onPressed: _resetMode,
      ),
      title: Center(
        child: Text('Edit Mode'),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                _currentMode = ModeOperation.selection;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _selectionAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: _resetMode,
      ),
      title: Text('$_countDeletedMessage'),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ),
        if (_countDeletedMessage < 2)
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(
                      () {
                    var index = -1;
                    for (var i = 0; i < messages.length; i++) {
                      if (messages[i].isSelected) {
                        index = i;
                        break;
                      }
                    }
                    controller.text = messages[index].message;
                    _currentMode = ModeOperation.edit;
                  },
                );
              },
            ),
          ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              setState(
                    () {
                  for (var i = 0; i < messages.length; i++) {
                    if (messages[i].isSelected) {
                      clipBoard += messages[i].message;
                      messages[i].isSelected = false;
                    }
                  }
                  Clipboard.setData(ClipboardData(text: clipBoard));
                  clipBoard = '';
                  _countDeletedMessage = 0;
                  _currentMode = ModeOperation.input;
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(
                    () {
                  for (var i = 0; i < messages.length; i++) {
                    if (messages[i].isSelected) {
                      bookmarkMessages.remove(messages[i]);
                      messages.removeAt(i);
                      i--;
                    }
                  }
                  _countDeletedMessage = 0;
                  _currentMode = ModeOperation.input;
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _resetMode() {
    setState(
          () {
        for (var i = 0; i < messages.length; i++) {
          if (messages[i].isSelected) {
            messages[i].isSelected = false;
          }
        }
        _countDeletedMessage = 0;
        _currentMode = ModeOperation.input;
      },
    );
  }
}
