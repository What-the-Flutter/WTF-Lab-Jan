import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '/models/chat_model.dart';
import '/models/event_model.dart';

class ChatScreen extends StatefulWidget {
  final Chat selectedChat;

  ChatScreen(this.selectedChat, {Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Event> _favoriteEventList = [];
  final _controller = TextEditingController();
  int _selectedItemsCount = 0;
  UniqueKey? _key;
  bool _isShowFavorites = false;
  bool _isTextFieldEmpty = true;
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: _customAppBar(),
        body: Column(
          children: [
            widget.selectedChat.eventList.isEmpty
                ? _emptyListOfMessagess(
                    'Add your first event to "${widget.selectedChat.elementName}"'
                    ' page by entering some text box below and hitting the send button.'
                    'Long tap the send button to align the event in the opposite direction. '
                    'Tap on the bookmark icon on the top right corner to show the bookmarked events only',
                  )
                : _listOfMessagess(),
            Column(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 3),
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.bubble_chart,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                      ),
                      Flexible(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 9,
                          ),
                          child: _textField(),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: _isTextFieldEmpty
                            ? _CustomIcon(
                                !_isEditing
                                    ? Icons.camera_enhance
                                    : Icons.close,
                                !_isEditing
                                    ? _addImage
                                    : () {
                                        _isEditing = false;
                                        _controller.clear();
                                        _isTextFieldEmpty = true;
                                        setState(() {});
                                      },
                                Theme.of(context).colorScheme.secondary,
                              )
                            : _CustomIcon(
                                Icons.send,
                                !_isEditing ? _addNewMessage : _confirmEditing,
                                Theme.of(context).colorScheme.secondary,
                              ),
                      ),
                      const SizedBox(width: 7),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // final imageTemporary = File(image.path);

    widget.selectedChat.eventList.insert(
      0,
      Event(
        key: UniqueKey(),
        text: 'Image Entry',
        imagePath: image.path,
        date: DateTime.now(),
      ),
    );
    setState(() {});
  }

  Widget _textField() {
    return TextField(
      onChanged: (value) {
        if (value.isEmpty) {
          _isTextFieldEmpty = true;
        } else {
          _isTextFieldEmpty = false;
        }
        setState(() {});
      },
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: _controller,
      cursorColor: Colors.orange[300],
      cursorWidth: 2.5,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.primaryVariant,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        hintText: 'Enter Event',
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget _listOfMessagess() {
    final unselectedColor = Theme.of(context).colorScheme.primaryVariant;
    final selectedColor = Theme.of(context).colorScheme.secondaryVariant;
    final textColor = Theme.of(context).colorScheme.secondary;
    final timeFormat = DateFormat('h:mm a');
    if (!_isShowFavorites) {
      _favoriteEventList = widget.selectedChat.eventList;
    } else if (_isShowFavorites) {
      _favoriteEventList = widget.selectedChat.eventList
          .where((element) => element.isFavorite)
          .toList();
      if (_favoriteEventList.isEmpty) {
        return _emptyListOfMessagess('You dont seem to have any bookmarked'
            'envents yet. You can bookmark an event by single tapping the event');
      }
    }

    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: _favoriteEventList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (_favoriteEventList[index].isSelected ||
                    _selectedItemsCount > 0)
                ? () {
                    _favoriteEventList[index].isSelected =
                        !_favoriteEventList[index].isSelected;
                    _favoriteEventList[index].isSelected
                        ? _selectedItemsCount++
                        : _selectedItemsCount--;
                    setState(() {});
                  }
                : () {
                    _favoriteEventList[index].isFavorite =
                        !_favoriteEventList[index].isFavorite;
                    setState(() {});
                  },
            onLongPress: () {
              _favoriteEventList[index].isSelected =
                  !_favoriteEventList[index].isSelected;
              _favoriteEventList[index].isSelected
                  ? _selectedItemsCount++
                  : _selectedItemsCount--;
              setState(() {});
            },
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 369),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: const EdgeInsets.only(
                      right: 18, bottom: 6, top: 10, left: 8),
                  decoration: BoxDecoration(
                    color: _favoriteEventList[index].isSelected
                        ? selectedColor
                        : unselectedColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_favoriteEventList[index].imagePath.isNotEmpty)
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _FullSizeImage(
                                  _favoriteEventList[index].imagePath),
                            ),
                          ),
                          child: Hero(
                            tag: 'imageHero',
                            child: Image.file(
                              File(_favoriteEventList[index].imagePath),
                            ),
                          ),
                        )
                      else
                        Text(
                          _favoriteEventList[index].text,
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3, left: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_favoriteEventList[index].isSelected)
                              _isSelectedItem(),
                            Text(
                              timeFormat
                                  .format(_favoriteEventList[index].date)
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                            if (_favoriteEventList[index].isFavorite)
                              _isFavoriteItem(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyListOfMessagess(String subtext) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                margin: const EdgeInsets.only(left: 40, right: 40, top: 15),
                color: Theme.of(context).colorScheme.primaryVariant,
                child: Column(
                  children: [
                    Text(
                      'This is page where you can track everithing'
                      ' about "${widget.selectedChat.elementName}"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      subtext,
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyText() {
    var selectedStringElements = '';
    for (var i = widget.selectedChat.eventList.length; i > 0; i--) {
      if (widget.selectedChat.eventList[i - 1].isSelected) {
        selectedStringElements +=
            '${widget.selectedChat.eventList[i - 1].text}\n';
      }
    }
    selectedStringElements =
        selectedStringElements.substring(0, selectedStringElements.length - 1);
    Clipboard.setData(ClipboardData(text: selectedStringElements));
    _unselectElements();
  }

  void _confirmEditing() {
    var newText = _controller.text;
    for (var element in widget.selectedChat.eventList) {
      if (element.key == _key) {
        element.text = newText;
      }
    }
    setState(() {
      _isEditing = false;
      _controller.clear();
      _isTextFieldEmpty = true;
    });
  }

  void _unselectElements() {
    for (var element in widget.selectedChat.eventList) {
      if (element.isSelected) {
        element.isSelected = false;
        setState(() {});
      }
      _selectedItemsCount = 0;
    }
  }

  void _addSelectedToFavorites() {
    for (var element in widget.selectedChat.eventList) {
      if (element.isSelected) {
        element.isFavorite = !element.isFavorite;
      }
    }
    _unselectElements();
  }

  void _deleteElement() {
    var _messagessList = [];
    for (var element in widget.selectedChat.eventList) {
      if (element.isSelected) {
        _messagessList.add(element);
      }
    }
    widget.selectedChat.eventList
        .removeWhere((e) => _messagessList.contains(e));
    _selectedItemsCount = 0;
    setState(() {});
  }

  void _editMessageText() {
    for (var element in widget.selectedChat.eventList) {
      if (element.isSelected) {
        _key = element.key;
        _controller.text = element.text;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        break;
      }
    }
    _isEditing = true;
    _unselectElements();
  }

  void _addAllSelectablesToFavorite() {
    for (var element in widget.selectedChat.eventList) {
      if (element.isSelected) {
        element.isFavorite = !element.isFavorite;
      }
    }
    _unselectElements();
  }

  PreferredSizeWidget _customAppBar() {
    if (_isEditing) {
      return PreferredSize(
        child: _editAppBar(),
        preferredSize: const Size(double.infinity, kToolbarHeight),
      );
    }

    var selectedItemsCount = 0;
    for (var element in widget.selectedChat.eventList) {
      if (element.isSelected) {
        selectedItemsCount++;
      }
    }

    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: selectedItemsCount == 0
          ? _unselectedAppBar()
          : _selectedAppBar(selectedItemsCount),
    );
  }

  PreferredSizeWidget _editAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _isEditing = false;
          _controller.clear();
          setState(() {});
        },
      ),
      centerTitle: true,
      title: const Text('Editing Mode'),
    );
  }

