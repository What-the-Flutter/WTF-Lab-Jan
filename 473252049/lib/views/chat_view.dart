import '../model/category.dart';
import '../views/record_view.dart';

import 'package:flutter/material.dart';

final chatViewStateKey = GlobalKey<_ChatViewState>();

class ChatView extends StatefulWidget {
  final Category category;

  ChatView(this.category, {Key key}) : super(key: key);

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
          ...widget.category.records
              .map((record) => RecordView(record))
              .toList()
        ],
      ),
    );
  }
}
