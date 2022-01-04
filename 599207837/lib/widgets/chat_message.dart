import 'package:flutter/material.dart';
import '../entity/entities.dart' as entity;
import '../main.dart';

class ChatMessage extends StatefulWidget {
  final entity.Message item;
  final void Function() onDeleted;
  final Function() onEdited;
  final Function() onSelection;
  final Function() onSelected;
  final bool selection;
  final ThemeInherited themeInherited;

  const ChatMessage({
    required this.item,
    required this.onDeleted,
    required this.onEdited,
    required this.onSelection,
    required this.onSelected,
    required this.selection,
    required this.themeInherited,
  });

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  bool _selected = false;
  bool _calledSelection = false;
  late IconData _favIcon;
  late Color _favColor;

  @override
  void initState() {
    _favIcon = widget.item.favourite ? Icons.star_rounded : Icons.star_border_rounded;
    _favColor = widget.item.favourite ? Colors.amberAccent : const Color.fromARGB(255, 66, 66, 66);
    super.initState();
  }

  void _onFavourite() {
    widget.item.onFavourite();
    if (widget.item.favourite) {
      entity.MessageLoader.addToFavourites(widget.item);
    } else {
      entity.MessageLoader.removeFromFavourites(widget.item);
    }
    setState(() {
      _favIcon = widget.item.favourite ? Icons.star_rounded : Icons.star_border_rounded;
      _favColor =
          widget.item.favourite ? Colors.amberAccent : const Color.fromARGB(255, 66, 66, 66);
    });
  }

