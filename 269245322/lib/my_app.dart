import 'package:flutter/material.dart';

import 'pages/home/home.dart';
import 'pages/home/page_constructor.dart';
import 'pages/page/custom_page.dart';
import 'pages/settings/settings.dart';
import 'style/custom_theme.dart';
import 'style/custom_theme_cubit.dart';

class MyApp extends StatelessWidget {
  final ThemeCubit _noteCubit = ThemeCubit();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.of(context),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        PageConstructor.routeName: (context) => PageConstructor(),
        CustomPage.routeName: (context) => CustomPage(),
        SettingsPage.routeName: (context) => const SettingsPage(),
      },
    );
  }
}
