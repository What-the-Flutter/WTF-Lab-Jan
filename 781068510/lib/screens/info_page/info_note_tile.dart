import 'package:flutter/material.dart';

import '../../models/note_model.dart';

class NoteTile extends StatefulWidget {
  final Function onChangedEditMode;
  final Function onChangedMultiSelection;
  final Function onSelected;
  final ValueChanged<Note> onSelectedNote;

  final Note note;

  final bool isSelected;
  final bool isEditMode;

  NoteTile({
    required this.onSelectedNote,
    required this.onSelected,
    required this.onChangedEditMode,
    required this.onChangedMultiSelection,
    required this.note,
    required this.isSelected,
    required this.isEditMode,
  });

  @override
  _NoteTile createState() => _NoteTile();
}

class _NoteTile extends State<NoteTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.isSelected ? Colors.green[100] : Colors.transparent,
      child: ListTile(
        onTap: () {
          print(widget.isEditMode);
          if (widget.isEditMode) {
            widget.onSelectedNote(widget.note);
          } else {
            print('Bookmarked');
          }
          setState(() {});
        },
        onLongPress: () {
          print(widget.isEditMode);
          widget.onSelectedNote(widget.note);
        },
        leading: const Icon(Icons.sports),
        title: Text(widget.note.description),
        subtitle: Text(widget.note.time),
        trailing: widget.isSelected
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : null,
      ),
    );
  }
}
