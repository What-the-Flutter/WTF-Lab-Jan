import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../screens/add_note_page/add_note_page.dart';
import '../screens/home_screen_page/home_screen.dart';
import '../screens/info_page/note_info_page.dart';

const String mainPage = 'mainPage';
const String addNotePage = 'addNotePage';
const String noteInfoPage = 'noteInfoPage';

Route<dynamic> controller(RouteSettings settings) {
  final args = settings.arguments;

  switch (settings.name) {
    case mainPage:
      return MaterialPageRoute(builder: (context) => MainPage());
    case addNotePage:
      if (args is AddNote) {
        return MaterialPageRoute(
          builder: (context) => AddNote(
            title: args.title,
            selectedIcon: args.selectedIcon,
            index: args.index,
          ),
        );
      } else {
        return MaterialPageRoute(
          builder: (context) => AddNote(),
        );
      }
    case noteInfoPage:
      if (args is Journal) {
        return MaterialPageRoute(builder: (context) => NoteInfo(journal: args));
      } else {
        throw ('Incorrect data');
      }
    default:
      throw ('This route does not exist');
  }
}
