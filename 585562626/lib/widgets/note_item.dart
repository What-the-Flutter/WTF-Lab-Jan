import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';
import '../utils/constants.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final bool isEditingMode;
  final bool isSelected;
  final bool isStarred;
  final Function(Note)? onTap;
  final Function(Note)? onLongPress;

  NoteItem({
    Key? key,
    required this.note,
    this.isEditingMode = false,
    this.isSelected = false,
    this.isStarred = false,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  Widget _contentContainer(BuildContext context) {
    final content = Column(
      crossAxisAlignment: note.direction == AlignDirection.right ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        if (note.image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(CornerRadius.card),
            child: Image.file(
              File(note.image!),
              fit: BoxFit.fitHeight,
            ),
          ),
        Text(
          note.text ?? '',
          style: TextStyle(
            fontSize: FontSize.normal,
            color: note.direction == AlignDirection.right
                ? Theme.of(context).accentIconTheme.color
                : null,
          ),
        ),
      ],
    );
    return Container(
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
      child: content,
    );
  }

  Widget _timeContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: Insets.xsmall),
      child: Text(
        DateFormat.jm().format(note.created),
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }

  Widget _noteContainer(BuildContext context) {
    return Container(
      margin: note.direction == AlignDirection.right
          ? const EdgeInsets.fromLTRB(Insets.large * 2, Insets.small, Insets.small, Insets.small)
          : const EdgeInsets.fromLTRB(Insets.small, Insets.small, Insets.large * 2, Insets.small),
      child: Row(
        mainAxisAlignment: note.direction == AlignDirection.right
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isStarred && note.direction == AlignDirection.right)
            const Padding(
              padding: EdgeInsets.only(right: Insets.small),
              child: Icon(Icons.star_outlined, color: Colors.amber),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: note.direction == AlignDirection.right
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [_contentContainer(context), _timeContainer(context)],
            ),
          ),
          if (isStarred && note.direction == AlignDirection.left)
            const Padding(
              padding: EdgeInsets.only(left: Insets.small),
              child: Icon(Icons.star_outlined, color: Colors.amber),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => onLongPress?.call(note),
      onTap: () => onTap?.call(note),
      child: Container(
        color: isSelected
            ? Theme.of(context).accentColor.withAlpha(Alpha.alpha20)
            : Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            if (isEditingMode)
              IconButton(
                onPressed: () => onTap?.call(note),
                icon: isSelected
                    ? const Icon(Icons.check_circle_outline)
                    : const Icon(Icons.circle_outlined),
              ),
            Flexible(child: _noteContainer(context)),
          ],
        ),
      ),
    );
  }
}