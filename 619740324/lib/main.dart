import 'package:flutter/material.dart';

import 'data/shared_preferences_provider.dart';
import 'home_page/home_page.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.initialize();
  runApp(
    ThemeSwitcherWidget(
      initialTheme:
      SharedPreferencesProvider().fetchTheme() ? lightThemeData : darkThemeData,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter project',
      theme: ThemeSwitcher.of(context).themeData,
      home: HomePage(),
    );
  }
}
