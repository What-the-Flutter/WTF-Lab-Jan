import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'home_page_view.dart';
import 'theme_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, __) {
          //final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'Chat Journal',
            //themeMode: themeProvider.theme,
            themeMode: ThemeMode.system,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            home: const HomePage(title: 'Home'),
          );
        },
      );
}
