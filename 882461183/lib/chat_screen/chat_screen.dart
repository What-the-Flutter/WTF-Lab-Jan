import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'message_element.dart';

enum AppBarState {
  notSelected,
  oneSelected,
  multipleSelected,
}

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final StreamController<bool> isFieldEmpty = StreamController<bool>();
  final StreamController<AppBarState> elementSelectedCount =
      StreamController<AppBarState>();
  List<MessageChatElement> messagessList = [];
  List<Key?> selectedMessages = [];
  bool isShowFavorites = false;
  final StreamController<int> selectedCount = StreamController<int>();
  bool _test = false;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: _customAppBar(),
        body: Column(
          children: [
            messagessList.isEmpty
                ? _emptyListOfMessagess()
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
                          icon: const Icon(Icons.bubble_chart),
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
                      StreamBuilder<Object>(
                        stream: isFieldEmpty.stream,
                        builder: (context, snapshot) {
                          return Flexible(
                            flex: 1,
                            child: snapshot.data == true
                                ? _CustomIcon(Icons.send, _addNewMessage)
                                : _CustomIcon(Icons.camera_enhance, () {}),
                          );
                        },
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

  Widget _textField() {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: onChanged,
      controller: controller,
      cursorColor: Colors.orange[300],
      cursorWidth: 2.5,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(240, 240, 240, 1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        hintText: 'Enter Event',
      ),
    );
  }

  Widget _listOfMessagess() {
    return Expanded(
      child: ListView(
        reverse: true,
        children: isShowFavorites == false
            ? messagessList
            : messagessList
                .where((element) => element.isFavorite == true)
                .toList(),
      ),
    );
  }

  Widget _emptyListOfMessagess() {
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
                color: const Color.fromRGBO(217, 239, 216, 1),
                child: Column(
                  children: [
                    const Text(
                      'This is page where you can track everithing about "Sports"',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Add your first event to "Sports" page by entering some text'
                      'box below and hitting the send button. Long tap the send button to align'
                      'the event in the opposite direction. Tap on the bookmark icon'
                      'on the top right corner to show the bookmarked events only',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
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

  void onChanged(String value) {
    if (value.isEmpty) {
      _test = false;
    } else {
      _test = true;
    }
    isFieldEmpty.add(_test);
  }

  void _copyText() {
    var selectedStringElements = '';
    for (var i = messagessList.length; i > 0; i--) {
      if (messagessList[i - 1].isSelected) {
        selectedStringElements += '${messagessList[i - 1].mainText}\n';
      }
    }
    selectedStringElements =
        selectedStringElements.substring(0, selectedStringElements.length - 1);
    Clipboard.setData(ClipboardData(text: selectedStringElements));
    _unselectElements();
  }

  void _unselectElements() {
    selectedMessages = [];
    selectedCount.add(0);
    for (var element in messagessList) {
      if (element.isSelected) {
        element.isSelected = false;
        unsubscribeMessage(element.key);
        setState(() {});
      }
    }
  }

  void _addSelectedToFavorites() {
    for (var element in messagessList) {
      if (element.isSelected) {
        element.isFavorite = !element.isFavorite;
      }
    }
    _unselectElements();
  }

  void _deleteElement() {
    var _messagessList = [];
    for (var element in messagessList) {
      if (element.isSelected) {
        _messagessList.add(element);
      }
    }
    messagessList.removeWhere((e) => _messagessList.contains(e));
    _unselectElements();
  }

  void _editMessageText() {
    for (var element in messagessList) {
      if (element.isSelected) {
        controller.value = TextEditingValue(
          text: element.mainText,
          selection: TextSelection.fromPosition(
            TextPosition(offset: element.mainText.length),
          ),
        );
        focusNode.requestFocus();
      }
    }
  }

  void _addAllSelectablesToFavorite() {
    for (var element in messagessList) {
      if (element.isSelected) {
        element.isFavorite = !element.isFavorite;
      }
    }
    _unselectElements();
  }

  PreferredSizeWidget _selectedAppBar(Object? appBarState) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: _unselectElements,
      ),
      title: Text('${selectedMessages.length}'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.reply),
        ),
        appBarState == AppBarState.oneSelected
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
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

  PreferredSizeWidget _customAppBar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: StreamBuilder(
        stream: elementSelectedCount.stream,
        initialData: AppBarState.notSelected,
        builder: (context, snapshot) {
          if (snapshot.data == AppBarState.notSelected) {
            return _unselectedAppBar();
          }
          return _selectedAppBar(snapshot.data);
        },
      ),
    );
  }

  PreferredSizeWidget _unselectedAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {},
      ),
      title: const Text('Sports'),
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
      onPressed: _showAllFavorites,
      icon: isShowFavorites == false
          ? const Icon(Icons.bookmark_border)
          : const Icon(
              Icons.bookmark_outlined,
              color: Colors.yellow,
            ),
    );
  }

  void _showAllFavorites() {
    isShowFavorites = !isShowFavorites;
    setState(() {});
  }

  void subscribeMessage(Key? messageKey) {
    selectedMessages.add(messageKey);
    selectedCount.add(selectedMessages.length);
  }

  void unsubscribeMessage(Key? messageKey) {
    selectedMessages.remove(messageKey);
    selectedCount.add(selectedMessages.length);
    setState(() {});
  }

  @override
  void initState() {
    selectedCount.stream.listen((selectedMessagesLength) {
      if (selectedMessagesLength == 0) {
        elementSelectedCount.add(AppBarState.notSelected);
      }
      if (selectedMessagesLength == 1) {
        elementSelectedCount.add(AppBarState.oneSelected);
      }
      if (selectedMessagesLength > 1) {
        elementSelectedCount.add(AppBarState.multipleSelected);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    selectedCount.close();
    isFieldEmpty.close();
    elementSelectedCount.close();
    super.dispose();
  }

  void _addNewMessage() {
    messagessList = [
      MessageChatElement(
        key: UniqueKey(),
        mainText: controller.text,
        subscribeMessage: subscribeMessage,
        unsubscribeMessage: unsubscribeMessage,
      ),
      ...messagessList
    ];
    controller.clear();
    isFieldEmpty.add(false);
    setState(() {});
  }
}

class _CustomIcon extends StatelessWidget {
  _CustomIcon(this.icon, this.func);

  final IconData icon;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: func,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
