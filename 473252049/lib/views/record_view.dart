import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_journal/pages/category_chat_page.dart';
import 'package:chat_journal/views/chat_view.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';

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
        child: ChatBubble(
          alignment: Alignment.centerRight,
          clipper: ChatBubbleClipper4(type: BubbleType.sendBubble),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget._record.message),
                if (widget._record.isFavorite)
                  Icon(
                    Icons.bookmark,
                    size: 10,
                  ),
              ],
            ),
          ),
          backGroundColor: widget._record.isHighlighted
              ? Theme.of(context).highlightColor
              : Theme.of(context).backgroundColor,
        ),
      ),
    );
  }
}
