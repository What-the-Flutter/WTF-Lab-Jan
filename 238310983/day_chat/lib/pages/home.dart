import 'dart:ui';
import 'package:day_chat/provider/theme_provider.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userToDO;

  List chats = [];

  @override
  void initState() {
    super.initState();
    chats.addAll(['Family', 'Sport', 'Money']);
    currentTheme.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
      home: Scaffold(
        appBar: appBar(),
        extendBodyBehindAppBar: true,
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: listView()),
        floatingActionButton: floatingActionButton(),
      ),
    );
  }

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(
      child: Container(
        width: 60,
        height: 60,
        child: const Icon(Icons.add),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return alertDialog();
          },
        );
      },
    );
  }

  AlertDialog alertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.blueGrey,
      title: const Text(
        'Add New Chat',
        style: TextStyle(color: Colors.white),
      ),
      content: TextField(style: const TextStyle(color: Colors.white), onChanged: (value) => userToDO = value),
      actions: [
        ElevatedButton(
          onPressed: () {
            setState(() => chats.add(userToDO));
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.4),
              gradient: const LinearGradient(colors: [Colors.red, Colors.blue]),
            ),
          ),
        ),
      ),
      title: const Text(
        'Chat Journal',
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: <Widget>[
        IconButton(
          onPressed: () => currentTheme.toggleTheme(),
          icon: const Icon(Icons.invert_colors_sharp),
        ),
      ],
    );
  }

  Widget listView() {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(chats[index]),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(18),
              ),
              color: Colors.transparent.withOpacity(0.6),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessagesScreen(),
                ),
              ),
              title: Text(
                (chats[index]),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          onDismissed: (direction) => setState(
            () => chats.removeAt(index),
          ),
        );
      },
    );
  }
}
