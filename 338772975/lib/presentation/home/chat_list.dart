import 'package:flutter/material.dart';

import '../../domain/entities/chat_info.dart';
import '../../widgets.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    Key? key,
    this.chats,
    this.onTap,
  }) : super(key: key);

  final List<ChatInfo>? chats;
  final void Function(int index, ChatInfo info)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: chats?.length ?? 0,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: _buildChatItem,
    );
  }

  Widget _buildChatItem(BuildContext context, int index) {
    final chat = chats![index];
    return ListTile(
      leading: GradientCircleAvatar(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Theme.of(context).primaryColorDark,
            Theme.of(context).primaryColor,
          ],
        ),
        child: Icon(chat.icon),
      ),
      title: Text(chat.title),
      subtitle: Text(chat.description),
      onTap: () => onTap != null ? onTap!(index, chat) : null,
      onLongPress: () => _showBottomSheetDialog(context),
    );
  }

  void _showBottomSheetDialog(BuildContext context) {
    showModalBottomSheet<Widget>(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.push_pin),
              title: const Text('Pin/Unpin'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }
}
