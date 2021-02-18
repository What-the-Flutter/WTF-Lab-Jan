import 'package:chat_journal/model/category.dart';
import 'package:chat_journal/views/chat_view.dart';
import 'package:chat_journal/views/create_message_view.dart';
import 'package:chat_journal/views/record_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final categoryChatPageKey = GlobalKey<_CategoryChatPageState>();

class CategoryChatPage extends StatefulWidget {
  final Category _category;

  const CategoryChatPage(this._category, {Key key}) : super(key: key);

  @override
  _CategoryChatPageState createState() => _CategoryChatPageState();
}

class _CategoryChatPageState extends State<CategoryChatPage> {
  bool get isRecordHighlighted =>
      widget._category.records.where((r) => r.isHighlighted == true).isNotEmpty;

  bool get isNotRecordHighlighted => !isRecordHighlighted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isNotRecordHighlighted
          ? defaultAppBar(widget._category.name)
          : recordIsActiveAppBar(() {}),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          CreateMessageView(),
          ChatView(widget._category, key: chatViewStateKey),
        ],
      ),
    );
  }
}

AppBar defaultAppBar(String categoryName) {
  return AppBar(
    title: Text(categoryName),
    actions: defaultActions(),
  );
}

AppBar recordIsActiveAppBar(void Function() onCloseTap) {
  return AppBar(
    actions: recordIsActiveActions(),
    leading: IconButton(
      icon: Icon(Icons.close),
      onPressed: onCloseTap,
    ),
  );
}

List<Widget> defaultActions() {
  return [
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.bookmark_outline),
      onPressed: () {},
    ),
  ];
}

List<Widget> recordIsActiveActions() {
  return [
    IconButton(icon: Icon(Icons.reply), onPressed: () {}),
    IconButton(icon: Icon(Icons.copy), onPressed: () {}),
    IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
    IconButton(icon: Icon(Icons.delete), onPressed: () {}),
  ];
}
