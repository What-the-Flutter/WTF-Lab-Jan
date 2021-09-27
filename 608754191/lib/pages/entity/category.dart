import 'package:flutter/material.dart';

import 'message.dart';

class Category {
  late final String title;
  late final IconData iconData;
  List<Message> listMessages;

  Category(
    this.title,
    this.iconData,
    this.listMessages,
  );

  Category copyWith(
      {String? title, String? subtitle, IconData? iconData, List<Message>? listMessages}) {
    return Category(
      title ?? this.title,
      iconData ?? this.iconData,
      listMessages ?? this.listMessages,
    );
  }
}
