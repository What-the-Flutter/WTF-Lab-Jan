import 'package:flutter/material.dart';

import 'message.dart';

class Category {
  late final String title;
  final String subtitle;
  late final IconData iconData;
  List<Message> listMessages;

  Category(
    this.title,
    this.subtitle,
    this.iconData,
    this.listMessages,
  );

  Category copyWith(
      {String? title, String? subtitle, IconData? iconData, List<Message>? listMessages}) {
    return Category(
      title ?? this.title,
      subtitle ?? this.subtitle,
      iconData ?? this.iconData,
      listMessages ?? this.listMessages,
    );
  }
}
