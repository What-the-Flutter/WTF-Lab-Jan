import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'event.dart';
import 'main.dart';

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String eventMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(messages[index].messageEvent),
                    trailing: SizedBox(
                      height: 90,
                      width: 90,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: FloatingActionButton(
                              backgroundColor: colorMain,
                              child: Icon(
                                Icons.chat,
                                size: 15,
                              ),
                              onPressed: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Input new name of event'),
                                        content: TextField(
                                          onChanged: (text) {
                                            eventMessage = text;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Write event...',
                                            hintStyle: TextStyle(
                                                color: Colors.black54),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                messages[index].messageEvent =
                                                    eventMessage;
                                              });
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: FloatingActionButton(
                              backgroundColor: colorMain,
                              child: Icon(
                                Icons.copy,
                                size: 15,
                              ),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: messages[index].messageEvent));
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: FloatingActionButton(
                              backgroundColor: colorMain,
                              child: Icon(
                                Icons.delete,
                                size: 15,
                              ),
                              onPressed: () {
                                setState(() {
                                  messages.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black87,
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        eventMessage = text;
                      },
                      decoration: InputDecoration(
                          hintText: 'Write event...',
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        messages.add(ChatEvent(messageEvent: eventMessage));
                      });
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: colorMain,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
