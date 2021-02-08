import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_theme_provider.dart';
import 'home_page.dart';

void main() {
  runApp(App());
}

///Main class of app.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: 'Chat journal',
            themeMode: themeProvider.themeMode,
            theme: CustomThemes.lightTheme,
            darkTheme: CustomThemes.darkTheme,
            home: HomePage(
              title: 'Home',
            ),
          );
        },
      );
}
