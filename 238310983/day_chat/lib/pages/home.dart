import 'dart:ui';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent.withOpacity(0.3),
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
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.invert_colors_sharp),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
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
                  gradient: const LinearGradient(colors: [Colors.red, Colors.blue]),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.blueGrey,
                title: const Text(
                  'Add New Chat',
                  style: TextStyle(color: Colors.white),
                ),
                content: TextField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    userToDO = value;
                  },
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(
                        () => chats.add(userToDO),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
