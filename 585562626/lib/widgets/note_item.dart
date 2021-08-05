import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../models/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;

  const NoteItem({Key? key, required this.note}) : super(key: key);

  Widget _textContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Insets.small),
      padding: const EdgeInsets.symmetric(horizontal: Insets.medium, vertical: Insets.xmedium),
      decoration: BoxDecoration(
        color: note.direction == AlignDirection.right
            ? Theme.of(context).accentColor
            : Colors.grey.withAlpha(Alpha.alpha50),
        borderRadius: note.direction == AlignDirection.right
            ? const BorderRadius.only(
                topLeft: Radius.circular(CornerRadius.card),
                topRight: Radius.circular(CornerRadius.card),
                bottomLeft: Radius.circular(CornerRadius.card),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(CornerRadius.card),
                topRight: Radius.circular(CornerRadius.card),
                bottomRight: Radius.circular(CornerRadius.card),
              ),
      ),
      child: Text(
        note.text,
        style: TextStyle(
          fontSize: FontSize.normal,
          color: note.direction == AlignDirection.right ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _timeContainer() {
    return Container(
      margin: const EdgeInsets.only(
        left: Insets.small,
        right: Insets.small,
        bottom: Insets.xmedium,
      ),
      child: Text(
        DateFormat.jm().format(note.created),
        style: const TextStyle(fontSize: FontSize.small, color: Colors.black38),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: note.direction == AlignDirection.right
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [_textContainer(context), _timeContainer()],
    );
  }
}
