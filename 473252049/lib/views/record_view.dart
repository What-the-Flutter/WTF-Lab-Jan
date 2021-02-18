import 'package:chat_bubbles/bubbles/bubble_normal.dart';

import '../model/record.dart';
import 'package:flutter/material.dart';

class RecordView extends StatelessWidget {
  final Record _record;

  const RecordView(this._record);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: BubbleNormal(
        color: Theme.of(context).backgroundColor,
        isSender: true,
        text: _record.message,
      ),
    );
  }
}
