import 'package:flutter/material.dart';

import '../modules/theme.dart';
import 'screens/create_page_screen.dart';
import 'screens/home_screen.dart';
import 'screens/page_screen.dart';

void main() => runApp(
      StatefulCustomTheme(
        child: const MyApp(),
        themeData: CustomTheme.dark,
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'WTF Chat Journal';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const HomeScreen(),
      routes: {
        '/event-screen': (context) => const PageScreen(),
        '/create-screen': (context) => const CreatePageScreen(),
      },
      theme: InheritedCustomTheme.of(context).themeData,
    );
  }
}
