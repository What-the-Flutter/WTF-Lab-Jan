import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'message.dart';
import 'mockup.dart';

class CategoryView extends StatefulWidget {
  CategoryView({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  bool _eventsMenuStatus = false;
  bool _addPhotoMenuStatus = false;

  bool _isFavouriteFilterChecked = false;
  bool _isSearchChecked = false;

  final _searchFieldFocusNode = FocusNode();

  final _searchFieldController = TextEditingController();
  final _newEntryFieldController = TextEditingController();

  final List<Message> _allMessages = Mockup.messages;
  final List<Message> _selectedMessages = [];
  late List<Message> _messages = _allMessages;

  void _onCreateNewEntryPressed() {
    if (_newEntryFieldController.text.isEmpty) {
      setState(() => _addPhotoMenuStatus = !_addPhotoMenuStatus);
      Mockup.mockup('Open "Add photo entry" menu', context);
    } else {
      setState(() => _allMessages
          .add(Message(_newEntryFieldController.text, DateTime.now())));
      _newEntryFieldController.clear();
    }
  }

  void _onEventsMenuButtonPress() {
    setState(() => _eventsMenuStatus = !_eventsMenuStatus);
  }

  void _onFavouriteFilterButtonPress() {
    setState(() {
      _isFavouriteFilterChecked = !_isFavouriteFilterChecked;
      _runFilter(favourite: _isFavouriteFilterChecked);
    });
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
    _messages = Mockup.messages;
  }

  void _onMessagePress(Message message) {
    setState(() => message.setFavourite());
  }

  void _onSelectPress(Message message) {
    setState(() {
      if (_selectedMessages.contains(message)) {
        _selectedMessages.remove(message);
      } else {
        _selectedMessages.add(message);
      }
    });
  }

  void _runFilter({String filter = '', bool favourite = false}) {
    var result = _allMessages;
    if (favourite) {
      result = _allMessages.where((item) => item.favourite).toList();
    } else if (filter != '') {
      result =
          _allMessages.where((item) => item.text.contains(filter)).toList();
    }
    setState(() {
      _messages = result;
    });
  }

  void _exitEditingBar(){
    setState (_selectedMessages.clear);
  }

  void _editMessage() {
    var message = _selectedMessages[0];
    Mockup.mockup('Editing message ${message.text}', context);
  }

  void _copySelectedContent() {
    var copy = '';
    for (var message in _selectedMessages) {
      copy += '${message.text} ';
    }
    print('hello');
    _exitEditingBar();
    Clipboard.setData(ClipboardData(text: copy));
  }

  void _addSelectedToFavourite(){
    for (var message in _selectedMessages) {
      message.setFavourite();
    }
    _exitEditingBar();
  }

  void _deleteSelectedMessages(){
    void _addSelectedToFavourite(){
      for (var message in _selectedMessages) {
        _allMessages.remove(message);
      }
      _exitEditingBar();
    }
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
            onPressed: _editMessage,
          ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: _copySelectedContent,
        ),
        IconButton(
          icon: const Icon(Icons.bookmark),
          onPressed: _addSelectedToFavourite,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _deleteSelectedMessages,
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
                  if (text.length > 2) {_runFilter(filter: text)}
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
          onPressed: _onFavouriteFilterButtonPress,
        ),
      ],
    );
  }

  // TODO: add case for the first item
  Widget _chatBody() {
    var _previousDate = Message('test', DateTime.now());
    return Container(
      padding: const EdgeInsets.all(10),
      child: _messages.isNotEmpty
          ? ListView.separated(
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                var _message = _messages[index];
                var _isSelected =_selectedMessages.contains(_message);
                var _color = _isSelected ? Colors.purpleAccent : Colors.grey;
                var _tmp = GestureDetector(
                  child: (_message.isEqual(_previousDate))
                      ? _message.widget(_color)
                      : _message.widgetWithDate(_color),
                  onTap: () => _isSelected ? _onSelectPress(_message) : _onMessagePress(_message),
                  onLongPress: () => _onSelectPress(_message),
                );
                _previousDate = _message;
                return _tmp;
              },
              separatorBuilder: (_, __) => Container(height: 8),
            )
          : const Text('Can\'t find needed items'),
    );
  }

  Widget _hiddenMenu() {
    return Visibility(
      // TODO: change to expandable list from https://stackoverflow.com/questions/58771867/how-to-hide-minimize-a-listview-with-an-animation
      child: SizedBox(
        height: 150,
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Text(['products', 'products', 'products'][index]);
            }),
      ),
      visible: _eventsMenuStatus || _addPhotoMenuStatus,
    );
  }

  Widget _newEntryField() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            child: const Icon(
              Icons.dehaze,
            ),
            onTap: _onEventsMenuButtonPress,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              controller: _newEntryFieldController,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 20),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _newEntryFieldController,
            builder: (context, value, child) {
              return InkWell(
                child: Icon(
                  value.text.isEmpty ? Icons.add_a_photo : Icons.send,
                ),
                onTap: _onCreateNewEntryPressed,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newEntryFieldController.dispose();
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
          Expanded(
            child: _chatBody(),
          ),
          //_hiddenMenu(),
          _newEntryField(),
        ],
      ),
    );
  }
}
