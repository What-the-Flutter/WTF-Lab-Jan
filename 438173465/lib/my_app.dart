import 'package:flutter/material.dart';
import 'pages/event_screen.dart';
import 'pages/home_page.dart';
import 'theme_changer.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultBrightness: Brightness.light,
      builder: (context, _brightness) {
        return MaterialApp(
          routes: {
            EventScreen.routeName: (context) => EventScreen(),
          },
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            brightness: _brightness,
          ),
          home: MyHomePage(),
        );
      },
    );
  }
}