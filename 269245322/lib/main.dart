import 'package:flutter/material.dart';

import 'page_constructor.dart';
import 'pages/home/home.dart';
import 'pages/page/custom_page.dart';
import 'style/custom_theme.dart';
import 'style/themes.dart';

void main() {
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.light,
      key: UniqueKey(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.of(context),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        PageConstructor.routeName: (context) => PageConstructor(),
        CustomPage.routeName: (context) => CustomPage(),
      },
    );
  }
}
