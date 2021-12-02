import 'package:chat_journal/entity/category_page.dart';
import 'package:chat_journal/home_screen/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/message_data.dart';

class ChatBubble extends StatefulWidget {
  //final
  int index;
  int messageIndex;
  MessageData chatMessage;
  ChatBubble(
      {required this.chatMessage,
      required this.index,
      required this.messageIndex});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, List<CategoryPage>>(
      builder: (_, state) => Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: 10,
        ),
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
                padding: const EdgeInsets.all(16),
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
                          widget.chatMessage.mText ?? 'NO MESSAGE',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        widget.chatMessage.datetime.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
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
}
