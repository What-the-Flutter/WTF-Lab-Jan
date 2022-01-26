import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/entities.dart';
import '../main.dart';
import '../widgets/widgets.dart';
import 'items_page/items_page_cubit.dart';
import 'items_page/items_page_state.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsPageCubit, ItemsPageState>(
      builder: (context, state) {
        return Column(
          children: [
            ListView.builder(
              itemCount: state.topics.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  state.topics[index].isPinned && !state.topics[index].isArchived
                      ? _ChatCard(
                          topic: state.topics[index],
                          themeInherited: ThemeInherited.of(context)!,
                        )
                      : Container(),
            ),
            ListView.builder(
              itemCount: state.topics.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  !state.topics[index].isPinned && !state.topics[index].isArchived
                      ? _ChatCard(
                          topic: state.topics[index],
                          themeInherited: ThemeInherited.of(context)!,
                        )
                      : Container(),
            ),
          ],
        );
      },
    );
  }
}

class _ChatCard extends StatelessWidget {
  late final ThemeInherited themeInherited;
  final Topic topic;

  _ChatCard({required this.topic, required this.themeInherited});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (newContext) => ChatPage(
            topic: topic,
          ),
        ),
      ),
      onLongPress: () => showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        constraints: const BoxConstraints(maxHeight: 330),
        backgroundColor: themeInherited.preset.colors.backgroundColor,
        builder: (newContext) => _chatCardMenu(context),
        context: context,
        isDismissible: true,
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
                      topic.icon,
                      color: Colors.white,
                      size: 30,
                    ),
                    radius: 30,
                    backgroundColor: themeInherited.preset.colors.avatarColor,
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
                          Row(
                            children: [
                              Text(
                                '${topic.name} ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: themeInherited.preset.colors.textColor1,
                                ),
                              ),
                              if (topic.isPinned)
                                Icon(
                                  Icons.push_pin_rounded,
                                  size: 15,
                                  color: themeInherited.preset.colors.textColor1,
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            'widget.topic.lastMessage',
                            style: TextStyle(
                              fontSize: 13,
                              color: themeInherited.preset.colors.minorTextColor,
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
              topic.elements.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: themeInherited.preset.colors.textColor1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatCardMenu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardMenuItem(
            onTap: () {
              Navigator.pop(context);
              _showInfo(context);
            },
            label: 'Info',
            icon: Icons.info_outline_rounded,
            iconColor: Colors.teal,
            labelColor: themeInherited.preset.colors.textColor1,
          ),
          const Divider(),
          _cardMenuItem(
            onTap: () {
              Navigator.pop(context);
              context.read<ItemsPageCubit>().pinTopic(topic);
            },
            label: 'Pin/Unpin Topic',
            icon: Icons.push_pin_outlined,
            iconColor: Colors.green,
            labelColor: themeInherited.preset.colors.textColor1,
          ),
          const Divider(),
          _cardMenuItem(
            onTap: () {
              Navigator.pop(context);
              context.read<ItemsPageCubit>().archiveTopic(topic);
            },
            label: 'Archive Topic',
            icon: Icons.archive_outlined,
            iconColor: Colors.amberAccent,
            labelColor: themeInherited.preset.colors.textColor1,
          ),
          const Divider(),
          _cardMenuItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => TopicMaker(
                    topic: topic,
                  ),
                ),
              );
            },
            label: 'Edit Topic',
            icon: Icons.edit_outlined,
            iconColor: Colors.blue,
            labelColor: themeInherited.preset.colors.textColor1,
          ),
          const Divider(),
          _cardMenuItem(
            onTap: () {
              Navigator.pop(context);
              _deleteAlert(
                onDelete: () => context.read<ItemsPageCubit>().deleteTopic(topic),
                context: context,
              );
            },
            label: 'Delete Topic',
            icon: Icons.delete_outline_rounded,
            iconColor: Colors.red,
            labelColor: themeInherited.preset.colors.textColor1,
          ),
        ],
      ),
    );
  }

  void _deleteAlert({required Function onDelete, required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: themeInherited.preset.colors.backgroundColor,
          content: Text(
            'Are you sure you want to permanently delete ${topic.name}?',
            style: TextStyle(fontSize: 20, color: themeInherited.preset.colors.textColor1),
          ),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.transparent),
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeInherited.preset.colors.underlineColor,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.transparent),
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeInherited.preset.colors.underlineColor,
                  ),
                ),
                onPressed: () {
                  onDelete();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: themeInherited.preset.colors.backgroundColor,
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Icon(
                        topic.icon,
                        color: Colors.white,
                        size: 35,
                      ),
                      radius: 35,
                      backgroundColor: themeInherited.preset.colors.avatarColor,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      topic.name,
                      style:
                          TextStyle(fontSize: 20, color: themeInherited.preset.colors.textColor1),
                    ),
                  ],
                ),
                _infoNode(
                  topText: 'Message amount:',
                  bottomText: '${topic.elements}',
                ),
                if (topic.lastMessage != null)
                  _infoNode(
                    topText: 'Last message:',
                    bottomText: '${fullDateFormatter.format(topic.lastMessage!)}',
                  ),
                _infoNode(
                  topText: 'Date created:',
                  bottomText: '${fullDateFormatter.format(topic.timeCreated)}',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.transparent),
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeInherited.preset.colors.underlineColor,
                  ),
                ),
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
            style: TextStyle(color: themeInherited.preset.colors.textColor1, fontSize: 13),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            bottomText,
            style: TextStyle(color: themeInherited.preset.colors.textColor2, fontSize: 14),
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
    required Color? labelColor,
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
