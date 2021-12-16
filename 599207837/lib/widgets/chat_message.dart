import 'package:flutter/material.dart';
import '../entity/entities.dart' as entity;

class ChatMessage extends StatelessWidget {
  final entity.Message item;
  final void Function() onDeleted;
  final Function() onEdited;
  final Function() onSelection;
  final Function() onSelected;
  final bool selection;

  const ChatMessage(
      {required this.item,
      required this.onDeleted,
      required this.onEdited,
      required this.onSelection,
      required this.onSelected,
      required this.selection,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item is entity.Task) {
      return _TaskMessage(item as entity.Task);
    } else if (item is entity.Event) {
      return _EventMessage(item as entity.Event);
    } else {
      return _NoteMessage(item as entity.Note, onDeleted, onEdited, onSelection,
          onSelected, selection);
    }
  }
}

class _TaskMessage extends StatelessWidget {
  final entity.Task task;

  const _TaskMessage(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (Colors.lightGreen.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            task.description,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}

class _EventMessage extends StatelessWidget {
  final entity.Event event;

  const _EventMessage(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (Colors.cyan.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            event.description,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}

class _NoteMessage extends StatefulWidget {
  final entity.Note note;
  final Function() onDeleted;
  final Function() onEdited;
  final Function() onSelection;
  final Function() onSelected;
  final bool selection;

  const _NoteMessage(this.note, this.onDeleted, this.onEdited, this.onSelection,
      this.onSelected, this.selection);

  @override
  _NoteMessageState createState() => _NoteMessageState();
}

class _NoteMessageState extends State<_NoteMessage> {
  bool selected = false;
  bool calledSelection = false;

  @override
  void didUpdateWidget(covariant _NoteMessage oldWidget) {
    selected = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if (widget.selection)
          {
            setState(() {
              widget.onSelected();
              selected = !selected;
            })
          }
      },
      onLongPress: () {
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(100.0, 100.0, 100.0, 100.0),
          items: <PopupMenuEntry>[
            PopupMenuItem(
              onTap: widget.onDeleted,
              value: 1,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.delete),
                  const Text('Delete'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: widget.onEdited,
              value: 2,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.edit),
                  const Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () {
                widget.onSelection();
                setState(() {
                  selected = true;
                  widget.onSelected();
                });
              },
              value: 3,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.autofps_select),
                  const Text('Select'),
                ],
              ),
            ),
          ],
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.selection && selected ? (Colors.blue.shade100) : null,
        ),
        padding:
            const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Align(
          alignment: (Alignment.topLeft),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (Colors.grey.shade200),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.note.description,
              //widget.selection.toString(),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
