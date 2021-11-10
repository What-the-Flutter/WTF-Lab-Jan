import 'package:flutter/material.dart';
import "consts.dart";
import 'package:chat_journal/model/message_data.dart';
import 'package:chat_journal/components/buble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.title}) : super(key: key);

  final title;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late int _editNumber;
  late MessageData _selected;
  late String _messageText;
  final _messageController = TextEditingController();
  final _messageController2 = TextEditingController();

  List<MessageData> messages = [];
  List<MessageData> likedMessages = [];
  bool firstMessage = false;
  bool favourite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.title),
        ),
        actions: [
          IconButton(
            onPressed: () {}, //poisk
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                favourite = !favourite;
              });
            }, //izbranniy
            icon: favourite
                ? const Icon(
                    Icons.bookmark_border_outlined,
                  )
                : const Icon(
                    Icons.bookmark,
                  ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context)
              .pushNamedAndRemoveUntil(('/'), (route) => false),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: firstMessage //Vinesti v otdelniy metod
                  ? favourite
                      ? ListViewFavourite()
                      : ListViewFouriteFalse()
                  : DefaultChat(widget: widget),
            ),
            InputRow(),
          ],
        ),
      ),
    );
  }

  Row InputRow() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.attach_file,
            color: Colors.indigo,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (value) {
              _messageText = value;
            },
            decoration: kTextFieldDecoration,
            validator: (text) {
              if (text == '') {
                return 'Enter a word';
              } else if (text == null) {
                return 'Enter a word';
              } else {
                print('Error');
              }
            },
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              firstMessage = true;

              _messageController.clear();

              messages.add(
                MessageData(
                  mText: _messageText,
                  datetime: TimeOfDay.fromDateTime(
                    DateTime.now(),
                  ),
                ),
              );
              likedMessages = messages;
            });
          },
          icon: const Icon(
            Icons.send,
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }

  ListView ListViewFouriteFalse() {
    return ListView.builder(
      itemCount: messages.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Row(
          children: [
            ChatBubble(
              chatMessage: messages[index],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _editNumber = index;
                      _selected = messages[index];
                      _editText(context);
                      // messages[index] = _selected;
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      messages.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.restore_from_trash_outlined),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  ListView ListViewFavourite() {
    return ListView.builder(
      itemCount: messages.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return messages[index].liked
            ? Row(
                children: [
                  ChatBubble(
                    chatMessage: messages[index],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(
                            () {
                              _editNumber = index;
                              _selected = messages[index];
                              _editText(context);
                              // messages[index] = _selected;
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(
                            () {
                              messages.removeAt(index);
                            },
                          );
                        },
                        icon: const Icon(Icons.restore_from_trash_outlined),
                      ),
                    ],
                  ),
                ],
              )
            : Container();
      },
    );
  }

  _editText(BuildContext context) async {
    _selected = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Edit the text'),
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController2,
                    onChanged: (value) {
                      _messageText = value;
                    },
                    decoration: kTextFieldDecoration,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        _messageController2.clear();

                        _selected.mText = _messageText;
                        messages[_editNumber] = _selected;
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ],
          elevation: 10,
        );
      },
    );

    setState(() {
      _selected = _selected;
    });
  }
}

class DefaultChat extends StatelessWidget {
  const DefaultChat({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ChatScreen widget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 350,
        height: 150,
        color: Colors.indigo,
        child: Center(
          child: Text(
            '${'This is the page where you '
                'can track everything about ' + widget.title}',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
