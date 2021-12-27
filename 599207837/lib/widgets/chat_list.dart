import 'package:flutter/material.dart';
import '../entity/entities.dart' as entity;

import 'chat.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  List<entity.Topic> _loadTopics() => entity.topics.values.toList();

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late List<entity.Topic> _topics;

  @override
  void initState() {
    _topics = widget._loadTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _topics.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => ChatCard(
        topic: _topics[index],
      ),
    );
  }
}

class ChatCard extends StatefulWidget {
  final entity.Topic topic;

  ChatCard({required this.topic});

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(widget.topic),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: widget.topic.getImageProvider(),
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.topic.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            'widget.topic.lastMessage',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.topic.elements.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
