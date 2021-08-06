import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../models/note.dart';

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
    if (data is TextNote) {
      content = Text(data.text,
          style: TextStyle(
            fontSize: FontSize.normal,
            color: note.direction == AlignDirection.right ? Colors.white : Colors.black87,
          ));
      padding = const EdgeInsets.symmetric(horizontal: Insets.medium, vertical: Insets.xmedium);
    }
    if (data is ImageNote) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(CornerRadius.card),
        child: Image.file(
          File(data.image),
          fit: BoxFit.fitHeight,
        ),
      );
      padding = const EdgeInsets.all(Insets.xsmall);
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

  Widget _timeContainer() {
    return Container(
      padding: const EdgeInsets.only(top: Insets.xsmall),
      child: Text(
        DateFormat.jm().format(note.created),
        style: const TextStyle(fontSize: FontSize.small, color: Colors.black38),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => onLongPress?.call(note),
      onTap: () => onTap?.call(note),
      child: Container(
        color: isSelected ? Theme.of(context).accentColor.withAlpha(Alpha.alpha20) : Colors.white24,
        child: Row(
          children: [
            if (isEditingMode)
              IconButton(
                onPressed: () => onTap?.call(note),
                icon: isSelected
                    ? const Icon(Icons.check_circle_outline)
                    : const Icon(Icons.circle_outlined),
              ),
            Flexible(
              child: Container(
                margin: note.direction == AlignDirection.right
                    ? const EdgeInsets.fromLTRB(
                        Insets.large * 2, Insets.small, Insets.small, Insets.small)
                    : const EdgeInsets.fromLTRB(
                        Insets.small, Insets.small, Insets.large * 2, Insets.small),
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
                        children: [_contentContainer(context), _timeContainer()],
                      ),
                    ),
                    if (isStarred && note.direction == AlignDirection.left)
                      const Padding(
                        padding: EdgeInsets.only(left: Insets.small),
                        child: Icon(Icons.star_outlined, color: Colors.amber),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
