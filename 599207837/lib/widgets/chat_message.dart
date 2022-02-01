import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipe_to/swipe_to.dart';

import '../database/database.dart';
import '../database/firebase/storage_provider.dart';
import '../entity/entities.dart';
import 'alerts.dart';
import 'theme_provider/theme_cubit.dart';

class ChatMessage extends StatefulWidget {
  final Message item;
  final void Function() onDeleted;
  final Function() onEdited;
  final Function() onSelection;
  final Function() onSelected;
  final bool selection;

  const ChatMessage({
    Key? key,
    required this.item,
    required this.onDeleted,
    required this.onEdited,
    required this.onSelection,
    required this.onSelected,
    required this.selection,
  }) : super(key: key);

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
    MessageRepository.onFavourite(widget.item);
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
    if (_calledSelection) {
      _selected = true;
      _calledSelection = false;
    }
    if (!widget.selection) _selected = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
    return Container(
      decoration: BoxDecoration(
        color: widget.selection && _selected ? (Colors.blue.shade100) : null,
      ),
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: SwipeTo(
        onLeftSwipe: widget.selection ? null : widget.onDeleted,
        onRightSwipe: widget.selection ? null : widget.onEdited,
        iconOnLeftSwipe: Icons.delete_outline_rounded,
        iconOnRightSwipe: Icons.edit_outlined,
        iconColor: theme.colors.textColor1,
        animationDuration: const Duration(milliseconds: 300),
        offsetDx: 0.25,
        child: _innerMessage(),
      ),
    );
  }

  Widget _innerMessage() {
    if (widget.item is Task) {
      return _taskMessage(widget.item as Task);
    } else if (widget.item is Event) {
      return _eventMessage(widget.item as Event);
    } else {
      return _noteMessage(widget.item as Note);
    }
  }

  Widget _taskMessage(Task task) {
    final theme = context.read<ThemeCubit>().state;
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
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.colors.chatTaskColor,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  task.description,
                  style: TextStyle(fontSize: 15, color: theme.colors.textColor2),
                ),
                _attachedImage(task.imageName, context),
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
    );
  }

  Widget _taskMessageFooter(Task task) {
    final theme = context.read<ThemeCubit>().state;
    if (!task.isCompleted) {
      return Row(
        children: [
          TextButton(
            child: Text(
              'Complete',
              style: TextStyle(color: theme.colors.blueTextColor),
            ),
            onPressed: () {
              setState(() => MessageRepository.completeTask(task));
            },
          ),
          Text(
            timeFormatter.format(task.timeCreated),
            style: TextStyle(fontSize: 15, color: theme.colors.textColor1),
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
              color: theme.colors.blueTextColor,
              fontSize: 12,
            ),
          ),
          Text(
            '${fullDateFormatter.format(task.timeCompleted!)}',
            style: TextStyle(
              color: theme.colors.blueTextColor,
              fontSize: 13,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              timeFormatter.format(task.timeCreated),
              style: TextStyle(fontSize: 15, color: theme.colors.textColor1),
            ),
          ),
        ],
      );
    }
  }

  Widget _eventMessage(Event event) {
    final theme = context.read<ThemeCubit>().state;

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
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (theme.colors.chatEventColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  event.description,
                  style: TextStyle(fontSize: 15, color: theme.colors.textColor2),
                ),
                _attachedImage(event.imageName, context),
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
    );
  }

  Widget _eventSchedule(Event event) {
    final theme = context.read<ThemeCubit>().state;
    final visited = event.isVisited;
    final missed = event.isMissed;

    if (event.scheduledTime == null) {
      return Container(
        margin: const EdgeInsets.only(top: 5),
        child: Text(
          visited ? 'Visited' : (missed ? 'Missed' : 'No date set'),
          style: TextStyle(
            color: visited
                ? theme.colors.greenTextColor
                : (missed ? theme.colors.redTextColor : theme.colors.blueTextColor),
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
                  ? theme.colors.greenTextColor
                  : (missed ? theme.colors.redTextColor : theme.colors.blueTextColor),
              fontSize: 12,
            ),
          ),
          Text(
            fullDateFormatter.format(event.scheduledTime!),
            style: TextStyle(
              color: visited
                  ? theme.colors.greenTextColor
                  : (missed ? theme.colors.redTextColor : theme.colors.blueTextColor),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventFooter(Event event) {
    final theme = context.read<ThemeCubit>().state;
    if (event.scheduledTime != null && event.scheduledTime!.compareTo(DateTime.now()) > 0) {
      return Container(
        margin: const EdgeInsets.only(top: 5),
        child: Text(
          timeFormatter.format(event.timeCreated),
          style: TextStyle(fontSize: 15, color: theme.colors.textColor1),
        ),
      );
    }

    if (!event.isMissed && !event.isVisited) {
      return Row(
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: theme.colors.greenTextColor,
            ),
            child: const Text(
              'Visited',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => setState(() => MessageRepository.visitEvent(event)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: theme.colors.redTextColor,
            ),
            child: const Text(
              'Missed',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => setState(() => MessageRepository.missEvent(event)),
          ),
          Text(
            timeFormatter.format(event.timeCreated),
            style: TextStyle(fontSize: 15, color: theme.colors.textColor1),
          ),
        ],
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Text(
        timeFormatter.format(event.timeCreated),
        style: TextStyle(fontSize: 15, color: theme.colors.textColor1),
      ),
    );
  }

  Widget _noteMessage(Note note) {
    final theme = context.read<ThemeCubit>().state;
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
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (theme.colors.chatNoteColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  note.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.colors.textColor2,
                  ),
                ),
                _attachedImage(note.imageName, context),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    timeFormatter.format(note.timeCreated),
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.colors.textColor1,
                    ),
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
    );
  }

  Widget _attachedImage(String? imageName, BuildContext context) {
    return imageName == null
        ? Container()
        : Container(
            constraints: const BoxConstraints(maxHeight: 200, maxWidth: 200),
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: FutureBuilder(
              future: StorageProvider.getImageUrl(imageName),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.network(
                    snapshot.data as String,
                    fit: BoxFit.contain,
                  );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                }
              },
            ),
          );
  }

  void _showMenu() {
    final theme = context.read<ThemeCubit>().state;
    showMenu(
      color: theme.colors.backgroundColor,
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
                color: theme.colors.textColor2,
              ),
              const SizedBox(width: 5),
              Text(
                'Delete',
                style: TextStyle(color: theme.colors.textColor2),
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
                color: theme.colors.textColor2,
              ),
              const SizedBox(width: 5),
              Text(
                'Edit',
                style: TextStyle(color: theme.colors.textColor2),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => setState(() {
            _selected = true;
            _calledSelection = true;
            widget.onSelected();
            widget.onSelection();
          }),
          value: 3,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.autofps_select,
                color: theme.colors.textColor2,
              ),
              const SizedBox(width: 5),
              Text(
                'Select',
                style: TextStyle(color: theme.colors.textColor2),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => Future<void>.delayed(
            const Duration(),
            () => Alerts.moveAlert(
              context: context,
              currentTopic: widget.item.topic,
              onMoved: (topic) {
                final added = widget.item.duplicate();
                widget.onDeleted();
                added.topic = topic;
                MessageRepository.add(added);
                Navigator.pop(context);
              },
            ),
          ),
          value: 4,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.drive_file_move_outline,
                color: theme.colors.textColor2,
              ),
              const SizedBox(width: 5),
              Text(
                'Move',
                style: TextStyle(color: theme.colors.textColor2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
