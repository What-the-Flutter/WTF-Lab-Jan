// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'color_theme.dart';
import 'main_page/main_page.dart';
import 'main_page/pages_bloc.dart';
import 'page.dart';

final List<JournalPage> pages = [
  JournalPage('Flutter Tasks', Icons.work, creationTime: DateTime.now())
    ..addEvent(Event('Rewrite to BloC architecture'))
    ..addEvent(Event('Add search button'))
    ..addEvent(Event('Implement the ability to transfer events'))
    ..addEvent(Event('Implement the ability to select a category when sending an event.'))
    ..isPinned = true,
  JournalPage('Fire', Icons.whatshot, creationTime: DateTime.now())..addEvent(Event('My new note')),
  JournalPage('Notes', Icons.notes, creationTime: DateTime.now())..addEvent(Event('First Node')),
  JournalPage('Food', Icons.fastfood, creationTime: DateTime.now()),
  JournalPage('Flight', Icons.airplanemode_active, creationTime: DateTime.now())
    ..addEvent(Event('My new note')),
  JournalPage('Sport', Icons.sports_football, creationTime: DateTime.now()),
  JournalPage('Family', Icons.family_restroom, creationTime: DateTime.now())
    ..addEvent(Event('My new note')),
];

void main() {
  runApp(BlocProvider(
    create: (context) {
      return PagesBloc(pages);
    },
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColorTheme(
      key: ColorThemeData.appThemeStateKey,
      child: MaterialApp(
        title: 'Chat Journal',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: MainPage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
