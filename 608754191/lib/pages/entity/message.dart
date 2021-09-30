import 'package:flutter/material.dart';

class Message {
  int id;
  String text;
  DateTime time;

  @required
  Message({required this.id, required this.time, required this.text});

  Message copyWith({int? id, String? text, DateTime? dateTime}) {
    return Message(id: id ?? this.id, time: dateTime ?? this.time, text: text ?? this.text);
  }
}
