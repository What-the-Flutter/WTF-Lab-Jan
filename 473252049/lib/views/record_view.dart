import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';

import '../model/record.dart';
import 'package:flutter/material.dart';

class RecordView extends StatelessWidget {
  final Record _record;

  const RecordView(this._record);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ChatBubble(
        backGroundColor: Theme.of(context).backgroundColor,
        clipper: ChatBubbleClipper3(
          type: BubbleType.sendBubble,
        ),
        child: Text(_record.message),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
