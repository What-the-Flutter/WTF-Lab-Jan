import 'package:chat_journal/model/category.dart';
import 'package:chat_journal/views/chat_view.dart';
import 'package:chat_journal/views/create_message_view.dart';
import 'package:chat_journal/views/record_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CategoryChatPage extends StatelessWidget {
  final Category _category;

  const CategoryChatPage(this._category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_category.name),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.bookmark_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          CreateMessageView(),
          ChatView(_category, key: chatViewStateKey),
        ],
      ),
    );
  }
}
