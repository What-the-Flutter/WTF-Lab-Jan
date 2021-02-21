import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'list_item.dart';
import 'theme.dart';
import 'theme_model.dart';

enum ModeOperation { input, selection, edit }

class ScreenMessage extends StatefulWidget {
  static const routeName = '/ScreenMsg';
  final String _title;
  final List<ListItem<String>> _messages;

  ScreenMessage(this._title, this._messages);

  @override
  _ScreenMessageState createState() => _ScreenMessageState(_title, _messages);
}

class _ScreenMessageState extends State<ScreenMessage> {
  final _controller = TextEditingController();
  final List<ListItem<String>> _messages;
  final String _title;
  ModeOperation _currentMode = ModeOperation.input;
  int _countDeletedMessage = 0;

  bool _isBookmarkMsg = false;
  String _clipBoard = '';

  final _picker = ImagePicker();

  _ScreenMessageState(this._title, this._messages);

  @override
  void dispose() {
    _controller.dispose();
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
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                var data = _messages[_messages.length - i - 1];
                if (_isBookmarkMsg) {
                  if (data.isFeatured) {
                    return _buildItem(data);
                  } else {
                    return Container();
                  }
                } else {
                  return _buildItem(data);
                }
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
              controller: _controller,
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
        for (var i = 0; i < _messages.length; i++) {
          if (_messages[i].isSelected) {
            index = i;
            break;
          }
        }
        _messages[index].message = _controller.text;
        _currentMode = ModeOperation.selection;
        _controller.text = '';
      },
    );
  }

  void _addNewMessage() {
    setState(
      () {
        _messages.add(ListItem<String>(_controller.text));
        _controller.text = '';
      },
    );
  }

  void _showPhotoLibrary() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _messages.add(ListItem(pickedFile.path, isImage: true));
    });
  }

  Widget _buildItem(ListItem msg) {
    var color;
    if (Provider.of<ThemeModel>(context).currentTheme == darkTheme) {
      if (msg.isSelected) {
        color = Colors.orangeAccent;
      } else {
        color = Colors.black;
      }
    } else {
      if (msg.isSelected) {
        color = Colors.green[200];
      } else {
        color = Colors.green[50];
      }
    }
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
              color: color,
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
        } else {
          msg.isFeatured = true;
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
      title: Center(
        child: Text(_title),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.search),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: IconButton(
            icon: _isBookmarkMsg
                ? Icon(
                    Icons.bookmark,
                    color: Colors.orangeAccent,
                  )
                : Icon(Icons.bookmark_border),
            onPressed: () {
              setState(
                () {
                  _isBookmarkMsg = !_isBookmarkMsg;
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
                    for (var i = 0; i < _messages.length; i++) {
                      if (_messages[i].isSelected) {
                        index = i;
                        break;
                      }
                    }
                    _controller.text = _messages[index].message;
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
                  for (var i = 0; i < _messages.length; i++) {
                    if (_messages[i].isSelected) {
                      _clipBoard += _messages[i].message;
                      _messages[i].isSelected = false;
                    }
                  }
                  Clipboard.setData(ClipboardData(text: _clipBoard));
                  _clipBoard = '';
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
                  for (var i = 0; i < _messages.length; i++) {
                    if (_messages[i].isSelected) {
                      _messages.removeAt(i);
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
        for (var i = 0; i < _messages.length; i++) {
          if (_messages[i].isSelected) {
            _messages[i].isSelected = false;
          }
        }
        _countDeletedMessage = 0;
        _currentMode = ModeOperation.input;
      },
    );
  }
}
