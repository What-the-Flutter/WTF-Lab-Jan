import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Message {
  String text;
  final DateTime _date;
  final String? _event;
  bool favourite;

  Message(this.text, this._date, [this._event, this.favourite = false]);

  String get time => DateFormat('dd MMMM yyyy').format(_date);

  String? get event => _event;

  void setFavourite() => favourite = !favourite;

  bool isEqual(Message e) => time == e.time;

  Widget widgetWithDate(Color color) {
    return Column(
      children: [
        Center(
          child: Text(
            time,
          ),
        ),
        const Divider(),
        widget(color),
      ],
    );
  }

  Widget widget(Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              text,
            ),
            // TODO: figure out why every message block expands on whole screen width with commented code
            // TODO: if previous solved - align bookmark icon to the right
            // TODO: after that add optional widget to show event if not null
            /*Row(
              children: [
                Text(
                  DateFormat.Hm().format(_date),
                ),
                favourite
                    ? const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.bookmark,
                          size: 15,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
