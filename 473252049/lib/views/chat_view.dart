import '../model/category.dart';
import '../views/record_view.dart';

import 'package:flutter/material.dart';
import '../model/record.dart';

final chatViewStateKey = GlobalKey<_ChatViewState>();
var chatViewState = chatViewStateKey.currentState;
var chatView = chatViewState.widget;

class ChatView extends StatefulWidget {
  List<Record> records;
  bool favorites = false;

  ChatView(this.records, {Key key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        reverse: true,
        children: [
          ...widget.records.map((record) => RecordView(record)).toList()
        ],
      ),
    );
  }
}

void updateChatView() {
  chatViewState = chatViewStateKey.currentState;
  chatView = chatViewState.widget;
  chatViewState.setState(() {});
}
