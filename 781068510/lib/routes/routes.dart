import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/data/journal_cubit.dart';

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
      return MaterialPageRoute(builder: (context) {
        return BlocProvider<JournalCubit>(
            create: (context) => JournalCubit()..initJournals(),
            child: MainPage());
      });
    case addNotePage:
      if (args is AddNote) {
        return MaterialPageRoute(
          builder: (context) => BlocProvider<JournalCubit>(
            create: (context) => JournalCubit()..initJournals(),
            child: AddNote(
              title: args.title,
              selectedIcon: args.selectedIcon,
              index: args.index,
            ),
          ),
        );
      } else {
        return MaterialPageRoute(
          builder: (context) => BlocProvider<JournalCubit>(
            create: (context) => JournalCubit()..initJournals(),
            child: AddNote(),
          ),
        );
      }
    case noteInfoPage:
      if (args is NoteInfo) {
        return MaterialPageRoute(
          builder: (context) => BlocProvider<JournalCubit>(
            create: (context) => JournalCubit()..initJournals(),
            child: NoteInfo(
              index: args.index,
              journal: args.journal,
            ),
          ),
        );
      } else {
        throw ('Incorrect data');
      }
    default:
      throw ('This route does not exist');
  }
}
