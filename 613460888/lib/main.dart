import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'home_page/home_page.dart';
import 'themes/light_theme.dart';
import 'themes/theme_switcher.dart';


void main() {
  runApp(
      ThemeSwitcherWidget(
        child: MyApp(),
        initialTheme: lightTheme,

      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      themeMode: ThemeMode.system,
      theme: ThemeSwitcher.of(context).themeData,
      home: HomePage(title: 'Home'),
    );
  }
}