  PreferredSizeWidget _selectedAppBar(int selectedItemsCount) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: _unselectElements,
      ),
      title: Text('$selectedItemsCount'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.reply),
        ),
        selectedItemsCount == 1
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _editMessageText,
              )
            : Container(),
        IconButton(
          onPressed: _copyText,
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          onPressed: _addAllSelectablesToFavorite,
          icon: const Icon(Icons.bookmark_border),
        ),
        IconButton(
          onPressed: _deleteElement,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  PreferredSizeWidget _unselectedAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (widget.selectedChat.eventList.isNotEmpty) {
            widget.selectedChat.elementSubname =
                widget.selectedChat.eventList[0].text;
          } else {
            widget.selectedChat.elementSubname =
                'No events. Click to create one.';
          }
          Navigator.pop(context);
        },
      ),
      title: Text(widget.selectedChat.elementName),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        _favoriteButton(),
      ],
    );
  }

  IconButton _favoriteButton() {
    return IconButton(
      onPressed: _showFavorites,
      icon: _isShowFavorites == false
          ? const Icon(Icons.bookmark_border)
          : const Icon(
              Icons.bookmark_outlined,
              color: Colors.yellow,
            ),
    );
  }

  void _showFavorites() {
    _isShowFavorites = !_isShowFavorites;
    setState(() {});
  }

  Widget _isSelectedItem() {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.secondary,
          size: 15,
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _isFavoriteItem() {
    return Row(
      children: [
        const Icon(
          Icons.bookmark,
          color: Colors.yellow,
          size: 15,
        ),
      ],
    );
  }

  void _addNewMessage() {
    widget.selectedChat.eventList.insert(
      0,
      Event(
        key: UniqueKey(),
        text: _controller.text,
        date: DateTime.now(),
      ),
    );
    _controller.clear();
    _isTextFieldEmpty = true;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CustomIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback func;
  final Color color;

  _CustomIcon(this.icon, this.func, this.color);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
      ),
      onPressed: func,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}

class _FullSizeImage extends StatelessWidget {
  final String imagePath;

  _FullSizeImage(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Hero(
        tag: 'imageHero',
        child: Image.file(
          File(imagePath),
        ),
      ),
    );
  }
}
