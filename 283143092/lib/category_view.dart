import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'message.dart';
import 'message_bubble.dart';
import 'mockup.dart';

class CategoryView extends StatefulWidget {
  CategoryView({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  bool _isAddPhotoMenuChecked = false;
  bool _isEventMenuChecked = false;
  bool _isFavouriteFilterChecked = false;
  bool _isSearchChecked = false;
  bool _isMessageEdited = false;

  final _searchFieldFocusNode = FocusNode();

  final _newMessageFieldController = TextEditingController();
  final _searchFieldController = TextEditingController();

  final List<Message> _allMessages = Mockup.messages;
  final List<Message> _selectedMessages = [];
  late List<Message> _messages = _allMessages;

  MapEntry<String, IconData>? _currentEvent;
  final Map<String, IconData> _events = {
    'Sport': Icons.directions_run,
    'Movie': Icons.local_movies,
    'Music': Icons.music_note,
    'Food': Icons.local_dining,
  };

  void _onEventsMenuButtonPress() {
    setState(() {
      _isEventMenuChecked = !_isEventMenuChecked;
      _isAddPhotoMenuChecked = false;
    });
  }

  void _onEventMenuItemPress(MapEntry<String, IconData> event) {
    setState(() => _currentEvent = event);
  }

  void _onNewMessageButtonPress() {
    var isFavourite = _isMessageEdited ? _selectedMessages[0].favourite : false;
    var currentTime = _isMessageEdited ? _selectedMessages[0].date : DateTime.now();
    setState(() => _allMessages.add(Message(_newMessageFieldController.text,
        currentTime, isFavourite, _currentEvent)));
    _newMessageFieldController.clear();
    if(_isMessageEdited){
      _isMessageEdited = false;
      _onDeleteButtonPress();
      _sortList();
    }
    _currentEvent = null;
  }

  void _onPhotoMenuItemPress(String button) async {
    var source =
        button.contains('Gallery') ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _allMessages.add(
            Message('', DateTime.now(), false, null, File(pickedFile.path)));
      });
    }
  }

  void _onPhotoMenuButtonPress() {
    setState(() {
      _isAddPhotoMenuChecked = !_isAddPhotoMenuChecked;
      _isEventMenuChecked = false;
    });
  }

  void _onFavouriteButtonPress() {
    if (_selectedMessages.isEmpty) {
      setState(() => _isFavouriteFilterChecked = !_isFavouriteFilterChecked);
      _updateList();
    } else {
      for (var message in _selectedMessages) {
        _onMessagePress(message);
      }
      _exitEditingBar();
    }
  }

  void _onSearchButtonPress() {
    setState(() {
      _isSearchChecked = !_isSearchChecked;
    });
    if (!_isSearchChecked) {
      _searchFieldController.clear();
    } else {
      _searchFieldFocusNode.requestFocus();
    }
    _updateList();
  }

  void _onMessagePress(Message message) {
    _allMessages.add(Message(message.text, message.date, !message.favourite,
        message.event, message.image));
    _allMessages.remove(message);
    _sortList();
    _updateList();
  }

  void _onMessageLongPress(Message message) {
    setState(() {
      if (_selectedMessages.contains(message)) {
        _selectedMessages.remove(message);
      } else {
        _selectedMessages.add(message);
      }
    });
  }

  void _onEditButtonPress() {
    setState((){_isMessageEdited = !_isMessageEdited;});
    _newMessageFieldController.text = _selectedMessages[0].text;
    _currentEvent = _selectedMessages[0].event;
  }

  void _onCopyButtonPress() {
    var copy = '';
    for (var message in _selectedMessages) {
      copy += '${message.text} ';
    }
    Clipboard.setData(ClipboardData(text: copy));
    _exitEditingBar();
  }

  void _onDeleteButtonPress() {
    for (var message in _selectedMessages) {
      _allMessages.remove(message);
    }
    _exitEditingBar();
    _updateList();
  }

  void _exitEditingBar() {
    setState(_selectedMessages.clear);
  }

  void _sortList(){
    _allMessages.sort((a, b) => a.date.compareTo(b.date));
  }

  void _updateList({String filter = ''}) {
    var result = _allMessages;
    if (_isFavouriteFilterChecked) {
      result = result.where((item) => item.favourite).toList();
    } else if (filter != '') {
      result = result.where((item) => item.text.contains(filter)).toList();
    }
    setState(() {
      _messages = result;
    });
  }

  AppBar _appBarWithEditing() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _exitEditingBar,
      ),
      actions: [
        if (_selectedMessages.length == 1)
          IconButton(
            icon: const Icon(Icons.create),
            onPressed: _onEditButtonPress,
          ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: _onCopyButtonPress,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _onDeleteButtonPress,
        ),
        IconButton(
          icon: const Icon(Icons.bookmark),
          onPressed: _onFavouriteButtonPress,
        ),
      ],
    );
  }

  AppBar _appBarWithSearch() {
    return AppBar(
      title: Container(
        padding: const EdgeInsets.all(10),
        child: _isSearchChecked
            ? TextField(
                controller: _searchFieldController,
                focusNode: _searchFieldFocusNode,
                decoration: InputDecoration(
                  filled: true,
                  border: const OutlineInputBorder(),
                  fillColor: Theme.of(context).backgroundColor,
                ),
                onChanged: (text) => {
                  if (text.isNotEmpty)
                    {_updateList(filter: text)}
                  else
                    {_updateList()}
                },
              )
            : Text(widget.category),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _onSearchButtonPress,
        ),
        IconButton(
          icon: const Icon(Icons.bookmark),
          onPressed: _onFavouriteButtonPress,
        ),
      ],
    );
  }

  // TODO: add case for the first item
  Widget _chatBody() {
    var _previousDate = Message('test', DateTime.now(), false);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: _messages.isNotEmpty
            ? ListView.separated(
                itemCount: _messages.length,
                itemBuilder: (_, index) {
                  final _message = _messages[index];
                  final _isSelected = _selectedMessages.contains(_message);
                  final _listItem = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_message.formattedDate !=
                          _previousDate.formattedDate) ...[
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              MessageBubble(_message, true, false),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                      GestureDetector(
                        child: MessageBubble(_message, false, _isSelected),
                        onTap: () {
                          if (_selectedMessages.isNotEmpty) {
                            _onMessageLongPress(_message);
                          } else {
                            _onMessagePress(_message);
                          }
                        },
                        onLongPress: () => _onMessageLongPress(_message),
                      ),
                    ],
                  );
                  _previousDate = _message;
                  return _listItem;
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
              )
            : const Text('Can\'t find needed items'),
      ),
    );
  }

  Widget _hiddenPhotoMenu() {
    final _photoMenuItems = <String, IconData>{
      'Open Gallery': Icons.camera_enhance,
      'Open Camera': Icons.photo,
    };

    return Visibility(
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.horizontal,
          itemCount: _photoMenuItems.length,
          itemBuilder: (_, index) {
            final item = _photoMenuItems.entries.elementAt(index);
            return GestureDetector(
                  child: Container(
                    color: Colors.grey,
                    height: 80,
                    width: (MediaQuery.of(context).size.width - 50) * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.value),
                        Text(item.key),
                      ],
                    ),
                ),
                onTap: () {
                  _onPhotoMenuItemPress(item.key);
                  _onPhotoMenuButtonPress();
                });
          },
          separatorBuilder: (_, __) => const SizedBox(width: 30),
        ),
      ),
      visible: _isAddPhotoMenuChecked,
    );
  }

  Widget _hiddenEventMenu() {
    return Visibility(
      child: SizedBox(
        height: 60,
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.horizontal,
          itemCount: _events.length,
          itemBuilder: (context, index) {
            final item = _events.entries.elementAt(index);
            return GestureDetector(
              child: Column(children: [
                Icon(item.value),
                Text(item.key),
              ]),
              onTap: () {
                _onEventMenuItemPress(item);
                _onEventsMenuButtonPress();
              },
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 30),
        ),
      ),
      visible: _isEventMenuChecked,
    );
  }

  Widget _newEntryField() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _currentEvent == null ? Icons.dehaze : _currentEvent!.value,
            ),
            onPressed: _onEventsMenuButtonPress,
          ),
          Expanded(
            child: TextField(
              controller: _newMessageFieldController,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _newMessageFieldController,
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(
                  value.text.isEmpty ? Icons.add_a_photo : Icons.send,
                ),
                onPressed: value.text.isEmpty
                    ? _onPhotoMenuButtonPress
                    : _onNewMessageButtonPress,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newMessageFieldController.dispose();
    _searchFieldController.dispose();
    _searchFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedMessages.isEmpty
          ? _appBarWithSearch()
          : _appBarWithEditing(),
      body: Column(
        children: [
          _chatBody(),
          _hiddenEventMenu(),
          _hiddenPhotoMenu(),
          _newEntryField(),
        ],
      ),
    );
  }
}
