import 'package:flutter/material.dart';

import '/screens/main_screen.dart';
import '/theme/custom_theme.dart';
import '/theme/theme_color.dart';

void main() => runApp(
      CustomTheme(
        themeData: lightTheme,
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.of(context),
      title: 'Chat Journal',
      home: MainScreen(),
    );
  }
}
