import 'package:chat_journal/screen/theme/custom_theme.dart';
import 'screen/theme/theme.dart';
import 'package:flutter/material.dart';
import 'navigation/fluro_router.dart';
import 'screen/home_page.dart';

void main() {
  fluroRouter.setupRouter();
  runApp(
    CustomTheme(
      initialThemeKey: myThemes.light,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.of(context),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
