import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon icon;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const ChatListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.subtitle,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: CircleAvatar(foregroundColor: Colors.black54, child: icon),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
