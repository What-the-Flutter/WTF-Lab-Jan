import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';
import '../utils/constants.dart';

class NoteItem extends StatelessWidget {
  final BaseNote note;
  final bool isEditingMode;
  final bool isSelected;
  final bool isStarred;
  final Function(BaseNote)? onTap;
  final Function(BaseNote)? onLongPress;

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
    var content;
    var padding;
    var data = note;
    switch (data.runtimeType) {
      case TextNote:
        content = Text(
          (data as TextNote).text,
          style: TextStyle(
            fontSize: FontSize.normal,
            color: note.direction == AlignDirection.right
                ? Theme.of(context).accentIconTheme.color
                : null,
          ),
        );
        padding = const EdgeInsets.symmetric(horizontal: Insets.medium, vertical: Insets.xmedium);
        break;
      case ImageNote:
        content = ClipRRect(
          borderRadius: BorderRadius.circular(CornerRadius.card),
          child: Image.file(
            File((data as ImageNote).image),
            fit: BoxFit.fitHeight,
          ),
        );
        padding = const EdgeInsets.all(Insets.xsmall);
        break;
    }
    return Container(
      padding: padding,
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
