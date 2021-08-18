import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/main_page/main_page.dart';
import 'services/my_themes.dart';
import 'services/switch_themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(),
      child: Builder(
        builder: (context) {
          final themeChanger = Provider.of<ThemeChanger>(context);
          return MaterialApp(
            title: 'Chat Journal',
            themeMode: themeChanger.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: MainPage(),
          );
        },
      ),
    );
  }
}