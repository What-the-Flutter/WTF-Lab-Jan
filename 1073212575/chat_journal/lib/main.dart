import 'package:chat_journal/themes.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'custom_theme.dart';

void main() {
  runApp(CustomTheme(
    themeData: lightTheme,
    child: MyApp(),
  ),);
}