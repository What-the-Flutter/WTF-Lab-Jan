import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'color_theme.dart';
import 'main_page/main_page.dart';
import 'main_page/pages_cubit.dart';
import 'page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  JournalPage.initCount();
  Event.initCount();
  runApp(
    BlocProvider(
      create: (context) => PagesCubit([])..init(),
      child: MyApp(),
    ),
  );
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
