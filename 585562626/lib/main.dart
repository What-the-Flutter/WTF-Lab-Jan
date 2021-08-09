import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'models/category.dart';
import 'pages/category_notes_page.dart';
import 'pages/home_page.dart';
import 'pages/new_category_page.dart';
import 'pages/starred_notes_page.dart';
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
    theme = darkModeOn ? darkTheme : lightTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      theme: theme,
      switchTheme: switchTheme,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Cool Notes',
            theme: AppTheme.of(context).theme,
            home: HomePage(
              categories: [
                NoteCategory(name: 'Sports', color: Colors.orangeAccent, image: 'sports.png'),
                NoteCategory(name: 'Travel', color: Colors.lightBlue, image: 'travel.png'),
                NoteCategory(name: 'Family', color: Colors.indigoAccent, image: 'family.png'),
              ],
            ),
            onGenerateRoute: (settings) {
              Route pageRoute(Widget destination) => MaterialPageRoute(builder: (_) => destination);
              switch (settings.name) {
                case CategoryNotesPage.routeName:
                  final args = settings.arguments as CategoryNotesArguments;
                  return pageRoute(
                    CategoryNotesPage(category: args.category, notes: args.notes),
                  );
                case StarredNotesPage.routeName:
                  final args = settings.arguments as StarredNotesArguments;
                  return pageRoute(
                    StarredNotesPage(notes: args.notes, deleteNote: args.deleteNote),
                  );
                case NewCategoryPage.routeName:
                  final args = settings.arguments as NewCategoryArguments?;
                  return pageRoute(NewCategoryPage(editCategory: args?.category));
              }
            },
          );
        },
      ),
    );
  }
}
