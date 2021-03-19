import 'package:flutter/material.dart';

import 'home_page/home_page.dart';
import 'themes/light_theme.dart';
import 'themes/theme_switcher.dart';

void main() {
  runApp(
    ThemeSwitcherWidget(
      child: ChatJournal(),
      initialTheme: lightThemeData,
    ),
  );
}

class ChatJournal extends StatelessWidget {
  final _appTitle = 'Chat Journal';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _appTitle,
      theme: ThemeSwitcher.of(context).themeData,
      home: HomePage(),
    );
  }
}
