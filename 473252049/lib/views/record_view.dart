import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_journal/pages/category_chat_page.dart';

import '../model/record.dart';
import 'package:flutter/material.dart';

class RecordView extends StatefulWidget {
  final Record _record;

  const RecordView(this._record);

  @override
  _RecordViewState createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            widget._record.isHighlighted = true;
          });
          updateCategoryChatPage();
        },
        onTap: () {
          setState(() {
            if (widget._record.isHighlighted) {
              widget._record.isHighlighted = false;
            } else if (categoryChatPage.hasHighlightedRecord) {
              widget._record.isHighlighted = true;
            }
          });
          updateCategoryChatPage();
        },
        child: BubbleNormal(
          color: widget._record.isHighlighted == true
              ? Theme.of(context).highlightColor
              : Theme.of(context).backgroundColor,
          isSender: true,
          text: widget._record.message,
        ),
      ),
    );
  }
}

void updateCategoryChatPage() {
  categoryChatPageState = categoryChatPageKey.currentState;
  categoryChatPage = categoryChatPageState.widget;
  categoryChatPageState.setState(() {});
}
