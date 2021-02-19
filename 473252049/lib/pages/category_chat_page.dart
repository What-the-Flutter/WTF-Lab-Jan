import 'package:chat_journal/model/category.dart';
import 'package:chat_journal/model/record.dart';
import 'package:chat_journal/views/chat_view.dart';
import 'package:chat_journal/views/create_message_view.dart';
import 'package:chat_journal/views/record_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

final categoryChatPageKey = GlobalKey<_CategoryChatPageState>();
var categoryChatPageState = categoryChatPageKey.currentState;
var categoryChatPage = categoryChatPageState.widget;

class CategoryChatPage extends StatefulWidget {
  final Category _category;

  bool get hasHighlightedRecord => _category.highlightedRecords.isNotEmpty;

  bool get hasNotHighlightedRecord => !hasHighlightedRecord;

  const CategoryChatPage(this._category, {Key key}) : super(key: key);

  @override
  _CategoryChatPageState createState() => _CategoryChatPageState();
}

class _CategoryChatPageState extends State<CategoryChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hasNotHighlightedRecord
          ? defaultAppBar(widget._category.name)
          : recordIsActiveAppBar(),
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

AppBar recordIsActiveAppBar() {
  return AppBar(
    actions: recordIsActiveActions(),
    leading: IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        categoryChatPageState.setState(() {
          categoryChatPage._category.unhighlight();
        });
        updateCategoryChatPage();
      },
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
    IconButton(
        icon: Icon(Icons.copy),
        onPressed: () {
          copyRecordsToClipboard(categoryChatPage._category.highlightedRecords);
          categoryChatPage._category.unhighlight();
          updateCategoryChatPage();
          showCopiedToClipboardSnackBar();
        }),
    IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
    IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          categoryChatPage._category.removeHighlighted();
          updateCategoryChatPage();
        }),
  ];
}

void copyRecordsToClipboard(List<Record> records) {
  var buffer = StringBuffer();
  buffer.writeAll(records.map((r) => r.message).toList().reversed, '\n');
  Clipboard.setData(ClipboardData(text: buffer.toString()));
}

void showCopiedToClipboardSnackBar() {
  Scaffold.of(chatViewStateKey.currentContext).showSnackBar(SnackBar(
    content: Text('Added to clipboard'),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(label: 'OK', onPressed: () {}),
  ));
}
