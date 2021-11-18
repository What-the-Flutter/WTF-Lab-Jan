import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'home_page_view.dart';
import 'theme_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        builder: (context, __) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'Chat Journal',
            themeMode: themeProvider.theme,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            home: const HomePage(title: 'Home'),
          );
        },
      );
}
