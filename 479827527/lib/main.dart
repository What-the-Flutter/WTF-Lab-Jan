import 'package:flutter/material.dart';

import 'home_page/home_page.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';
import 'themes/shared_preferences_provider.dart';
import 'themes/theme_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.initialize();
  runApp(
    ThemeSwitcherWidget(
      child: ChatJournal(),
      initialTheme: SharedPreferencesProvider().fetchTheme()
          ? lightThemeData
          : darkThemeData,
    ),
  );
}

class ChatJournal extends StatelessWidget {
  final _appTitle = 'Chat Journal';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _appTitle,
      theme: ThemeSwitcher.of(context).themeData,
      home: HomePage(),
    );
  }
}
