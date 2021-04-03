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

class ListTileSettingsTheme {
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final Color leadingIconColor;

  ListTileSettingsTheme({
    this.titleStyle,
    this.contentStyle,
    this.leadingIconColor,
  });
}
