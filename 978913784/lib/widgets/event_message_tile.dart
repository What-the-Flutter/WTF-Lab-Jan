import 'dart:io';

import 'package:chat_journal/labels_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';
import 'package:intl/intl.dart';

import '../data/icon_list.dart';
import '../entity/page.dart';
import '../labels_state.dart';
import '../tab_page/home/event_page/events_cubit.dart';
import '../tab_page/settings_page/settings_cubit.dart';

class EventMessageTile extends StatefulWidget {
  final Event _event;
  final bool _isRightToLeft;
  final bool _isSelected;
  final bool _slidable;
  final Function(String) onHashTap;
  final Function() onTap;
  final Function() onLongPress;
  final Function(Event) onDelete;
  final Function(Event) onEdit;

  EventMessageTile(
    this._event,
    this._isRightToLeft,
    this._slidable,
    this._isSelected, {
    this.onHashTap,
    this.onTap,
    this.onLongPress,
    this.onDelete,
    this.onEdit,
  }) : super(key: ValueKey(_event.id));

  @override
  _EventMessageTileState createState() => _EventMessageTileState(
        _event,
        _isRightToLeft,
        _slidable,
        _isSelected,
        onTap: onTap,
        onLongPress: onLongPress,
        onHashTap: onHashTap,
        onEdit: onEdit,
        onDelete: onDelete,
      );
}

class _EventMessageTileState extends State<EventMessageTile>
    with SingleTickerProviderStateMixin {
  final Event _event;
  final bool _isRightToLeft;
  bool _isSelected;
  final bool _slidable;
  final Function(String) onHashTap;
  final Function() onTap;
  final Function() onLongPress;
  final Function(Event) onDelete;
  final Function(Event) onEdit;

  _EventMessageTileState(
    this._event,
    this._isRightToLeft,
    this._slidable,
    this._isSelected, {
    this.onHashTap,
    this.onTap,
    this.onLongPress,
    this.onDelete,
    this.onEdit,
  });

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInBack,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isSelected = BlocProvider.of<EventCubit>(context).state.selected.contains(_event);

    final labels = BlocProvider.of<LabelsCubit>(context).state;
    final label = LabelsState.labelById(labels, _event.labelId);


    Widget _title(Event event) {

      return Row(
        children: [
          Icon(
            iconList[label.iconIndex],
            color: Theme.of(context).textTheme.bodyText2.color,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              label.description,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText2.color,
                fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
              ),
            ),
          )
        ],
      );
    }

    Widget _content(Event event) {
      return event.imagePath.isEmpty
          ? HashTagText(
              text: event.description,
              basicStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyText2.color,
                fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
              ),
              decoratedStyle: TextStyle(
                color: Colors.yellowAccent,
                fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
              ),
              onTap: onHashTap,
            )
          : Image.file(File(event.imagePath));
    }

    Widget _container() => SlideTransition(
          position: _offsetAnimation,
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: AnimatedContainer(
              margin: _isRightToLeft
                  ? EdgeInsets.only(top: 2, bottom: 2, left: 100, right: 5)
                  : EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft:
                      _isRightToLeft ? Radius.circular(10) : Radius.zero,
                  topRight: Radius.circular(10),
                  bottomRight:
                      _isRightToLeft ? Radius.zero : Radius.circular(10),
                ),
                color: _isSelected
                  ? Theme.of(context).shadowColor
                  : Theme.of(context).accentColor,
              ),
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: 5,
              ),
              duration: Duration(milliseconds: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null) _title(_event),
                  _content(_event),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _event.isFavourite
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellowAccent,
                                  size: 12,
                                ),
                              )
                            : Container(),
                      ),
                      Text(
                        DateFormat('HH:mm').format(_event.creationTime),
                        style: TextStyle(
                          fontSize:
                              SettingsCubit.calculateSize(context, 10, 12, 20),
                          color: Theme.of(context).textTheme.bodyText2.color,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

    return _slidable
        ? Slidable(
            actionPane: SlidableScrollActionPane(),
            actions: [
              IconSlideAction(
                caption: 'Edit',
                color: Theme.of(context).primaryColor,
                icon: Icons.edit_outlined,
                onTap: () => onEdit(_event),
                closeOnTap: true,
              )
            ],
            secondaryActions: [
              IconSlideAction(
                caption: 'Delete',
                color: Theme.of(context).primaryColor,
                icon: Icons.delete_outlined,
                onTap: () async {
                  await _controller.forward();
                  onDelete(_event);
                },
                closeOnTap: true,
              )
            ],
            child: _container(),
          )
        : _container();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

