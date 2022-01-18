import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../entity/entities.dart' as entity;
import 'items_page/items_page_cubit.dart';

class ItemColumn<T> extends StatelessWidget {
  final T _item;

  const ItemColumn(this._item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_item is entity.Task) {
      return _TaskColumn(_item as entity.Task);
    } else if (_item is entity.Event) {
      return _EventColumn(_item as entity.Event);
    } else {
      return Column(
        children: <Widget>[
          Text((_item as entity.Note).description),
        ],
      );
    }
  }
}

class _TaskColumn extends StatelessWidget {
  final entity.Task _item;

  const _TaskColumn(this._item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _taskHeader(_item),
        Text(_item.description),
        _taskFooter(_item, context),
      ],
    );
  }

  Widget _taskHeader(entity.Task task) {
    return Row(
      children: <Widget>[
        const CircleAvatar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(task.topic.name),
          ),
        ),
      ],
    );
  }

  Widget _taskFooter(entity.Task task, BuildContext context) {
    if (task.isCompleted) {
      return Container(
        margin: const EdgeInsets.only(top: 8.0),
        alignment: Alignment.centerRight,
        child: Chip(
          label: Text('Completed at: ${entity.fullDateFormatter.format(task.timeCompleted!)}'),
        ),
      );
    }

    if (!task.isCompleted) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            child: const Text('Remove'),
            onPressed: () => context.read<ItemsPageCubit>().removeTask(task),
          ),
          TextButton(
            child: const Text('Complete'),
            onPressed: () => context.read<ItemsPageCubit>().completeTask(task),
          ),
        ],
      );
    }
    return Container();
  }
}

class _EventColumn extends StatelessWidget {
  final entity.Event _item;

  const _EventColumn(this._item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _eventHeader(_item),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                _item.description,
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _eventSchedule(_item),
            ),
          ],
        ),
        _eventFooter(_item, context),
      ],
    );
  }

  Row _eventHeader(entity.Event event) {
    return Row(
      children: <Widget>[
        const CircleAvatar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(event.topic.name),
          ),
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
              ? 'Scheduled on: ${entity.fullDateFormatter.format(event.scheduledTime!)}'
              : 'Passed on: ${entity.fullDateFormatter.format(event.scheduledTime!)}',
        ),
      ),
    );
  }

  Widget _eventFooter(entity.Event event, BuildContext context) {
    if (event.scheduledTime != null && event.scheduledTime!.compareTo(DateTime.now()) > 0) {
      Duration? period = event.scheduledTime!.difference(DateTime.now());
      return Container(
        alignment: Alignment.center,
        child: Text('Will happen in ${period.inDays} days ${period.inHours % 24} hours'),
      );
    }

    if (!event.isMissed && !event.isVisited) {
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
            onPressed: () => context.read<ItemsPageCubit>().visitEvent(event),
          ),
          TextButton(
            child: const Text('Missed'),
            onPressed: () => context.read<ItemsPageCubit>().missEvent(event),
          ),
        ],
      );
    }
    return Container(
      alignment: Alignment.center,
      child: Text(event.isVisited ? 'Visited' : 'Missed'),
    );
  }
}
