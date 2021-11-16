import 'package:flutter/material.dart';
import 'package:chat_journal/model/data.dart';
import 'package:flutter/services.dart';

class ChatBubble extends StatefulWidget {
  MessageData chatMessage;
  ChatBubble({required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.indigo.shade200,
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onLongPress: () {
                        setState(() {
                          Clipboard.setData(
                            ClipboardData(text: widget.chatMessage.mText),
                          );
                        });
                      },
                      onPressed: () {},
                      child: Text(
                        widget.chatMessage.mText,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      widget.chatMessage.datetime.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.chatMessage.liked = !widget.chatMessage.liked;
              });
            },
            icon: widget.chatMessage.liked
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.chatMessage.deleted = true;
              });
            },
            icon: const Icon(Icons.restore_from_trash_outlined),
          ),
        ],
      ),
    );
  }
}
