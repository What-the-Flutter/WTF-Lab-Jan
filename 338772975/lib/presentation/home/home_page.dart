import 'package:flutter/material.dart';

import '../../domain/entities/chat_info.dart';
import '../../widgets.dart';
import 'chat_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/';

  final List<ChatInfo> _chats = const [
    ChatInfo(title: 'Title', description: 'Description', icon: Icons.home),
    ChatInfo(title: 'Title', description: 'Description', icon: Icons.home),
    ChatInfo(title: 'Title', description: 'Description', icon: Icons.home),
    ChatInfo(title: 'Title', description: 'Description', icon: Icons.home),
    ChatInfo(title: 'Title', description: 'Description', icon: Icons.home),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: ChatList(
          chats: _chats,
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(),
      floatingActionButton: GradientFloatingActionButton(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Theme.of(context).primaryColorDark,
            Theme.of(context).primaryColor
          ],
        ),
        onPressed: () async {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
