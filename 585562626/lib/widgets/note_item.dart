import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../utils/constants.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final Category? category;
  final bool isEditingMode;
  final bool isSelected;
  final bool isStarred;
  final Function(Note)? onTap;
  final Function(Note)? onLongPress;
  final Function(Note)? onTimeTap;
  late final AlignDirection defaultDirection;

  NoteItem({
    Key? key,
    required this.note,
    this.category,
    this.isEditingMode = false,
    this.isSelected = false,
    this.isStarred = false,
    this.onTap,
    this.onLongPress,
    this.onTimeTap,
    bool originDirection = true,
  })  : defaultDirection = originDirection ? AlignDirection.right : AlignDirection.left,
        super(key: key);

  Widget _contentContainer(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category != null)
          Text(
            category!.name!,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        if (note.image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(CornerRadius.card),
            child: Image.file(
              File(note.image!),
              fit: BoxFit.fitHeight,
            ),
          ),
        HashTagText(
          text: note.text ?? '',
          basicStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: note.direction == defaultDirection
                    ? Theme.of(context).accentIconTheme.color
                    : null,
              ),
          decoratedStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: note.direction == defaultDirection
                    ? Colors.white70
                    : Theme.of(context).accentColor,
              ),
        ),
      ],
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.medium, vertical: Insets.xmedium),
      decoration: BoxDecoration(
        color: note.direction == defaultDirection
            ? Theme.of(context).accentColor
            : Colors.grey.withAlpha(Alpha.alpha50),
        borderRadius: note.direction == defaultDirection
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
    return GestureDetector(
      onTap: () => onTimeTap?.call(note),
      child: Container(
        padding: const EdgeInsets.only(top: Insets.xsmall),
        child: Text(
          DateFormat.jm().format(note.created),
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }

  Widget _noteContainer(BuildContext context) {
    return Container(
      margin: note.direction == defaultDirection
          ? const EdgeInsets.fromLTRB(Insets.large * 2, Insets.small, Insets.small, Insets.small)
          : const EdgeInsets.fromLTRB(Insets.small, Insets.small, Insets.large * 2, Insets.small),
      child: Row(
        mainAxisAlignment:
            note.direction == defaultDirection ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isStarred && note.direction == defaultDirection)
            const Padding(
              padding: EdgeInsets.only(right: Insets.small),
              child: Icon(Icons.star_outlined, color: Colors.amber),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: note.direction == defaultDirection
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [_contentContainer(context), _timeContainer(context)],
            ),
          ),
          if (isStarred &&
              note.direction ==
                  (defaultDirection == AlignDirection.right
                      ? AlignDirection.left
                      : AlignDirection.right))
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
