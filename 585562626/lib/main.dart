import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'models/category.dart';
import 'pages/home_page.dart';
import 'utils/themes.dart';
import 'widgets/inherited/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData theme;

  void switchTheme() {
    setState(() {
      if (theme == darkTheme) {
        theme = lightTheme;
      } else {
        theme = darkTheme;
      }
    });
  }

  @override
  void initState() {
    var brightness = SchedulerBinding.instance?.window.platformBrightness;
    var darkModeOn = brightness == Brightness.dark;
    theme = darkModeOn ? lightTheme : darkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      theme: theme,
      switchTheme: switchTheme,
      child: LayoutBuilder(
        builder: (context, _) {
          return MaterialApp(
            title: 'Cool Notes',
            theme: AppTheme.of(context).theme,
            home: HomePage(
              title: 'Home',
              categories: [
                NoteCategory('Sports', Colors.orangeAccent, 'sports.png'),
                NoteCategory('Travel', Colors.lightBlue, 'travel.png'),
                NoteCategory('Family', Colors.indigoAccent, 'family.png'),
              ],
            ),
          );
        },
      ),
    );
  }
}
