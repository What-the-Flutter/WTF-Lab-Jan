import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';
import 'package:intl/intl.dart';

import '../data/icon_list.dart';
import '../entity/page.dart';
import '../settings_page/settings_cubit.dart';

class EventMessageTile extends StatelessWidget {
  final Event _event;
  final bool _isRightToLeft;
  final bool _isSelected;
  final Function(String) onHashTap;
  final Function() onTap;
  final Function() onLongPress;

  EventMessageTile(
    this._event,
    this._isRightToLeft,
    this._isSelected, {
    this.onHashTap,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Widget _title(Event event) {
      return Row(
        children: [
          Icon(
            eventIconList[event.iconIndex],
            color: Theme.of(context).textTheme.bodyText2.color,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              eventStringList[event.iconIndex],
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

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: _isRightToLeft
            ? EdgeInsets.only(top: 2, bottom: 2, left: 100, right: 5)
            : EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: _isRightToLeft ? Radius.circular(10) : Radius.zero,
            topRight: Radius.circular(10),
            bottomRight: _isRightToLeft ? Radius.zero : Radius.circular(10),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_event.iconIndex != 0) _title(_event),
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
                    fontSize: SettingsCubit.calculateSize(context, 10, 12, 20),
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
    );
  }
}
