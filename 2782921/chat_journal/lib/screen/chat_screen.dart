import 'package:flutter/material.dart';
import "consts.dart";
import 'package:chat_journal/model/data.dart';
import 'package:chat_journal/components/buble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.title}) : super(key: key);

  final title;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? messageText;
  final messageController = TextEditingController();

  List<MessageData> messages = [];
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
              child: firstMessage
                  ? Container(
                      child: ListView.builder(
                        itemCount: messages.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return messages[index].deleted
                              ? Container()
                              : ChatBubble(
                                  chatMessage: messages[index],
                                );
                        },
                      ),
                    )
                  : Center(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: 350,
                        height: 150,
                        color: Colors.indigo[100],
                        child: Center(
                          child: Text(
                            '${'This is the page where you '
                                'can track everything about ' + widget.title}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
            ),
            Row(
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
                    controller: messageController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: kTextFieldDecoration,
                    validator: (text) {
                      if (text == '')
                        return 'Enter a word';
                      else if (text == null)
                        return 'Enter a word';
                      else
                        print("Error");
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      firstMessage = true;

                      messageController.clear();

                      messages.add(
                        MessageData(
                          mText: messageText!,
                          datetime: TimeOfDay.fromDateTime(
                            DateTime.now(),
                          ),
                        ),
                      );
                      messageText = null;
                    });
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
