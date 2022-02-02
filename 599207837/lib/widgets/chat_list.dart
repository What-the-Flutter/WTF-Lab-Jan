import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/entities.dart';
import '../widgets/widgets.dart';
import 'items_page/items_page_cubit.dart';
import 'items_page/items_page_state.dart';
import 'theme_provider/theme_cubit.dart';
import 'theme_provider/theme_state.dart';

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
  final Topic topic;

  _ChatCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
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
        backgroundColor: theme.colors.backgroundColor,
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
                    backgroundColor: theme.colors.avatarColor,
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
                                  fontSize: theme.fontSize.primary,
                                  color: theme.colors.textColor1,
                                ),
                              ),
                              if (topic.isPinned)
                                Icon(
                                  Icons.push_pin_rounded,
                                  size: 15,
                                  color: theme.colors.textColor1,
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            'widget.topic.lastMessage',
                            style: TextStyle(
                              fontSize: theme.fontSize.secondary,
                              color: theme.colors.minorTextColor,
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
                fontSize: theme.fontSize.secondary,
                fontWeight: FontWeight.normal,
                color: theme.colors.textColor1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatCardMenu(BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
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
            labelColor: theme.colors.textColor1,
            theme: theme,
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
            labelColor: theme.colors.textColor1,
            theme: theme,
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
            labelColor: theme.colors.textColor1,
            theme: theme,
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
            labelColor: theme.colors.textColor1,
            theme: theme,
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
            labelColor: theme.colors.textColor1,
            theme: theme,
          ),
        ],
      ),
    );
  }

  void _deleteAlert({required Function onDelete, required BuildContext context}) {
    final theme = context.read<ThemeCubit>().state;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colors.backgroundColor,
          content: Text(
            'Are you sure you want to permanently delete ${topic.name}?',
            style: TextStyle(fontSize: 20, color: theme.colors.textColor1),
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
                    color: theme.colors.underlineColor,
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
                    color: theme.colors.underlineColor,
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
    final theme = context.read<ThemeCubit>().state;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colors.backgroundColor,
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
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
                      backgroundColor: theme.colors.avatarColor,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      topic.name,
                      style: TextStyle(
                        fontSize: theme.fontSize.primary + 2,
                        color: theme.colors.textColor1,
                      ),
                    ),
                  ],
                ),
                _infoNode(
                  topText: 'Message amount:',
                  bottomText: '${topic.elements}',
                  theme: theme,
                ),
                if (topic.lastMessage != null)
                  _infoNode(
                    topText: 'Last message:',
                    bottomText: '${fullDateFormatter.format(topic.lastMessage!)}',
                    theme: theme,
                  ),
                _infoNode(
                  topText: 'Date created:',
                  bottomText: '${fullDateFormatter.format(topic.timeCreated)}',
                  theme: theme,
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
                    fontSize: theme.fontSize.primary,
                    color: theme.colors.underlineColor,
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

  Widget _infoNode({
    required String topText,
    required String bottomText,
    required ThemeState theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topText,
            style: TextStyle(
              color: theme.colors.textColor1,
              fontSize: theme.fontSize.secondary + 1,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            bottomText,
            style: TextStyle(
              color: theme.colors.textColor2,
              fontSize: theme.fontSize.general,
            ),
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
    required ThemeState theme,
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
              style: TextStyle(
                color: labelColor,
                fontSize: theme.fontSize.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