  @override
  void didUpdateWidget(covariant ChatMessage oldWidget) {
    _favIcon = widget.item.favourite ? Icons.star_rounded : Icons.star_border_rounded;
    _favColor = widget.item.favourite ? Colors.amberAccent : const Color.fromARGB(255, 66, 66, 66);
    _selected = _calledSelection;
    _calledSelection = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item is entity.Task) {
      return _taskMessage(widget.item as entity.Task);
    } else if (widget.item is entity.Event) {
      return _eventMessage(widget.item as entity.Event);
    } else {
      return _noteMessage(widget.item as entity.Note);
    }
  }

  Widget _taskMessage(entity.Task task) {
    return GestureDetector(
      onTap: () {
        if (widget.selection) {
          setState(() {
            widget.onSelected();
            _selected = !_selected;
          });
        }
      },
      onLongPress: _showMenu,
      child: Container(
        decoration: BoxDecoration(
          color: widget.selection && _selected ? (Colors.blue.shade100) : null,
        ),
        padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.themeInherited.preset.colors.chatTaskColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    task.description,
                    style: TextStyle(
                        fontSize: 15, color: widget.themeInherited.preset.colors.textColor2),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: _taskMessageFooter(task),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(_favIcon),
              onPressed: _onFavourite,
              color: _favColor,
              iconSize: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskMessageFooter(entity.Task task) {
    if (!task.isCompleted) {
      return Row(
        children: [
          TextButton(
            child: Text(
              'Complete',
              style: TextStyle(color: widget.themeInherited.preset.colors.blueTextColor),
            ),
            onPressed: () {
              setState(() => task.complete());
              task.timeCompleted = DateTime.now();
            },
          ),
          Text(
            entity.timeFormatter.format(task.timeCreated),
            style: TextStyle(fontSize: 15, color: widget.themeInherited.preset.colors.textColor1),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Completed on:',
            style: TextStyle(
              color: widget.themeInherited.preset.colors.blueTextColor,
              fontSize: 12,
            ),
          ),
          Text(
            '${entity.fullDateFormatter.format(task.timeCompleted!)}',
            style: TextStyle(
              color: widget.themeInherited.preset.colors.blueTextColor,
              fontSize: 13,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              entity.timeFormatter.format(task.timeCreated),
              style: TextStyle(fontSize: 15, color: widget.themeInherited.preset.colors.textColor1),
            ),
          ),
        ],
      );
    }
  }

  Widget _eventMessage(entity.Event event) {
    return GestureDetector(
      onTap: () {
        if (widget.selection) {
          setState(() {
            widget.onSelected();
            _selected = !_selected;
          });
        }
      },
      onLongPress: _showMenu,
      child: Container(
        decoration: BoxDecoration(
          color: widget.selection && _selected ? (Colors.blue.shade100) : null,
        ),
        padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (widget.themeInherited.preset.colors.chatEventColor),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    event.description,
                    style: TextStyle(
                        fontSize: 15, color: widget.themeInherited.preset.colors.textColor2),
                  ),
                  _eventSchedule(event),
                  _eventFooter(event),
                ],
              ),
            ),
            IconButton(
              icon: Icon(_favIcon),
              onPressed: _onFavourite,
              color: _favColor,
              iconSize: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventSchedule(entity.Event event) {
    final visited = event.isVisited();
    final missed = event.isMissed();

    if (event.scheduledTime == null) {
      return Container(
        margin: const EdgeInsets.only(top: 5),
        child: Text(
          visited ? 'Visited' : (missed ? 'Missed' : 'No date set'),
          style: TextStyle(
            color: visited
                ? widget.themeInherited.preset.colors.greenTextColor
                : (missed
                    ? widget.themeInherited.preset.colors.redTextColor
                    : widget.themeInherited.preset.colors.blueTextColor),
            fontSize: 13,
          ),
        ),
      );
    }

    final passed = event.scheduledTime!.compareTo(DateTime.now()) < 0;

    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            !passed
                ? 'Scheduled on:'
                : (visited ? 'Visited on' : (missed ? 'Missed on' : 'Passed on:')),
            style: TextStyle(
              color: visited
                  ? widget.themeInherited.preset.colors.greenTextColor
                  : (missed
                      ? widget.themeInherited.preset.colors.redTextColor
                      : widget.themeInherited.preset.colors.blueTextColor),
              fontSize: 12,
            ),
          ),
          Text(
            entity.fullDateFormatter.format(event.scheduledTime!),
            style: TextStyle(
              color: visited
                  ? widget.themeInherited.preset.colors.greenTextColor
                  : (missed
                      ? widget.themeInherited.preset.colors.redTextColor
                      : widget.themeInherited.preset.colors.blueTextColor),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventFooter(entity.Event event) {
    if (event.scheduledTime != null && event.scheduledTime!.compareTo(DateTime.now()) > 0) {
      return Container(
        margin: const EdgeInsets.only(top: 5),
        child: Text(
          entity.timeFormatter.format(event.timeCreated),
          style: TextStyle(fontSize: 15, color: widget.themeInherited.preset.colors.textColor1),
        ),
      );
    }

    if (!event.isMissed() && !event.isVisited()) {
      return Row(
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: widget.themeInherited.preset.colors.greenTextColor,
            ),
            child: const Text(
              'Visited',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => setState(() => event.visit()),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: widget.themeInherited.preset.colors.redTextColor,
            ),
            child: const Text(
              'Missed',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => setState(() => event.miss()),
          ),
          Text(
            entity.timeFormatter.format(event.timeCreated),
            style: TextStyle(fontSize: 15, color: widget.themeInherited.preset.colors.textColor1),
          ),
        ],
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Text(
        entity.timeFormatter.format(event.timeCreated),
        style: TextStyle(fontSize: 15, color: widget.themeInherited.preset.colors.textColor1),
      ),
    );
  }

  Widget _noteMessage(entity.Note note) {
    return GestureDetector(
      onTap: () {
        if (widget.selection) {
          setState(() {
            widget.onSelected();
            _selected = !_selected;
          });
        }
      },
      onLongPress: _showMenu,
      child: Container(
        decoration: BoxDecoration(
          color: widget.selection && _selected ? (Colors.blue.shade100) : null,
        ),
        padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (widget.themeInherited.preset.colors.chatNoteColor),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    note.description,
                    style: TextStyle(
                        fontSize: 15, color: widget.themeInherited.preset.colors.textColor2),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      entity.timeFormatter.format(note.timeCreated),
                      style: TextStyle(
                          fontSize: 15, color: widget.themeInherited.preset.colors.textColor1),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(_favIcon),
              onPressed: _onFavourite,
              color: _favColor,
              iconSize: 22,
            ),
          ],
        ),
      ),
    );
  }

  void _showMenu() {
    showMenu(
      color: widget.themeInherited.preset.colors.backgroundColor,
      context: context,
      position: const RelativeRect.fromLTRB(100.0, 100.0, 100.0, 100.0),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          onTap: widget.onDeleted,
          value: 1,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.delete,
                color: widget.themeInherited.preset.colors.textColor2,
              ),
              Text(
                'Delete',
                style: TextStyle(color: widget.themeInherited.preset.colors.textColor2),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: widget.onEdited,
          value: 2,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.edit,
                color: widget.themeInherited.preset.colors.textColor2,
              ),
              Text(
                'Edit',
                style: TextStyle(color: widget.themeInherited.preset.colors.textColor2),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            widget.onSelection();
            setState(() {
              _selected = true;
              _calledSelection = true;
              widget.onSelected();
            });
          },
          value: 3,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.autofps_select,
                color: widget.themeInherited.preset.colors.textColor2,
              ),
              Text(
                'Select',
                style: TextStyle(color: widget.themeInherited.preset.colors.textColor2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
