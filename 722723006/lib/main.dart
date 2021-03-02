import 'package:flutter/material.dart';

import 'home_page.dart';
import 'light_theme.dart';
import 'theme.dart';

void main() => runApp(ThemeSwitcherWidget(
      initialTheme: lightTheme,
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Journal',
      theme: ThemeSwitcher.of(context).themeData,
      home: HomePage(
        title: 'Home',
      ),
    );
  }
}
