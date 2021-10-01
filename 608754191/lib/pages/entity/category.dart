import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'message.dart';

class Category extends Equatable {
  final String title;
  final IconData iconData;
  final List<Message> listMessages;

  Category({
    required this.title,
    required this.iconData,
    required this.listMessages,
  });

  Category copyWith({
    String? title,
    String? subtitle,
    IconData? iconData,
    List<Message>? listMessages,
  }) {
    return Category(
      title: title ?? this.title,
      iconData: iconData ?? this.iconData,
      listMessages: listMessages ?? this.listMessages,
    );
  }

  @override
  List<Object?> get props => [title, iconData, listMessages];
}
