import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen/home_page.dart';
import 'theme/screens_theme.dart';

void main() => runApp(AppTracker());

class AppTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StateWidget(
        child: Builder(
          builder: (context) {
            return MaterialApp(
              theme: ScreensThemeState.of(context).currentTheme,
              title: 'Events',
              home: HomePage(),
            );
          },
        )
      );
}
