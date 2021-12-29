import 'package:flutter/material.dart';
import '../entity/entities.dart' as entity;

import '../main.dart';
import 'chat.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key, required this.topics}) : super(key: key);

  final List<entity.Topic> topics;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late List<entity.Topic> _topics;

  @override
  void initState() {
    _topics = widget.topics;
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
  late ThemeDecorator decorator;

  @override
  Widget build(BuildContext context) {
    decorator = ThemeDecorator.of(context)!;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (newContext) => ChatPage(widget.topic, context),
        ),
      ),
      onLongPress: () => showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        constraints: const BoxConstraints(maxHeight: 330),
        backgroundColor: decorator.theme.backgroundColor,
        builder: (context) {
          return _chatCardMenu();
        },
        context: context,
        isDismissible: true,
        //isScrollControlled: //boolean if something does not display, try that
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    child: Icon(
                      widget.topic.icon,
                      color: Colors.white,
                      size: 30,
                    ),
                    radius: 30,
                    backgroundColor: decorator.theme.avatarColor1,
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
                            style: TextStyle(fontSize: 16, color: decorator.theme.textColor1),
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
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: decorator.theme.textColor1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatCardMenu() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardMenuItem(
            onTap: () {
              Navigator.pop(context);
              _showInfo();
            },
            label: 'Info',
            icon: Icons.info_outline_rounded,
            iconColor: Colors.teal,
            labelColor: decorator.theme.textColor1,
          ),
          const Divider(),
          _cardMenuItem(
            onTap: () => Navigator.pop(context),
            label: 'Pin/Unpin Topic',
            icon: Icons.push_pin_outlined,
            iconColor: Colors.green,
            labelColor: decorator.theme.textColor1,
          ),
          const Divider(),
          _cardMenuItem(
            onTap: () => Navigator.pop(context),
            label: 'Archive Topic',
            icon: Icons.archive_outlined,
            iconColor: Colors.amberAccent,
            labelColor: decorator.theme.textColor1,
          ),
          const Divider(),
          _cardMenuItem(
            onTap: () => Navigator.pop(context),
            label: 'Edit Topic',
            icon: Icons.edit_outlined,
            iconColor: Colors.blue,
            labelColor: decorator.theme.textColor1,
          ),
          const Divider(),
          _cardMenuItem(
            onTap: () {
              Navigator.pop(context);
              widget.topic.delete();
              TabContrDecorator.of(context)!.onEdited();
            },
            label: 'Delete Topic',
            icon: Icons.delete_outline_rounded,
            iconColor: Colors.red,
            labelColor: decorator.theme.textColor1,
          ),
        ],
      ),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: decorator.theme.backgroundColor,
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Icon(
                        widget.topic.icon,
                        color: Colors.white,
                        size: 35,
                      ),
                      radius: 35,
                      backgroundColor: decorator.theme.avatarColor1,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.topic.name,
                      style: TextStyle(fontSize: 20, color: decorator.theme.textColor1),
                    ),
                  ],
                ),
                _infoNode(
                  topText: 'Message amount:',
                  bottomText: '${widget.topic.elements}',
                ),
                _infoNode(
                  topText: 'Last message:',
                  bottomText: '${entity.fullDateFormatter.format(widget.topic.getElements()[0].timeCreated)}',
                ),
                _infoNode(
                  topText: 'Date created:',
                  bottomText: '${entity.fullDateFormatter.format(widget.topic.timeCreated)}',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.transparent),
                child: Text('Ok', style: TextStyle(fontSize: 18, color: decorator.theme.underlineColor)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _infoNode({required String topText, required String bottomText}) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topText,
            style: TextStyle(color: decorator.theme.textColor1, fontSize: 13),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            bottomText,
            style: TextStyle(color: decorator.theme.textColor2, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _cardMenuItem({
    required String label,
    required GestureTapCallback onTap,
    required IconData icon,
    required Color iconColor,
    required Color labelColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              color: iconColor,
              size: 25,
            ),
            const SizedBox(
              width: 25,
            ),
            Text(
              label,
              style: TextStyle(color: labelColor, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
