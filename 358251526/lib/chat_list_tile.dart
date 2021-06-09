import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon icon;
  final void Function()? onTap;

  const ChatListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: CircleAvatar(foregroundColor: Colors.blueGrey, child: icon),
      onTap: onTap,
    );
  }
}
