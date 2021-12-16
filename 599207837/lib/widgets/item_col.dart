import 'package:flutter/material.dart';
import '../entity/entities.dart' as entity;
import '../main.dart';

class ItemColumn<T> extends StatelessWidget {
  final T item;

  const ItemColumn(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item is entity.Task) {
      return _TaskColumn(item as entity.Task);
    } else if (item is entity.Event) {
      return _EventColumn(item as entity.Event);
    } else {
      return Column(
        children: <Widget>[
          Text((item as entity.Note).name ?? 'No name'),
          Text((item as entity.Note).description),
        ],
      );
    }
  }
}

class _TaskColumn extends StatelessWidget {
  final entity.Task item;

  const _TaskColumn(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _taskHeader(item),
        Text(item.description),
        _taskFooter(item, context),
      ],
    );
  }

  Widget _taskHeader(entity.Task task) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: task.topic.getImageProvider(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(task.topic.name),
          ),
        )
      ],
    );
  }

  Widget _taskFooter(entity.Task task, BuildContext context) {
    if (task.isCompleted) {
      return Container(
        margin: const EdgeInsets.only(top: 8.0),
        alignment: Alignment.centerRight,
        child: Chip(
          label: Text(
            'Completed at: ${entity.dateFormatter.format(task.timeCompleted!)}',
          ),
        ),
      );
    }

    if (!task.isCompleted) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            child: const Text('Remove'),
            onPressed: () {
              final inherited = TabContrDecorator.of(context)!;
              inherited.pendingTasks.remove(task);
              task.topic.decContent();
              inherited.onEdited();
            },
          ),
          TextButton(
            child: const Text('Complete'),
            onPressed: () {
              final inherited = TabContrDecorator.of(context)!;
              task.complete();
              task.timeCompleted = DateTime.now();
              inherited.onEdited();
            },
          ),
        ],
      );
    }
    return Container();
  }
}

class _EventColumn extends StatelessWidget {
  final entity.Event item;

  const _EventColumn(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _eventHeader(item),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                item.description,
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _eventSchedule(item),
            ),
          ],
        ),
        _eventFooter(item, context),
      ],
    );
  }

  Row _eventHeader(entity.Event event) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: event.topic.getImageProvider(),
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(event.topic.name)),
        ),
      ],
    );
  }

  Widget _eventSchedule(entity.Event event) {
    if (event.scheduledTime == null) {
      return Container(
        margin: const EdgeInsets.only(top: 8.0),
        alignment: Alignment.centerRight,
        child: const Chip(
          label: Text('No date set'),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      alignment: Alignment.centerRight,
      child: Chip(
        label: Text(
          event.scheduledTime!.compareTo(DateTime.now()) > 0
              ? 'Scheduled on: ${entity.dateFormatter.format(event.scheduledTime!)}'
              : 'Passed on: ${entity.dateFormatter.format(event.scheduledTime!)}',
        ),
      ),
    );
  }

  Widget _eventFooter(entity.Event event, BuildContext context) {
    if (event.scheduledTime != null &&
        event.scheduledTime!.compareTo(DateTime.now()) > 0) {
      Duration? period = event.scheduledTime!.difference(DateTime.now());
      return Container(
        alignment: Alignment.center,
        child: Text(
          'Will happen in ${period.inDays} days ${period.inHours % 24} hours',
        ),
      );
    }

    if (!event.isMissed() && !event.isVisited()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.teal,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            child: const Text('Visited'),
            onPressed: () {
              event.visit();
              final inherited = TabContrDecorator.of(context)!;
              inherited.onEdited();
            },
          ),
          TextButton(
            child: const Text('Missed'),
            onPressed: () {
              event.miss();
              final inherited = TabContrDecorator.of(context)!;
              inherited.onEdited();
            },
          ),
        ],
      );
    }
    return Container(
      alignment: Alignment.center,
      child: Text(event.isVisited() ? 'Visited' : 'Missed'),
    );
  }
}