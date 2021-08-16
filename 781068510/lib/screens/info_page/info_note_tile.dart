import 'package:flutter/material.dart';
import '../../models/note_model.dart';

List<_NoteTile> selectedNotes = [];

class NoteTile extends StatefulWidget {
  final Function onChangedEditMode;
  final Function onChangedMultiSelection;
  final Function onSelected;

  final Note note;

  final bool isSelected;
  final bool isEditMode;

  NoteTile({
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
  late bool isSelected;
  late String description;

  @override
  void initState() {
    super.initState();
    description = widget.note.description;
    isSelected = selectedNotes.contains(this);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.green[100] : Colors.transparent,
      child: ListTile(
        onTap: () {
          if (isSelected) {
            widget.onSelected(false);
            isSelected = false;
            selectedNotes.remove(this);
            if (selectedNotes.length <= 1) {
              widget.onChangedMultiSelection(false);
            }
            if (selectedNotes.isEmpty) {
              widget.onChangedEditMode(false);
            }
          } else {
            if (widget.isEditMode && !isSelected) {
              isSelected = true;
              widget.onSelected(true);
              selectedNotes.add(this);
              if (selectedNotes.length > 1) {
                widget.onChangedMultiSelection(true);
              }
            } else {
              print('bookmarked');
            }
          }
          print(selectedNotes);
          setState(() {});
        },
        onLongPress: () {
          if (isSelected) {
            widget.onSelected(false);
            isSelected = false;
            selectedNotes.remove(this);
          } else {
            widget.onSelected(true);
            isSelected = true;
            selectedNotes.add(this);
          }
          ;
          if (selectedNotes.isNotEmpty) {
            widget.onChangedEditMode(true);
          } else {
            widget.onChangedEditMode(false);
          }
          print(selectedNotes);
          setState(() {});
        },
        leading: const Icon(Icons.sports),
        title: Text(widget.note.description),
        subtitle: Text(widget.note.time),
        trailing: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : null,
      ),
    );
  }
}
