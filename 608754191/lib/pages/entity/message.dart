import 'package:flutter/material.dart';

class Message {
  int messageId;
  int currentCategoryId;
  int iconIndex;
  String text;
  String time;

  Message({
    required this.messageId,
    required this.currentCategoryId,
    required this.iconIndex,
    required this.time,
    required this.text,
  });

  Map<String, dynamic> convertMessageToMap() {
    return {
      'current_category_id': currentCategoryId,
      'text': text,
      'time': time,
      'message_icon_index': iconIndex,
    };
  }

  Map<String, dynamic> convertMessageToMapWithId() {
    return {
      'message_id': messageId,
      'current_category_id': currentCategoryId,
      'text': text,
      'time': time,
      'message_icon_index': iconIndex,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['message_id'],
      currentCategoryId: map['current_category_id'],
      text: map['text'],
      time: map['time'],
      iconIndex: map['message_icon_index'],
    );
  }
}
