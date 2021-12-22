import 'package:flutter/material.dart';
import 'chat_screen/chat_screen.dart';

import 'custom_bottom_navigation_bar.dart';
import 'main_list_elements/main_list.dart';

void main() => runApp(ChatScreen());

class MyApp extends StatelessWidget {
  PreferredSizeWidget _customAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      title: const Center(
        child: Text('Home'),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          tooltip: 'Switch Theme',
          icon: const Icon(
            Icons.invert_colors_on,
            color: Colors.white,
            size: 28,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25),
        )
      ],
    );
  }

  Widget _customFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: 'New Page',
      child: const Icon(Icons.add),
      backgroundColor: const Color.fromRGBO(254, 215, 65, 1),
      foregroundColor: Colors.black,
      splashColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Journal',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[700],
          foregroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: _customAppBar(),
        body: MainList(),
        floatingActionButton: _customFloatingActionButton(),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
