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
  final Function(BaseNote)? changeSelection;
  final Function? activateEditingMode;

  NoteItem({
    Key? key,
    required this.note,
    required this.isEditingMode,
    this.isSelected = false,
    this.changeSelection,
    this.activateEditingMode,
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
      margin: note.direction == AlignDirection.right
          ? const EdgeInsets.fromLTRB(Insets.large * 2, Insets.small, Insets.small, Insets.small)
          : const EdgeInsets.fromLTRB(Insets.small, Insets.small, Insets.large * 2, Insets.small),
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
    return GestureDetector(
      onLongPress: () => activateEditingMode?.call(),
      onTap: () => changeSelection?.call(note),
      child: Container(
        color: isSelected ? Theme.of(context).accentColor.withAlpha(Alpha.alpha20) : Colors.white24,
        child: Row(
          children: [
            if (isEditingMode)
              IconButton(
                onPressed: () => changeSelection?.call(note),
                icon: isSelected
                    ? const Icon(Icons.check_circle_outline)
                    : const Icon(Icons.circle_outlined),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: note.direction == AlignDirection.right
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [_contentContainer(context), _timeContainer()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
