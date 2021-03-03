import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme.dart';
import 'home_page/home_page.dart';
import 'home_page/pages_cubit.dart';
import 'page.dart';

// final List<JournalPage> pages = [
//   JournalPage('Work', Icons.work_outlined)
//     ..addEvent(Event('My new note', 0))
//     ..isPinned = true,
//   JournalPage('Really big title text', Icons.whatshot)
//     ..addEvent(Event('My new note', 0)),
//   JournalPage('Notes', Icons.notes)
//     ..addEvent(Event(
//         'Помоги! Покажи мне дорогу через травы, кустарники, чащу леса. '
//         'Я за кроной из своих сомнений солнца не вижу, но может быть если... '
//         'Если найду я тайные тропы, если найду я смысл, если в слова смогу '
//         'облачить блуждающую свою мысль',
//         0)),
//   JournalPage('Food', Icons.fastfood),
//   JournalPage('Flight', Icons.airplanemode_active)
//     ..addEvent(Event('My new note', 0)),
//   JournalPage('Спорт', Icons.sports_football),
//   JournalPage('家族', Icons.family_restroom)..addEvent(Event('My new note', 0)),
// ];

 void main() {
   WidgetsFlutterBinding.ensureInitialized();
   JournalPage.initCount();
   Event.initCount();
  runApp(BlocProvider(
    create: (context) => PagesCubit([])..init(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppTheme(
      key: AppThemeData.appThemeStateKey,
      child: MaterialApp(
        title: 'Chat Journal',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: HomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
