import 'package:flutter/material.dart';

import 'custom_themes.dart';
import 'screens/create_page.dart';
import 'screens/home_page.dart';
import 'themes.dart';

void main() {
  runApp(
    CustomTheme(
      themeData: MyThemes.light,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Diary',
      theme: CustomTheme.of(context),
      home: HomePage(),
      routes: {'/create-page': (context) => CreatePage()},
    );
  }
}
