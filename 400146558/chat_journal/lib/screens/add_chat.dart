import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/models/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:chat_journal/models/globals.dart';
import 'package:jiffy/jiffy.dart';

class AddChat extends StatefulWidget {
  const AddChat({Key? key, required this.chatIndex}) : super(key: key);
  final int chatIndex;

  @override
  _AddChatState createState() => _AddChatState();
}

class _AddChatState extends State<AddChat> {
  final TextEditingController _textController = TextEditingController();
  bool _isWriting = false;

  @override
  void initState() {
    setState(() {
      if (widget.chatIndex != -1) {
        _textController.text = chats[widget.chatIndex].title;
        int _icoIndex = _icons.indexOf(_icons.firstWhere(
            (element) => element.icon == chats[widget.chatIndex].icon));
        _icons[_icoIndex].isSelected = true;
      } else {
        _icons[0].isSelected = true;
      }
    });
    super.initState();
  }

  final List<ChatIcon> _icons = [
    ChatIcon(
      isSelected: false,
      icon: Icons.sports_basketball,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.sports_basketball,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.monetization_on_outlined,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.airplanemode_on_sharp,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.card_travel,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.directions_car,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.home_outlined,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.star,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.music_note,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.vpn_key,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.brush_outlined,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.title,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.favorite,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.book_rounded,
    ),
    ChatIcon(
      isSelected: false,
      icon: Icons.nature_people,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.only(
            left: 30.0, right: 30.0, top: 50.0, bottom: 30.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Create new Page',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('Name of the page',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: floatingButtonColor)),
                    ),
                    TextField(
                      maxLines: 1,
                      controller: _textController,
                      enableSuggestions: true,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).cardColor,
                        filled: true,
                        border: InputBorder.none,
                      ),
                      cursorColor: floatingButtonColor,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 14.0),
                      onChanged: (text) {
                        setState(() {
                          _textController.text.isNotEmpty
                              ? _isWriting = true
                              : _isWriting = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                  ),
                  itemCount: _icons.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _check(index),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 30.0,
                            child: Icon(
                              _icons[index].icon,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                          if (_icons[index].isSelected == true) ...[
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.check,
                                      size: 15.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isWriting
          ? FloatingActionButton(
              onPressed: () {
                widget.chatIndex == -1 ? _addChat() : _editChat();
                Navigator.pop(context);
              },
              child: const Icon(Icons.add),
              backgroundColor: floatingButtonColor,
            )
          : FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close),
              backgroundColor: floatingButtonColor,
            ),
    );
  }

  void _check(int index) {
    if (mounted) {
      setState(() {
        for (var element in _icons) {
          element.isSelected = false;
        }
        _icons[index].isSelected = true;
      });
    }
  }

  void _addChat() {
    var _selectedIcon =
        _icons.firstWhere((element) => element.isSelected == true);
    Chat newChat = Chat(
        icon: _selectedIcon.icon,
        title: _textController.text,
        messageBase: [],
        myIndex: chats.length,
        time: Jiffy(DateTime.now()));
    chats.add(newChat);
  }

  void _editChat() {
    var _selectedIcon =
        _icons.firstWhere((element) => element.isSelected == true);
    chats[widget.chatIndex].title = _textController.text;
    chats[widget.chatIndex].icon = _selectedIcon.icon;
  }
}

class ChatIcon {
  final IconData icon;
  bool isSelected;

  ChatIcon({required this.isSelected, required this.icon});
}
