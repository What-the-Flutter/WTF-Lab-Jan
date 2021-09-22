import 'package:flutter/material.dart';

import '../screens/add_note_page/add_note_page.dart';
import '../screens/event_page/note_info_page.dart';
import '../screens/home_screen_page/home_screen.dart';

const String mainPage = 'mainPage';
const String addNotePage = 'addNotePage';
const String noteInfoPage = 'noteInfoPage';

Route<dynamic> controller(RouteSettings settings) {
  final args = settings.arguments;

  switch (settings.name) {
    case mainPage:
      return MaterialPageRoute(
        builder: (context) {
          return MainPage();
        },
      );
    case addNotePage:
      if (args is AddNote) {
        return MaterialPageRoute(
          builder: (context) {
            return AddNote(
              // title: args.title,
              // selectedIcon: args.selectedIcon,
              // index: args.index,
            );
          },
        );
      } else {
        return MaterialPageRoute(
          builder: (context) {
            return AddNote();
          },
        );
      }
    case noteInfoPage:
      if (args is NoteInfo) {
        return MaterialPageRoute(
          builder: (context) {
            return NoteInfo(
              // index: args.index,
                // journal: args.journal,
                );
          },
        );
      } else {
        throw ('Incorrect data');
      }
    default:
      throw ('This route does not exist');
  }
}
