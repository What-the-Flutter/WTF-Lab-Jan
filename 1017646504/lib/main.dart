// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

List<String> message = <String>['First node', 'Second node', 'Third node '];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      home: Scaffold(
        body: ListView.separated(
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                // child: Text(
                //   'запись $index',
                //   textScaleFactor: 2,
                // ),
                child: TextButton.icon(
                    onPressed: () {
                      _navigateToNextScreen(context);
                    },
                    icon: const Icon(Icons.text_fields),
                    label: Text('событие $index')));
          },
          separatorBuilder: (_, __) => Container(
            height: 1,
            color: Colors.black,
          ),
          itemCount: 20,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.car_rental),
              label: 'Race',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.amber[800],
          onTap: (_) {},
        ),
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text('Flutter'),
          leading: IconButton(
            icon: const Icon(Icons.wb_sunny),
            onPressed: () {},
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text('bolt'),
          icon: const Icon(Icons.bolt),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen()));
  }
}

TextEditingController textController = TextEditingController();

class NewScreen extends StatefulWidget {
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  bool isOnEdit = false;
  int index = -1;
  final selected = <int>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Screen'),
        actions: [
          if (selected.isNotEmpty)
            IconButton(
                onPressed: () {
                  for (var i in selected.toList()..sort((a, b) => b.compareTo(a))) {
                    message.removeAt(i);
                  }
                  print(message);
                  selected.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.delete))
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: message.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return _MessageTile(
                  isSelected: selected.contains(index),
                  key: UniqueKey(),
                  onSelected: () {
                    if (selected.contains(index)) {
                      selected.remove(index);
                    } else {
                      selected.add(index);
                    }
                    setState(() {});
                  },
                  messageText: message[index],
                  onEdit: () {
                    isOnEdit = true;
                    this.index = index;
                    textController.text = message[index];
                  },
                );
              },
            ),
          ),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Enter a message',
              suffixIcon: IconButton(
                onPressed: () {
                  if (isOnEdit) {
                    message[index] = textController.text;
                    index = -1;
                    isOnEdit = false;
                  } else {
                    message.add(textController.text);
                  }
                  textController.clear();
                  setState(() {});
                },
                icon: Icon(isOnEdit ? Icons.check : Icons.send),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageTile extends StatefulWidget {
  _MessageTile({
    Key? key,
    required this.messageText,
    required this.onEdit,
    required this.onSelected,
    required this.isSelected,
  }) : super(key: key);

  final String messageText;
  final Function() onEdit;
  final Function() onSelected;
  final bool isSelected;

  @override
  __MessageTileState createState() => __MessageTileState(
        messageText: messageText,
        onEdit: onEdit,
        onSelected: onSelected,
        isSelected: isSelected,
      );
}

class __MessageTileState extends State<_MessageTile> {
  String messageText;
  Function() onEdit;
  Function() onSelected;
  bool isSelected;

  __MessageTileState({
    required this.messageText,
    required this.onEdit,
    required this.onSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onSelected();
      },
      child: Container(
        color: isSelected ? Colors.black.withOpacity(0.05) : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                messageText,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
            IconButton(onPressed: () {Clipboard.setData(ClipboardData(text: messageText));}, icon: const Icon(Icons.copy))
          ],
        ),
      ),
    );
  }
}
