import 'package:chat_journal/model/category.dart';
import 'package:chat_journal/model/record.dart';
import 'package:chat_journal/views/chat_view.dart';
import 'package:chat_journal/views/create_message_view.dart';
import 'package:chat_journal/views/record_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

final categoryChatPageStateKey = GlobalKey<_CategoryChatPageState>();
var categoryChatPageState = categoryChatPageStateKey.currentState;
var categoryChatPage = categoryChatPageState.widget;

var onlyFavoritesAreShowing = false;

class CategoryChatPage extends StatefulWidget {
  final Category category;

  bool get hasHighlightedRecord => category.highlightedRecords.isNotEmpty;

  bool get hasNotHighlightedRecord => !hasHighlightedRecord;

  CategoryChatPage(this.category, {Key key}) : super(key: key);

  @override
  _CategoryChatPageState createState() => _CategoryChatPageState();
}

class _CategoryChatPageState extends State<CategoryChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hasNotHighlightedRecord
          ? defaultAppBar(widget.category.name)
          : recordIsActiveAppBar(),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          CreateMessageView(key: createMessageViewStateKey),
          ChatView(widget.category.records, key: chatViewStateKey),
        ],
      ),
    );
  }
}

void updateCategoryChatPage() {
  categoryChatPageState = categoryChatPageStateKey.currentState;
  categoryChatPage = categoryChatPageState.widget;
  categoryChatPageState.setState(() {});
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
        categoryChatPage.category.unhighlight();
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
      onPressed: () {
        onlyFavoritesAreShowing = !onlyFavoritesAreShowing;
        chatViewStateKey.currentState.setState(() {
          if (onlyFavoritesAreShowing) {
            chatViewStateKey.currentState.widget.records =
                categoryChatPage.category.records;
          } else {
            chatViewStateKey.currentState.widget.records =
                categoryChatPage.category.favoritesRecords;
          }
        });
      },
    ),
  ];
}

List<Widget> recordIsActiveActions() {
  return [
    IconButton(icon: Icon(Icons.reply), onPressed: () {}),
    if (categoryChatPage.category.highlightedRecords.length < 2)
      IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            textFieldController.value = TextEditingValue(
                text:
                    categoryChatPage.category.highlightedRecords.first.message);
            createMessageViewStateKey.currentState.isEditing = true;
          }),
    IconButton(
        icon: Icon(Icons.copy),
        onPressed: () {
          copyRecordsToClipboard(categoryChatPage.category.highlightedRecords);
          categoryChatPage.category.unhighlight();
          updateCategoryChatPage();
          showCopiedToClipboardSnackBar();
        }),
    IconButton(
        icon: Icon(Icons.bookmark_border),
        onPressed: () {
          categoryChatPage.category.changeHighlightedIsFavorite();
          categoryChatPage.category.unhighlight();
          updateCategoryChatPage();
        }),
    IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          categoryChatPage.category.removeHighlighted();
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
