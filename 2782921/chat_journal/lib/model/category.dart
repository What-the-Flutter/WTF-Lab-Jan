import 'package:flutter/material.dart';

import 'message_data.dart';

class Category {

  String title;
  Widget icon;
  DateTime? createdTime;
  List<MessageData>? message;

  Category({

    required this.title,
    required this.icon,
    this.createdTime,
  }) : message = <MessageData>[];
}
