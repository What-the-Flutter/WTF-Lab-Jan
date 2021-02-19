import 'package:chat_journal/model/category.dart';
import 'package:chat_journal/views/chat_view.dart';
import 'package:chat_journal/views/create_message_view.dart';
import 'package:chat_journal/views/record_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final categoryChatPageKey = GlobalKey<_CategoryChatPageState>();

class CategoryChatPage extends StatefulWidget {
  final Category _category;

  bool get isRecordHighlighted =>
      _category.records.where((r) => r.isHighlighted == true).isNotEmpty;

  bool get isNotRecordHighlighted => !isRecordHighlighted;

  const CategoryChatPage(this._category, {Key key}) : super(key: key);

  @override
  _CategoryChatPageState createState() => _CategoryChatPageState();
}

class _CategoryChatPageState extends State<CategoryChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isNotRecordHighlighted
          ? defaultAppBar(widget._category.name)
          : recordIsActiveAppBar(() {
              setState(() {
                for (var record in widget._category.records) {
                  record.isHighlighted = false;
                }
              });
            }),
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
