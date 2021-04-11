import 'package:flutter/material.dart';

class ChatPreviewTheme {
  final TextStyle titleStyle;
  final TextStyle contentStyle;

  ChatPreviewTheme({
    this.titleStyle,
    this.contentStyle,
  });
}

class BotTheme {
  final TextStyle contentStyle;
  final Color iconColor;
  final Color backgroundColor;

  BotTheme({
    this.contentStyle,
    this.iconColor,
    this.backgroundColor,
  });
}

class CategoryTheme {
  final Color backgroundColor;
  final Color iconColor;

  CategoryTheme({
    this.backgroundColor,
    this.iconColor,
  });
}

class MessageTheme {
  final TextStyle contentStyle;
  final TextStyle timeStyle;
  final Color unselectedColor;
  final Color selectedColor;

  MessageTheme({
    this.contentStyle,
    this.timeStyle,
    this.unselectedColor,
    this.selectedColor,
  });
}

class DateTimeModButtonTheme {
  final Color backgroundColor;
  final Color iconColor;
  final TextStyle dateStyle;

  DateTimeModButtonTheme({
    this.backgroundColor,
    this.iconColor,
    this.dateStyle,
  });
}

class LabelDateTheme {
  final Color backgroundColor;
  final TextStyle dateStyle;

  LabelDateTheme({
    this.backgroundColor,
    this.dateStyle,
  });
}

class HelpWindowTheme {
  final Color backgroundColor;
  final TextStyle titleStyle;
  final TextStyle contentStyle;

  HelpWindowTheme({
    this.backgroundColor,
    this.titleStyle,
    this.contentStyle,
  });
}

class ListTileTheme {
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final Color leadingIconColor;

  ListTileTheme({
    this.titleStyle,
    this.contentStyle,
    this.leadingIconColor,
  });

  ListTileTheme copyWith({
    final TextStyle titleStyle,
    final TextStyle contentStyle,
    final Color leadingIconColor,
  }) {
    return ListTileTheme(
      titleStyle: titleStyle ?? this.titleStyle,
      contentStyle: contentStyle ?? this.contentStyle,
      leadingIconColor: leadingIconColor ?? this.leadingIconColor,
    );
  }
}

class TagTheme {
  final TextStyle nameStyle;
  final Color backgroundColor;
  final double radius;

  TagTheme({
    this.nameStyle,
    this.backgroundColor,
    this.radius,
  });
}
