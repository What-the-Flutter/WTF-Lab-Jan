import '../model/category.dart';
import '../views/record_view.dart';

import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  final Category _category;

  ChatView(this._category);

  @override
  _ChatViewState createState() => _ChatViewState(_category);
}

class _ChatViewState extends State<ChatView> {
  Category _category;

  _ChatViewState(this._category);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        reverse: true,
        children: [
          ..._category.records.map((record) => RecordView(record)).toList()
        ],
      ),
    );
  }
}
